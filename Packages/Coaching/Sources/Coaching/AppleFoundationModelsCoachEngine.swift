import Foundation
import Domain

#if canImport(FoundationModels)
import FoundationModels

@available(iOS 26.0, *)
@Generable
struct CoachingGenerableInsight {
    var workoutSuggestion: String
    var focusLifts: [String]
    var repScheme: String
    var rationale: String
}

@available(iOS 26.0, *)
enum AppleFoundationModelsCoachEngine {
    static func generate(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        guard tier.canAccess(.detailedAIAnalysis) else {
            throw CoachingError.tierNotEligible
        }

        let model = SystemLanguageModel.default
        guard model.isAvailable else {
            throw CoachingError.adapterUnavailable
        }

        let session = LanguageModelSession(instructions: CoachingPromptComposer.systemInstructions)
        let prompt = CoachingPromptComposer.userPrompt(snapshot: snapshot)

        do {
            let result = try await session.respond(to: prompt, generating: CoachingGenerableInsight.self)
            let generated = result.content
            return CoachingInsight(
                workoutSuggestion: generated.workoutSuggestion,
                focusLifts: generated.focusLifts,
                repScheme: generated.repScheme,
                rationale: generated.rationale,
                runtime: .onDeviceApple,
                estimatedInputTokens: TokenBudgetEstimator.estimatedInputTokens(for: snapshot),
                cacheHit: false
            )
        } catch {
            let textResponse = try await session.respond(to: prompt)
            let payload = try CoachingInsightJSONParser.parse(textResponse.content)
            return CoachingInsightJSONParser.makeInsight(
                from: payload,
                runtime: .onDeviceApple,
                estimatedInputTokens: TokenBudgetEstimator.estimatedInputTokens(for: snapshot)
            )
        }
    }
}
#endif
