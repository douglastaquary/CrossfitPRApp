import Foundation
import Domain

struct CoachingInsightPayload: Codable, Equatable {
    var workoutSuggestion: String
    var focusLifts: [String]
    var repScheme: String
    var rationale: String
}

enum CoachingInsightJSONParser {
    static func parse(_ raw: String) throws -> CoachingInsightPayload {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let jsonSlice = extractJSONObject(from: trimmed) ?? trimmed
        guard let data = jsonSlice.data(using: .utf8) else {
            throw CoachingError.inferenceFailed
        }
        return try JSONDecoder().decode(CoachingInsightPayload.self, from: data)
    }

    static func makeInsight(
        from payload: CoachingInsightPayload,
        runtime: CoachingRuntime,
        estimatedInputTokens: Int
    ) -> CoachingInsight {
        CoachingInsight(
            workoutSuggestion: payload.workoutSuggestion,
            focusLifts: payload.focusLifts,
            repScheme: payload.repScheme,
            rationale: payload.rationale,
            runtime: runtime,
            estimatedInputTokens: estimatedInputTokens,
            cacheHit: false
        )
    }

    private static func extractJSONObject(from text: String) -> String? {
        guard let start = text.firstIndex(of: "{"),
              let end = text.lastIndex(of: "}") else {
            return nil
        }
        return String(text[start ... end])
    }
}
