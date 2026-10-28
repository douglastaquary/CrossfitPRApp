import Foundation

/// Resposta estruturada do coach CrossFit (schema fixo — poucos tokens de saída).
public struct CoachingInsight: Hashable, Sendable, Codable {
    public var workoutSuggestion: String
    public var focusLifts: [String]
    public var repScheme: String
    public var rationale: String
    public var runtime: CoachingRuntime
    public var estimatedInputTokens: Int
    public var cacheHit: Bool

    public init(
        workoutSuggestion: String,
        focusLifts: [String],
        repScheme: String,
        rationale: String,
        runtime: CoachingRuntime,
        estimatedInputTokens: Int = 0,
        cacheHit: Bool = false
    ) {
        self.workoutSuggestion = workoutSuggestion
        self.focusLifts = focusLifts
        self.repScheme = repScheme
        self.rationale = rationale
        self.runtime = runtime
        self.estimatedInputTokens = estimatedInputTokens
        self.cacheHit = cacheHit
    }
}
