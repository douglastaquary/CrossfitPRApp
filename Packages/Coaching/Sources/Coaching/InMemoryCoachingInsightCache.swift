import Foundation
import Domain

public final class InMemoryCoachingInsightCache: CoachingInsightCaching, @unchecked Sendable {
    private var storage: [String: CoachingInsight] = [:]
    private let lock = NSLock()

    public init() {}

    public func insight(for contextHash: String) -> CoachingInsight? {
        lock.lock()
        defer { lock.unlock() }
        return storage[contextHash]
    }

    public func store(_ insight: CoachingInsight, contextHash: String) {
        lock.lock()
        defer { lock.unlock() }
        storage[contextHash] = insight
    }

    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAll()
    }
}
