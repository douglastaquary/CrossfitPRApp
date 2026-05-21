import Foundation
import Testing
@testable import WorkoutEngine
import Domain

@Suite("WorkoutEngine")
struct WorkoutEngineTests {
    let engine = WorkoutEngine()

    @Test("Retorna mensagem quando não há PRs")
    func emptyRecords() async {
        let insights = await engine.generateInsights(from: [], tier: .free)
        #expect(insights.count == 1)
        #expect(insights.first?.category == .summary)
    }

    @Test("Free recebe teaser PRO quando há insights avançados")
    func freeTierGetsProTeaser() async {
        let records = (0..<4).map { index in
            PersonalRecord(
                exercise: Exercise(kind: .backSquat),
                date: Date(timeIntervalSince1970: Double(index) * 86_400),
                pounds: 100,
                goalDuration: 0
            )
        }

        let insights = await engine.generateInsights(from: records, tier: .free)
        #expect(insights.contains { $0.category == .proTeaser })
    }

    @Test("PRO recebe análise WorkoutEngine")
    func proTierGetsWorkoutEngineInsight() async {
        let records = (0..<3).map { index in
            PersonalRecord(
                exercise: Exercise(kind: .deadlift),
                date: Date(timeIntervalSince1970: Double(index) * 86_400),
                pounds: 200,
                goalDuration: 0
            )
        }

        let insights = await engine.generateInsights(from: records, tier: .pro)
        #expect(insights.contains { $0.category == .workoutEngine })
    }
}
