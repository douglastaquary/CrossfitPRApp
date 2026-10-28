import Foundation

public protocol CrossFitCoachingProviding: Sendable {
    func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight
}
