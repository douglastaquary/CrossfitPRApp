import Foundation
import Domain

/// Adapter de teste / CI — nunca chama LLM real.
public struct MockCrossFitCoachAdapter: CrossFitCoachingProviding, Sendable {
    public var runtime: CoachingRuntime

    public init(runtime: CoachingRuntime = .cloud) {
        self.runtime = runtime
    }

    public func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        guard tier.canAccess(.detailedAIAnalysis) else {
            throw CoachingError.tierNotEligible
        }

        let focus = snapshot.rising.isEmpty
            ? snapshot.movements.prefix(2).map(\.name)
            : snapshot.rising

        return CoachingInsight(
            workoutSuggestion: "Metcon moderado + skill em \(focus.first ?? "squat")",
            focusLifts: focus,
            repScheme: "3x5 @ RPE 7",
            rationale: "Priorize movimentos em ascensão; platôs pedem volume técnico.",
            runtime: runtime,
            estimatedInputTokens: TokenBudgetEstimator.estimatedInputTokens(for: snapshot),
            cacheHit: false
        )
    }
}

public enum CoachingError: Error, Equatable {
    case tierNotEligible
    case budgetExceeded
    case adapterUnavailable
    case cloudNotConfigured
    case inferenceFailed
}
