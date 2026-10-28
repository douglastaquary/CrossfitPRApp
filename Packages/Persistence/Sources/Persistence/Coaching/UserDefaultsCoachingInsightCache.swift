import Foundation
import Domain

/// Cache local de insights do coach (CPR-007) — sobrevive relaunch; TTL opcional.
public final class UserDefaultsCoachingInsightCache: CoachingInsightCaching, @unchecked Sendable {
    private let defaults: UserDefaults
    private let ttl: TimeInterval?
    private let lock = NSLock()
    private let prefix = "coaching.insight."

    public init(defaults: UserDefaults = .standard, ttl: TimeInterval? = 86_400 * 7) {
        self.defaults = defaults
        self.ttl = ttl
    }

    public func insight(for contextHash: String) -> CoachingInsight? {
        lock.lock()
        defer { lock.unlock() }

        guard let data = defaults.data(forKey: key(contextHash)) else { return nil }
        guard let envelope = try? JSONDecoder().decode(Envelope.self, from: data) else {
            defaults.removeObject(forKey: key(contextHash))
            return nil
        }
        if let ttl, Date().timeIntervalSince(envelope.storedAt) > ttl {
            defaults.removeObject(forKey: key(contextHash))
            return nil
        }
        return envelope.insight
    }

    public func store(_ insight: CoachingInsight, contextHash: String) {
        lock.lock()
        defer { lock.unlock() }

        let envelope = Envelope(storedAt: Date(), insight: insight)
        guard let data = try? JSONEncoder().encode(envelope) else { return }
        defaults.set(data, forKey: key(contextHash))
    }

    public func clear() {
        lock.lock()
        defer { lock.unlock() }

        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix(prefix) {
            defaults.removeObject(forKey: key)
        }
    }

    private func key(_ contextHash: String) -> String {
        prefix + contextHash
    }

    private struct Envelope: Codable {
        var storedAt: Date
        var insight: CoachingInsight
    }
}
