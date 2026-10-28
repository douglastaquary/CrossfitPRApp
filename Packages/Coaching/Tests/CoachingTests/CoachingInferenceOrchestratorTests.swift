import Testing
@testable import Coaching
import Domain

@Suite("CoachingInferenceOrchestrator")
struct CoachingInferenceOrchestratorTests {
    @Test("Cai no resumo quando on-device e cloud falham")
    func summarizedFallback() async throws {
        let router = CoachingAdapterRouter(
            onDevice: FailingCoachAdapter(),
            cloud: FailingCoachAdapter()
        )
        let orchestrator = CoachingInferenceOrchestrator(router: router, isOnDeviceAvailable: { true })
        let snapshot = CoachingContextSnapshot(
            windowDays: 90,
            contextHash: "test",
            movements: [],
            stalled: [],
            rising: [],
            engineSignals: CoachingSignals()
        )

        let result = try await orchestrator.generateInsight(
            snapshot: snapshot,
            tier: .pro,
            budget: TokenBudgetPolicy()
        )
        #expect(result.runtime == .summarizedLocal)
    }
}

private struct FailingCoachAdapter: CrossFitCoachingProviding, Sendable {
    func generateCoaching(snapshot: CoachingContextSnapshot, tier: SubscriptionTier) async throws -> CoachingInsight {
        throw CoachingError.adapterUnavailable
    }
}
