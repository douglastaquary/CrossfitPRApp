import Foundation
import Domain
import Persistence
import Subscription
import WorkoutEngine

/// Composition root — monta dependências entre módulos SPM (único ponto de wiring).
@MainActor
public struct AppEnvironment {
    public let personalRecordClient: PersonalRecordClient
    public let subscriptionClient: SubscriptionClient
    public let workoutEngineClient: WorkoutEngineClient
    public let settingsClient: SettingsClient
    public let notificationManager: LocalNotificationManager

    public init(
        personalRecordClient: PersonalRecordClient,
        subscriptionClient: SubscriptionClient,
        workoutEngineClient: WorkoutEngineClient,
        settingsClient: SettingsClient,
        notificationManager: LocalNotificationManager
    ) {
        self.personalRecordClient = personalRecordClient
        self.subscriptionClient = subscriptionClient
        self.workoutEngineClient = workoutEngineClient
        self.settingsClient = settingsClient
        self.notificationManager = notificationManager
    }

    public static func make(
        subscriptionStore: (any SubscriptionStoreProviding)? = nil,
        repository: (any PersonalRecordRepository)? = nil
    ) -> AppEnvironment {
        let resolvedRepository = repository ?? PersistenceFactory.makeRepository()

        let subscription: SubscriptionClient
        if let store = subscriptionStore {
            subscription = SubscriptionClient(store: store)
        } else {
            subscription = SubscriptionClient()
        }

        let personalRecordClient = PersonalRecordClient(repository: resolvedRepository)
        let workoutEngineClient = WorkoutEngineClient(subscriptionClient: subscription)
        let settingsClient = SettingsClient()
        let notificationManager = LocalNotificationManager()

        return AppEnvironment(
            personalRecordClient: personalRecordClient,
            subscriptionClient: subscription,
            workoutEngineClient: workoutEngineClient,
            settingsClient: settingsClient,
            notificationManager: notificationManager
        )
    }

    public func bootstrapServices() async {
        await subscriptionClient.refreshStatus()
        await subscriptionClient.loadSubscriptionProducts()
        subscriptionClient.observeTransactionUpdates()
    }
}
