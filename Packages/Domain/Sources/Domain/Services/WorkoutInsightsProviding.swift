import Foundation

/// Port — análise de treinos e PRs (implementado em WorkoutEngine).
public protocol WorkoutInsightsProviding: Sendable {
    func generateInsights(
        from records: [PersonalRecord],
        tier: SubscriptionTier
    ) async -> [WorkoutInsight]
}
