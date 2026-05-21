import Foundation
import Domain
import Localization

/// Motor WorkoutEngine — gera insights Free e PRO a partir dos PRs.
public struct WorkoutEngine: WorkoutInsightsProviding, Sendable {
    public init() {}

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
}
