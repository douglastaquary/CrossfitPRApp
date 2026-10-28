import Foundation
import Domain

/// Inferência on-device via Foundation Models (iOS 26+ / Apple Intelligence).
public struct AppleIntelligenceCoachAdapter: CrossFitCoachingProviding, Sendable {
    public init() {}

    public func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            return try await AppleFoundationModelsCoachEngine.generate(snapshot: snapshot, tier: tier)
        }
        #endif
        throw CoachingError.adapterUnavailable
    }
}
