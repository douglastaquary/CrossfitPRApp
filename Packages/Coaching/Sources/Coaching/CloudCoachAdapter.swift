import Foundation
import Domain

/// Fallback cloud PRO — Chat Completions (OpenAI); sem API key → escada segue para resumo local.
public struct CloudCoachAdapter: CrossFitCoachingProviding, Sendable {
    private let baseSettings: CoachingOpenAISettings?
    private let allowsNetwork: Bool

    public init(settings: CoachingOpenAISettings? = nil, allowsNetwork: Bool = true) {
        self.baseSettings = settings
        self.allowsNetwork = allowsNetwork
    }

    public func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        try await generateCoaching(
            snapshot: snapshot,
            tier: tier,
            maxOutputTokens: baseSettings?.maxOutputTokens ?? 320
        )
    }

    func generateCoaching(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier,
        maxOutputTokens: Int
    ) async throws -> CoachingInsight {
        guard var settings = baseSettings, settings.isConfigured else {
            throw CoachingError.cloudNotConfigured
        }
        settings.maxOutputTokens = maxOutputTokens
        let client = OpenAIChatCompletionsCoachClient(
            settings: settings,
            allowsNetwork: allowsNetwork
        )
        return try await client.generate(snapshot: snapshot, tier: tier)
    }
}
