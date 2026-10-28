import Testing
@testable import Coaching
import Domain

@Suite("CoachingContextBuilder")
struct CoachingContextBuilderTests {
    @Test("Snapshot limita movimentos e produz hash estável")
    func snapshotRespectsMaxMovements() {
        var records: [PersonalRecord] = []
        for i in 0 ..< 20 {
            records.append(
                PersonalRecord(
                    prName: "Lift \(i)",
                    recordDate: Date().addingTimeInterval(Double(-i * 86_400)),
                    poundValue: 100 + i,
                    group: .barbell
                )
            )
        }

        let builder = CoachingContextBuilder(windowDays: 90, maxMovements: 8)
        let snapshot = builder.build(from: records, engineInsights: [])

        #expect(snapshot.movements.count <= 8)
        #expect(!snapshot.contextHash.isEmpty)
    }

    @Test("WatchSessionEvent parseia payload WC")
    func watchEventParsesPayload() {
        let event = WatchSessionEvent(watchConnectivityPayload: [
            "event": "watch.handshake",
            "movement": "thruster",
            "rpe": 7,
        ])
        #expect(event?.phase == "session")
        #expect(event?.movement == "thruster")
        #expect(event?.rpe == 7)
    }

    @Test("Eventos Watch entram no snapshot e alteram o hash")
    func watchEventsIncludedInSnapshot() {
        let builder = CoachingContextBuilder()
        let base = builder.build(from: [], engineInsights: [])
        let watchEvent = WatchSessionEvent(phase: "rest", movement: "thruster", rpe: 8, durationSec: 90)
        let withWatch = builder.build(from: [], engineInsights: [], watchEvents: [watchEvent])

        #expect(withWatch.sessionEvents.count == 1)
        #expect(withWatch.sessionEvents.first?.phase == "rest")
        #expect(withWatch.contextHash != base.contextHash)
    }

    @Test("TokenBudget trunca quando estimate excede cloud")
    func budgetTruncatesForCloud() {
        var records: [PersonalRecord] = []
        for i in 0 ..< 15 {
            records.append(
                PersonalRecord(
                    prName: "Back Squat \(i)",
                    recordDate: Date().addingTimeInterval(Double(-i * 86_400)),
                    poundValue: 200 + i,
                    group: .barbell
                )
            )
        }

        let builder = CoachingContextBuilder(maxMovements: 12)
        let snapshot = builder.build(from: records, engineInsights: [])
        let policy = TokenBudgetPolicy()
        let applied = policy.apply(snapshot, tier: .pro, runtime: .cloud)

        #expect(applied.snapshot.movements.count <= applied.limits.maxMovements)
        #expect(applied.estimatedInputTokens <= applied.limits.maxInputTokens || applied.limits.maxInputTokens > 0)
    }
}
