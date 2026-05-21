import Foundation
import Testing
@testable import Application
import Domain
import Subscription

@Suite("AppEnvironment")
struct AppEnvironmentTests {
    @Test("Composition root monta clients")
    @MainActor
    func makeEnvironment() {
        let mock = MockSubscriptionStore(tier: .free)
        let environment = AppEnvironment.make(subscriptionStore: mock)

        #expect(environment.personalRecordClient.records.isEmpty)
        #expect(environment.subscriptionClient.currentTier == .free)
        #expect(environment.workoutEngineClient.insights.isEmpty)
    }
}
