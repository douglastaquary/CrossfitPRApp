import Foundation

/// Credenciais e modelo para fallback cloud via Chat Completions (CPR-007).
public struct CoachingOpenAISettings: Sendable, Equatable {
    public static let defaultModel = "gpt-4o-mini"
    public static let defaultChatCompletionsURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    public var apiKey: String
    public var model: String
    public var chatCompletionsURL: URL
    public var maxOutputTokens: Int

    public init(
        apiKey: String,
        model: String = Self.defaultModel,
        chatCompletionsURL: URL = Self.defaultChatCompletionsURL,
        maxOutputTokens: Int = 320
    ) {
        self.apiKey = apiKey
        self.model = model
        self.chatCompletionsURL = chatCompletionsURL
        self.maxOutputTokens = maxOutputTokens
    }

    public var isConfigured: Bool {
        !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
