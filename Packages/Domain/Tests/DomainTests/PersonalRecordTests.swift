import Foundation
import Testing
@testable import Domain

@Suite("PersonalRecord Entity")
struct PersonalRecordTests {
    @Test("Detecta melhoria de PR no mesmo exercício")
    func improvementDetection() {
        let squat = Exercise(kind: .backSquat)
        let previous = PersonalRecord(
            exercise: squat,
            date: .now,
            pounds: 100,
            goalDuration: 0
        )
        let improved = PersonalRecord(
            exercise: squat,
            date: .now,
            pounds: 110,
            goalDuration: 0
        )

        #expect(improved.isImprovement(over: previous))
    }

    @Test("PR inferior não é melhoria")
    func noImprovementWhenLower() {
        let squat = Exercise(kind: .backSquat)
        let previous = PersonalRecord(
            exercise: squat,
            date: .now,
            pounds: 150,
            goalDuration: 0
        )
        let worse = PersonalRecord(
            exercise: squat,
            date: .now,
            pounds: 140,
            goalDuration: 0
        )

        #expect(!worse.isImprovement(over: previous))
    }
}

@Suite("Subscription Tier")
struct SubscriptionTierTests {
    @Test("Free acessa apenas insights básicos")
    func freeTierGating() {
        #expect(SubscriptionTier.free.canAccess(.basicInsights))
        #expect(!SubscriptionTier.free.canAccess(.detailedAIAnalysis))
    }

    @Test("PRO acessa todas as features")
    func proTierAccess() {
        for feature in ProFeature.allCases {
            #expect(SubscriptionTier.pro.canAccess(feature))
        }
    }
}

@Suite("Crossfit Catalog")
struct CrossfitCatalogTests {
    @Test("Catálogo não inclui exercício vazio")
    func catalogExcludesEmpty() {
        #expect(!CrossfitCatalog.selectableExercises.contains { $0.kind == .empty })
    }
}
