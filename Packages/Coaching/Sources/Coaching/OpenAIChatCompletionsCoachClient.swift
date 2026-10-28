import Foundation
import Domain

/// Fallback PRO — API Chat Completions (OpenAI); snapshot compacto, resposta JSON (CPR-007).
struct OpenAIChatCompletionsCoachClient: Sendable {
    var settings: CoachingOpenAISettings
    var session: URLSession
    var allowsNetwork: Bool

    init(
        settings: CoachingOpenAISettings,
        session: URLSession = .shared,
        allowsNetwork: Bool = true
    ) {
        self.settings = settings
        self.session = session
        self.allowsNetwork = allowsNetwork
    }

    func generate(
        snapshot: CoachingContextSnapshot,
        tier: SubscriptionTier
    ) async throws -> CoachingInsight {
        guard tier.canAccess(.detailedAIAnalysis) else {
            throw CoachingError.tierNotEligible
        }
        guard settings.isConfigured else {
            throw CoachingError.cloudNotConfigured
        }
        guard allowsNetwork else {
            throw CoachingError.adapterUnavailable
        }

        var request = URLRequest(url: settings.chatCompletionsURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(settings.apiKey)", forHTTPHeaderField: "Authorization")

        let body = ChatCompletionRequest(
            model: settings.model,
            messages: [
                .init(role: "system", content: CoachingPromptComposer.systemInstructions),
                .init(role: "user", content: CoachingPromptComposer.userPrompt(snapshot: snapshot)),
            ],
            responseFormat: ChatCompletionRequest.ResponseFormat(type: "json_object"),
            maxTokens: settings.maxOutputTokens
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
            throw CoachingError.inferenceFailed
        }

        let completion = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
        guard let content = completion.choices.first?.message.content else {
            throw CoachingError.inferenceFailed
        }

        let payload = try CoachingInsightJSONParser.parse(content)
        return CoachingInsightJSONParser.makeInsight(
            from: payload,
            runtime: .cloud,
            estimatedInputTokens: TokenBudgetEstimator.estimatedInputTokens(for: snapshot)
        )
    }

    private struct ChatCompletionRequest: Encodable {
        struct Message: Encodable {
            var role: String
            var content: String
        }

        struct ResponseFormat: Encodable {
            var type: String
        }

        var model: String
        var messages: [Message]
        var responseFormat: ResponseFormat
        var maxTokens: Int

        enum CodingKeys: String, CodingKey {
            case model
            case messages
            case responseFormat = "response_format"
            case maxTokens = "max_tokens"
        }
    }

    private struct ChatCompletionResponse: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable {
                var content: String?
            }

            var message: Message
        }

        var choices: [Choice]
    }
}
