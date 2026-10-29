import Testing
import Domain

@Suite("DemoDataFixtures")
struct DemoDataFixturesTests {
    @Test("empty não tem PRs nem sessões")
    func emptyScenario() {
        let bundle = DemoDataFixtures.bundle(for: .empty)
        #expect(bundle.records.isEmpty)
        #expect(bundle.sessions.isEmpty)
    }

    @Test("freeTeaser tem PRs suficientes para trend")
    func freeTeaser() {
        let bundle = DemoDataFixtures.bundle(for: .freeTeaser)
        #expect(bundle.records.count >= 4)
        #expect(!bundle.sessions.isEmpty)
    }

    @Test("eliteRich cobre múltiplos grupos")
    func eliteRich() {
        let bundle = DemoDataFixtures.bundle(for: .eliteRich)
        let groups = Set(bundle.records.map(\.group))
        #expect(groups.contains(.barbell))
        #expect(groups.contains(.gymnastic))
        #expect(groups.contains(.endurance))
        #expect(bundle.healthMetrics?.averageHeartRate == 145)
    }
}
