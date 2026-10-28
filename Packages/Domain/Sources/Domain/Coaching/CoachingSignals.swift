import Foundation

/// Tags curtas derivadas do WorkoutEngine — entrada compacta para LLM (CPR-007).
public struct CoachingSignals: Hashable, Sendable, Codable {
    public var tags: [String]

    public init(tags: [String] = []) {
        self.tags = tags
    }
}
