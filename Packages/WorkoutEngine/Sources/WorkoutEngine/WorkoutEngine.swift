import Foundation
import Domain
import Localization

/// Motor WorkoutEngine — gera insights Free, PRO e Elite a partir dos PRs.
public struct WorkoutEngine: WorkoutInsightsProviding, Sendable {
    private let assessmentService: AthleteAssessmentService

    public init(assessmentService: AthleteAssessmentService = AthleteAssessmentService()) {
        self.assessmentService = assessmentService
    }

    public func generateInsights(
        from records: [PersonalRecord],
        tier: SubscriptionTier
    ) async -> [WorkoutInsight] {
        guard !records.isEmpty else {
            return [
                WorkoutInsight(
                    title: Strings.Engine.emptyTitle,
                    message: Strings.Engine.emptyMessage,
                    category: .summary
                ),
            ]
        }

        var insights: [WorkoutInsight] = []
        insights.append(makeSummaryInsight(records: records))

        if tier.canAccess(.basicInsights) {
            insights.append(contentsOf: makeBasicTrends(records: records))
        }

        let proInsights = makeProInsights(records: records)
        if tier.canAccess(.detailedAIAnalysis) {
            insights.append(contentsOf: proInsights)
        } else {
            insights.append(makeProTeaser(from: proInsights))
        }

        let assessment = assessmentService.assess(records: records)
        if tier.canAccess(.athleteAssessment) {
            insights.append(contentsOf: makeEliteAssessmentInsights(assessment))
        } else if tier.canAccess(.detailedAIAnalysis), !assessment.scores.isEmpty {
            insights.append(makeEliteTeaser(assessment: assessment))
        }

        return insights
    }

    private func makeSummaryInsight(records: [PersonalRecord]) -> WorkoutInsight {
        let uniqueExercises = Set(records.map(\.exercise.kind)).count
        let latest = records.max(by: { $0.date < $1.date })
        let latestText = latest.map {
            Strings.Engine.latestRecord(
                exercise: $0.exercise.kind.localizedName,
                pounds: Int($0.pounds)
            )
        } ?? ""

        return WorkoutInsight(
            title: Strings.Engine.summaryTitle,
            message: Strings.Engine.summaryMessage(
                count: records.count,
                exercises: uniqueExercises,
                latest: latestText
            ),
            category: .summary
        )
    }

    private func makeBasicTrends(records: [PersonalRecord]) -> [WorkoutInsight] {
        let grouped = Dictionary(grouping: records, by: { $0.exercise.kind })
        return grouped.compactMap { kind, prs -> WorkoutInsight? in
            guard prs.count >= 2 else { return nil }
            let sorted = prs.sorted { $0.date < $1.date }
            guard let first = sorted.first, let last = sorted.last else { return nil }
            let delta = last.pounds - first.pounds
            let isGain = delta >= 0
            let encouragement = isGain
                ? Strings.Engine.trendEncouragementUp
                : Strings.Engine.trendEncouragementDown
            let message = isGain
                ? Strings.Engine.trendMessageImproved(delta: abs(Int(delta)), encouragement: encouragement)
                : Strings.Engine.trendMessageDeclined(delta: abs(Int(delta)), encouragement: encouragement)

            return WorkoutInsight(
                title: Strings.Engine.trendTitle(exercise: kind.localizedName),
                message: message,
                category: .trend,
                relatedExercise: kind
            )
        }
    }

    private func makeProInsights(records: [PersonalRecord]) -> [WorkoutInsight] {
        var insights: [WorkoutInsight] = []

        let grouped = Dictionary(grouping: records, by: { $0.exercise.kind })
        for (kind, prs) in grouped where prs.count >= 3 {
            let sorted = prs.sorted { $0.date < $1.date }
            let recent = sorted.suffix(3)
            let weights = recent.map(\.pounds)
            let isStableWeight = weights.max() == weights.min()

            if isStableWeight {
                insights.append(
                    WorkoutInsight(
                        title: Strings.Engine.plateauTitle(exercise: kind.localizedName),
                        message: Strings.Engine.plateauMessage(weight: Int(weights[0])),
                        category: .workoutEngine,
                        requiresPro: true,
                        relatedExercise: kind
                    )
                )
            }

            if let recommendation = makeRecommendation(for: kind, records: sorted) {
                insights.append(recommendation)
            }
        }

        if records.count >= 5 {
            insights.append(
                WorkoutInsight(
                    title: Strings.Engine.consistencyTitle,
                    message: Strings.Engine.consistencyMessage(count: records.count),
                    category: .recommendation,
                    requiresPro: true
                )
            )
        }

        return insights
    }

    private func makeRecommendation(for kind: ActivityKind, records: [PersonalRecord]) -> WorkoutInsight? {
        guard let latest = records.last else { return nil }
        let projected = latest.pounds * 1.025
        return WorkoutInsight(
            title: Strings.Engine.targetTitle(exercise: kind.localizedName),
            message: Strings.Engine.targetMessage(projected: Int(projected)),
            category: .recommendation,
            requiresPro: true,
            relatedExercise: kind
        )
    }

    private func makeProTeaser(from proInsights: [WorkoutInsight]) -> WorkoutInsight {
        WorkoutInsight(
            title: Strings.Engine.teaserTitle,
            message: Strings.Engine.teaserMessage(count: proInsights.count),
            category: .proTeaser,
            requiresPro: true
        )
    }

    private func makeEliteAssessmentInsights(_ assessment: AthleteAssessment) -> [WorkoutInsight] {
        var insights: [WorkoutInsight] = []

        let lines = assessment.scores
            .sorted { $0.score > $1.score }
            .map { score in
                Strings.Engine.assessmentDomainLine(
                    domain: localizedDomain(score.domain),
                    percent: Int((score.score * 100).rounded())
                )
            }
            .joined(separator: "\n")

        insights.append(
            WorkoutInsight(
                title: Strings.Engine.assessmentTitle,
                message: Strings.Engine.assessmentMessage(lines: lines),
                category: .eliteAssessment,
                requiresPro: true,
                requiresElite: true
            )
        )

        if let domain = assessment.limitingFactor {
            insights.append(
                WorkoutInsight(
                    title: Strings.Engine.limitingFactorTitle,
                    message: Strings.Engine.limitingFactorMessage(domain: localizedDomain(domain)),
                    category: .eliteLimitingFactor,
                    requiresPro: true,
                    requiresElite: true
                )
            )
        }

        return insights
    }

    private func makeEliteTeaser(assessment: AthleteAssessment) -> WorkoutInsight {
        let domainHint = assessment.limitingFactor.map(localizedDomain) ?? Strings.Engine.assessmentGenericDomain
        return WorkoutInsight(
            title: Strings.Engine.eliteTeaserTitle,
            message: Strings.Engine.eliteTeaserMessage(domainHint: domainHint),
            category: .eliteTeaser,
            requiresPro: true,
            requiresElite: true
        )
    }

    private func localizedDomain(_ domain: AthleteDomain) -> String {
        switch domain {
        case .strength: return Strings.Engine.domainStrength
        case .olympic: return Strings.Engine.domainOlympic
        case .gymnastics: return Strings.Engine.domainGymnastics
        case .engine: return Strings.Engine.domainEngine
        }
    }
}
