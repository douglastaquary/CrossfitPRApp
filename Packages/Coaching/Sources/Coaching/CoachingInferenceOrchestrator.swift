import Foundation
import Domain

/// Escada on-device → cloud → resumo (CPR-007).
public struct CoachingInferenceOrchestrator: Sendable {
    public let router: CoachingAdapterRouter
    public let isOnDeviceAvailable: () -> Bool

    public init(router: CoachingAdapterRouter, isOnDeviceAvailable: @escaping () -> Bool) {
        self.router = router
        self.isOnDeviceAvailable = isOnDeviceAvailable
    }

    public func generateInsight(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier,
        budget: TokenBudgetPolicy
    ) async throws -> (insight: CoachingInsight, runtime: CoachingRuntime, estimatedInputTokens: Int) {
        var runtimes: [CoachingRuntime] = []
        if isOnDeviceAvailable() {
            runtimes.append(.onDeviceApple)
        }
        runtimes.append(.cloud)

        var lastError: Error = CoachingError.adapterUnavailable

        for runtime in runtimes {
            let applied = budget.apply(snapshot, tier: tier, runtime: runtime)
            guard applied.limits.maxInputTokens > 0 else {
                throw CoachingError.tierNotEligible
            }

            let adapter = router.adapter(for: runtime)
            do {
                var insight = try await adapter.generateCoaching(snapshot: applied.snapshot, tier: tier)
                if insight.rationale.count > applied.limits.maxRationaleChars {
                    insight.rationale = String(insight.rationale.prefix(applied.limits.maxRationaleChars))
                }
                insight.estimatedInputTokens = applied.estimatedInputTokens
                return (insight, runtime, applied.estimatedInputTokens)
            } catch {
                lastError = error
                continue
            }
        }

        let summarizedApplied = budget.apply(snapshot, tier: tier, runtime: .summarizedLocal)
        let summarized = router.adapter(for: .summarizedLocal)
        if let insight = try? await summarized.generateCoaching(snapshot: summarizedApplied.snapshot, tier: tier) {
            return (insight, .summarizedLocal, summarizedApplied.estimatedInputTokens)
        }

        throw lastError
    }
}
