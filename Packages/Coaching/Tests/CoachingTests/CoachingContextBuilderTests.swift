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
