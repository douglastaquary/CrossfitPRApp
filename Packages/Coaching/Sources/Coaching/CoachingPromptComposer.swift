import Foundation
import Domain

/// Prompt fixo + contexto JSON (Norm N-token-01/02 — CPR-007).
enum CoachingPromptComposer {
    static let systemInstructions = """
    You are a CrossFit coach. Use ONLY the athlete snapshot JSON. \
    Do not invent PR values. Output a single JSON object with keys: \
    workoutSuggestion (string), focusLifts (string array), repScheme (string), rationale (string, max 240 chars). \
    No markdown, no extra text.
    """

    static func userPrompt(snapshot: CoachingContextSnapshot) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        guard let data = try? encoder.encode(snapshot),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return "Athlete snapshot:\n\(json)"
    }
}
