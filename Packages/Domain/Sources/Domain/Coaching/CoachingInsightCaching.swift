import Foundation

public protocol CoachingInsightCaching: Sendable {
    func insight(for contextHash: String) -> CoachingInsight?
    func store(_ insight: CoachingInsight, contextHash: String)
    func clear()
}
