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

    public init(
        personalRecordClient: PersonalRecordClient,
        subscriptionClient: SubscriptionClient,
        workoutEngineClient: WorkoutEngineClient,
        settingsClient: SettingsClient,
        notificationManager: LocalNotificationManager,
        coachingClient: CoachingClient
    ) {
        self.personalRecordClient = personalRecordClient
        self.subscriptionClient = subscriptionClient
        self.workoutEngineClient = workoutEngineClient
        self.settingsClient = settingsClient
        self.notificationManager = notificationManager
        self.coachingClient = coachingClient
    }

    public static func make(
        subscriptionStore: (any SubscriptionStoreProviding)? = nil,
        repository: (any PersonalRecordRepository)? = nil
    ) -> AppEnvironment {
        let resolvedRepository = repository ?? PersistenceFactory.makeRepository()

        let subscription: SubscriptionClient
        if let store = subscriptionStore {
            subscription = SubscriptionClient(store: store)
        } else if let tier = UITestLaunchSupport.subscriptionTierOverride {
            subscription = SubscriptionClient(store: MockSubscriptionStore(tier: tier))
        } else {
            #if targetEnvironment(simulator)
            subscription = SubscriptionClient(store: MockSubscriptionStore())
            #else
            subscription = SubscriptionClient()
            #endif
        }

        let personalRecordClient = PersonalRecordClient(repository: resolvedRepository)
        let workoutEngineClient = WorkoutEngineClient(subscriptionClient: subscription)
        let settingsClient = SettingsClient()
        if UITestLaunchSupport.shouldSkipOnboarding {
            settingsClient.hasCompletedLaunch = true
        } else if UITestLaunchSupport.shouldForceOnboarding {
            settingsClient.hasCompletedLaunch = false
        }
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

        return AppEnvironment(
            personalRecordClient: personalRecordClient,
            subscriptionClient: subscription,
            workoutEngineClient: workoutEngineClient,
            settingsClient: settingsClient,
            notificationManager: notificationManager,
            coachingClient: coachingClient
        )
    }

    public func bootstrapServices() async {
        await subscriptionClient.refreshStatus()
        await subscriptionClient.loadSubscriptionProducts()
        subscriptionClient.observeTransactionUpdates()
    }
}
