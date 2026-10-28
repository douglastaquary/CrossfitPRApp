import Foundation
import Domain

/// Degradação — só WorkoutEngine + mensagem curta, sem LLM.
public struct SummarizedLocalCoachAdapter: CrossFitCoachingProviding, Sendable {
    public init() {}

    public func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        guard tier.canAccess(.detailedAIAnalysis) else {
            throw CoachingError.tierNotEligible
        }

        let stalledText = snapshot.stalled.isEmpty
            ? "Mantenha consistência nos PRs recentes."
            : "Platô em \(snapshot.stalled.joined(separator: ", "))."

        return CoachingInsight(
            workoutSuggestion: "Análise resumida (sem IA)",
            focusLifts: Array(snapshot.rising.prefix(3)),
            repScheme: "—",
            rationale: stalledText,
            runtime: .summarizedLocal,
            estimatedInputTokens: TokenBudgetEstimator.estimatedInputTokens(for: snapshot),
            cacheHit: false
        )
    }
}
