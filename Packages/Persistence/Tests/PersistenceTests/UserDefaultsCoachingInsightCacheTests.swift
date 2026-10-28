import Testing
@testable import Persistence
import Domain

@Suite("UserDefaultsCoachingInsightCache")
struct UserDefaultsCoachingInsightCacheTests {
    @Test("Armazena e recupera por contextHash")
    func storeAndLoad() {
        let suite = "coaching.cache.test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        let cache = UserDefaultsCoachingInsightCache(defaults: defaults, ttl: 3600)
        let insight = CoachingInsight(
            workoutSuggestion: "Test",
            focusLifts: ["Squat"],
            repScheme: "5x5",
            rationale: "Ok",
            runtime: .cloud
        )

        cache.store(insight, contextHash: "abc123")
        let loaded = cache.insight(for: "abc123")
        #expect(loaded?.workoutSuggestion == "Test")
    }
}
