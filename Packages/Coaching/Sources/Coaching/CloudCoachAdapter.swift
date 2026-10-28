import Foundation
import Domain

/// Fallback cloud PRO — Chat Completions (OpenAI); sem API key → escada segue para resumo local.
public struct CloudCoachAdapter: CrossFitCoachingProviding, Sendable {
    private let client: OpenAIChatCompletionsCoachClient?

    public init(settings: CoachingOpenAISettings? = nil, allowsNetwork: Bool = true) {
        if let settings, settings.isConfigured {
            client = OpenAIChatCompletionsCoachClient(settings: settings, allowsNetwork: allowsNetwork)
        } else {
            client = nil
        }
    }

    public func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        guard let client else {
            throw CoachingError.cloudNotConfigured
        }
        return try await client.generate(snapshot: snapshot, tier: tier)
    }
}
