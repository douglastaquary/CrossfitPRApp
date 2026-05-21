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

    public init(
        personalRecordClient: PersonalRecordClient,
        subscriptionClient: SubscriptionClient,
        workoutEngineClient: WorkoutEngineClient
    ) {
        self.personalRecordClient = personalRecordClient
        self.subscriptionClient = subscriptionClient
        self.workoutEngineClient = workoutEngineClient
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

        return AppEnvironment(
            personalRecordClient: personalRecordClient,
            subscriptionClient: subscription,
            workoutEngineClient: workoutEngineClient
        )
    }

    public func bootstrapServices() async {
        await subscriptionClient.refreshStatus()
        await subscriptionClient.loadProProduct()
        subscriptionClient.observeTransactionUpdates()
    }
}
