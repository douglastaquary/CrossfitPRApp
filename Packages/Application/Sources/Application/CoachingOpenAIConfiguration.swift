import Foundation
import Coaching

/// Resolve credenciais OpenAI para o coach cloud (CPR-007). **Nunca** commitar API keys.
public enum CoachingOpenAIConfiguration {
    public static let apiKeyInfoKey = "OpenAIAPIKey"
    public static let modelInfoKey = "OpenAIChatModel"
    public static let baseURLInfoKey = "OpenAIBaseURL"

    public static let apiKeyEnvKey = "OPENAI_API_KEY"
    public static let modelEnvKey = "OPENAI_CHAT_MODEL"
    public static let baseURLEnvKey = "OPENAI_BASE_URL"

    /// Legado (fase 2) — mesma API key.
    private static let legacyBearerEnvKey = "COACHING_CLOUD_BEARER"
    private static let legacyBearerInfoKey = "CoachingCloudBearerToken"

    public static func resolvedSettings(from bundle: Bundle = .main) -> CoachingOpenAISettings? {
        guard let apiKey = apiKey(from: bundle) else { return nil }

        let model = model(from: bundle) ?? CoachingOpenAISettings.defaultModel
        let url = chatCompletionsURL(from: bundle)
        return CoachingOpenAISettings(apiKey: apiKey, model: model, chatCompletionsURL: url)
    }

    public static func apiKey(from bundle: Bundle = .main) -> String? {
        nonEmpty(ProcessInfo.processInfo.environment[apiKeyEnvKey])
            ?? nonEmpty(ProcessInfo.processInfo.environment[legacyBearerEnvKey])
            ?? nonEmpty(bundle.object(forInfoDictionaryKey: apiKeyInfoKey) as? String)
            ?? nonEmpty(bundle.object(forInfoDictionaryKey: legacyBearerInfoKey) as? String)
    }

    public static func model(from bundle: Bundle = .main) -> String? {
        nonEmpty(ProcessInfo.processInfo.environment[modelEnvKey])
            ?? nonEmpty(bundle.object(forInfoDictionaryKey: modelInfoKey) as? String)
    }

    public static func chatCompletionsURL(from bundle: Bundle = .main) -> URL {
        let base =
            nonEmpty(ProcessInfo.processInfo.environment[baseURLEnvKey])
            ?? nonEmpty(bundle.object(forInfoDictionaryKey: baseURLInfoKey) as? String)

        guard let base, let root = URL(string: base.trimmingCharacters(in: CharacterSet(charactersIn: "/"))) else {
            return CoachingOpenAISettings.defaultChatCompletionsURL
        }

        if root.path.hasSuffix("chat/completions") {
            return root
        }
        if root.path.hasSuffix("/v1") || root.lastPathComponent == "v1" {
            return root.appendingPathComponent("chat/completions")
        }
        return root.appendingPathComponent("v1/chat/completions")
    }

    private static func nonEmpty(_ value: String?) -> String? {
        guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        return value
    }
}
