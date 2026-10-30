import SwiftUI
import Domain
import Application
import Subscription
import Localization
import SharedUI

/// Pack Girls / Heroes / Open YoY (CPR-018) — PRO+.
struct InsightsBenchmarksSection: View {
    @EnvironmentObject private var workoutSessionClient: WorkoutSessionClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient

    private var canAccess: Bool {
        subscriptionClient.currentTier.canAccess(.benchmarksPack)
    }

    var body: some View {
        Group {
            if canAccess {
                content
            }
        }
        .task {
            await workoutSessionClient.fetchSessions()
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.Benchmarks.sectionTitle)
                .font(AppDesign.Typography.sectionTitle)

            familyBlock(title: Strings.Benchmarks.girls, items: CrossfitBenchmarkCatalog.girls)
            familyBlock(title: Strings.Benchmarks.heroes, items: CrossfitBenchmarkCatalog.heroes)
            openYoYBlock
        }
        .accessibilityIdentifier("insights.benchmarks.section")
    }

    private func familyBlock(title: String, items: [CrossfitBenchmark]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            ForEach(items) { item in
                benchmarkRow(item)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
    }

    private var openYoYBlock: some View {
        let byYear = Dictionary(grouping: CrossfitBenchmarkCatalog.openSamples, by: { $0.openYear ?? 0 })
        let years = byYear.keys.filter { $0 > 0 }.sorted(by: >)
        return VStack(alignment: .leading, spacing: 8) {
            Text(Strings.Benchmarks.openYoY)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            ForEach(years, id: \.self) { year in
                Text(String(year))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppDesign.Colors.proAccent)
                ForEach(byYear[year] ?? []) { item in
                    benchmarkRow(item)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
    }

    private func benchmarkRow(_ item: CrossfitBenchmark) -> some View {
        let match = CrossfitBenchmarkCatalog.bestMatch(
            for: item,
            in: workoutSessionClient.sessions
        )
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline.weight(.semibold))
                Text(item.style.rawValue.uppercased())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let match {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(Strings.Benchmarks.yourBest)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(match.score.isEmpty ? "—" : match.score)
                        .font(.subheadline.monospacedDigit().weight(.semibold))
                        .foregroundStyle(AppDesign.Colors.brand)
                }
            } else {
                Text(Strings.Benchmarks.emptyMatch)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 140, alignment: .trailing)
            }
        }
        .accessibilityIdentifier("insights.benchmarks.row.\(item.id)")
    }
}
