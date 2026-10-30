import Foundation
import Domain
import Persistence
import Subscription
import WorkoutEngine
import Coaching

/// Composition root — monta dependências entre módulos SPM (único ponto de wiring).
@MainActor
public struct AppEnvironment {
    public let personalRecordClient: PersonalRecordClient
    public let subscriptionClient: SubscriptionClient
    public let workoutEngineClient: WorkoutEngineClient
    public let settingsClient: SettingsClient
    public let notificationManager: LocalNotificationManager
    public let coachingClient: CoachingClient
    public let workoutSessionClient: WorkoutSessionClient
    public let healthMetricsClient: HealthMetricsClient

    public init(
        personalRecordClient: PersonalRecordClient,
        subscriptionClient: SubscriptionClient,
        workoutEngineClient: WorkoutEngineClient,
        settingsClient: SettingsClient,
        notificationManager: LocalNotificationManager,
        coachingClient: CoachingClient,
        workoutSessionClient: WorkoutSessionClient,
        healthMetricsClient: HealthMetricsClient
    ) {
        self.personalRecordClient = personalRecordClient
        self.subscriptionClient = subscriptionClient
        self.workoutEngineClient = workoutEngineClient
        self.settingsClient = settingsClient
        self.notificationManager = notificationManager
        self.coachingClient = coachingClient
        self.workoutSessionClient = workoutSessionClient
        self.healthMetricsClient = healthMetricsClient
    }

    public static func make(
        subscriptionStore: (any SubscriptionStoreProviding)? = nil,
        repository: (any PersonalRecordRepository)? = nil,
        sessionRepository: (any WorkoutSessionRepository)? = nil,
        healthProvider: (any HealthKitSessionMetricsProviding)? = nil
    ) -> AppEnvironment {
        let useInMemorySeed = UITestLaunchSupport.seedScenario != nil
        let resolvedRepository = repository
            ?? PersistenceFactory.makeRepository(inMemory: useInMemorySeed)
        let resolvedSessions = sessionRepository
            ?? PersistenceFactory.makeWorkoutSessionRepository(inMemory: useInMemorySeed)

        let subscription: SubscriptionClient
        if let store = subscriptionStore {
            subscription = SubscriptionClient(store: store)
        } else if UITestLaunchSupport.prefersStoreKitConfiguration {
            subscription = SubscriptionClient(store: StoreKitSubscriptionStore())
        } else if let tier = UITestLaunchSupport.subscriptionTierOverride {
            subscription = SubscriptionClient(store: makeUITestMockStore(tier: tier))
        } else {
            #if targetEnvironment(simulator)
            subscription = SubscriptionClient(store: makeUITestMockStore(tier: .free))
            #else
            subscription = SubscriptionClient()
            #endif
        }

        let personalRecordClient = PersonalRecordClient(repository: resolvedRepository)
        let workoutEngineClient = WorkoutEngineClient(subscriptionClient: subscription)
        let settingsClient = SettingsClient()
        let notificationManager = LocalNotificationManager()
        let cloudAdapter = CloudCoachAdapter(
            settings: CoachingOpenAIConfiguration.resolvedSettings(),
            allowsNetwork: !UITestLaunchSupport.isUITestMode
        )
        let coachingClient = CoachingClient(
            cache: UserDefaultsCoachingInsightCache(),
            router: CoachingAdapterRouter(cloud: cloudAdapter),
            isOnDeviceAvailable: { CoachingRuntimeAvailability.isOnDeviceAppleIntelligenceAvailable }
        )
        let workoutSessionClient = WorkoutSessionClient(repository: resolvedSessions)

        let resolvedHealth: any HealthKitSessionMetricsProviding
        if let healthProvider {
            resolvedHealth = healthProvider
        } else if let scenario = UITestLaunchSupport.seedScenario {
            let metrics = DemoDataFixtures.bundle(for: scenario).healthMetrics
            resolvedHealth = MockHealthKitMetricsProvider(metrics: metrics, authorize: metrics != nil)
        } else if UITestLaunchSupport.isUITestMode {
            resolvedHealth = MockHealthKitMetricsProvider(metrics: nil, authorize: false)
        } else {
            #if targetEnvironment(simulator)
            resolvedHealth = MockHealthKitMetricsProvider(metrics: nil, authorize: false)
            #else
            resolvedHealth = HealthKitSessionMetricsProvider()
            #endif
        }
        let healthMetricsClient = HealthMetricsClient(provider: resolvedHealth)

        return AppEnvironment(
            personalRecordClient: personalRecordClient,
            subscriptionClient: subscription,
            workoutEngineClient: workoutEngineClient,
            settingsClient: settingsClient,
            notificationManager: notificationManager,
            coachingClient: coachingClient,
            workoutSessionClient: workoutSessionClient,
            healthMetricsClient: healthMetricsClient
        )
    }

    public func bootstrapServices() async {
        await subscriptionClient.refreshStatus()
        await subscriptionClient.loadSubscriptionProducts()
        subscriptionClient.observeTransactionUpdates()
        #if canImport(WatchConnectivity)
        iPhoneWatchConnectivityBridge.shared.activate()
        #endif
        await seedDemoDataIfNeeded()
        await workoutSessionClient.fetchSessions()
        await healthMetricsClient.refresh()
        #if canImport(WatchConnectivity)
        if personalRecordClient.records.isEmpty {
            await personalRecordClient.fetchRecords()
        }
        iPhoneWatchConnectivityBridge.shared.updateLoadContext(from: personalRecordClient.records)
        #endif
    }

    private func seedDemoDataIfNeeded() async {
        guard let scenario = UITestLaunchSupport.seedScenario else { return }
        let bundle = DemoDataFixtures.bundle(for: scenario)

        // Limpa e popula PRs
        let existing = personalRecordClient.records
        if existing.isEmpty {
            await personalRecordClient.fetchRecords()
        }
        for record in personalRecordClient.records {
            await personalRecordClient.delete(record)
        }
        for record in bundle.records {
            _ = await personalRecordClient.save(record)
        }

        await workoutSessionClient.replaceAll(with: bundle.sessions)
        WatchSessionEventStore.shared.replaceAll(bundle.watchEvents)
        healthMetricsClient.applyMockMetrics(bundle.healthMetrics)
    }

    private static func makeUITestMockStore(tier: SubscriptionTier) -> MockSubscriptionStore {
        MockSubscriptionStore(
            tier: tier,
            simulatedPurchaseOutcome: UITestLaunchSupport.simulatedPurchaseOutcome
        )
    }
}
