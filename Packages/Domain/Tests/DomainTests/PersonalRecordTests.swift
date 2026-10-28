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
        #expect(!SubscriptionTier.free.canAccess(.athleteAssessment))
    }

    @Test("PRO acessa features não-Elite")
    func proTierAccess() {
        for feature in ProFeature.allCases where !feature.isEliteOnly {
            #expect(SubscriptionTier.pro.canAccess(feature))
        }
        #expect(!SubscriptionTier.pro.canAccess(.athleteAssessment))
        #expect(!SubscriptionTier.pro.canAccess(.limitingFactorAnalysis))
    }

    @Test("Elite acessa assessment e limiting factor")
    func eliteTierAccess() {
        for feature in ProFeature.allCases {
            #expect(SubscriptionTier.elite.canAccess(feature))
        }
    }
}

@Suite("Athlete Assessment")
struct AthleteAssessmentServiceTests {
    let service = AthleteAssessmentService()

    @Test("Assessment vazio sem PRs")
    func emptyRecords() {
        let result = service.assess(records: [])
        #expect(result.scores.isEmpty)
        #expect(result.limitingFactor == nil)
    }

    @Test("Força forte e ginástica vazia aponta limiting factor")
    func limitingFactorWhenDomainMissing() {
        let strength = (0..<3).map { index in
            PersonalRecord(
                prName: "BACK SQUAT",
                recordDate: Date(timeIntervalSince1970: Double(index) * 86_400),
                poundValue: 200 + (index * 10),
                group: .barbell
            )
        }
        let deadlift = PersonalRecord(
            prName: "DEADLIFT",
            recordDate: Date(),
            poundValue: 315,
            group: .barbell
        )
        let result = service.assess(records: strength + [deadlift])
        #expect(result.scores.contains { $0.domain == .strength && $0.coverage > 0 })
        #expect(result.limitingFactor == .gymnastics || result.limitingFactor == .engine || result.limitingFactor == .olympic)
    }
}

@Suite("Crossfit Catalog")
struct CrossfitCatalogTests {
    @Test("Catálogo não inclui exercício vazio")
    func catalogExcludesEmpty() {
        #expect(!CrossfitCatalog.selectableExercises.contains { $0.kind == .empty })
    }
}
