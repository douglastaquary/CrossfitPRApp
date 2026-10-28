import SwiftUI
import Domain
import Application
import Localization

// MARK: - Empty State

struct InsightsTeaserEmptySection: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundStyle(AppDesign.Colors.brand.opacity(0.6))

            VStack(spacing: 8) {
                Text(Strings.Insights.Teaser.emptyTitle)
                    .font(.title2.bold())

                Text(Strings.Insights.Teaser.emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                NotificationCenter.default.post(name: .navigateToCategories, object: nil)
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text(Strings.Insights.Teaser.emptyCTA)
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppDesign.Colors.brand)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Preview Section (com PRs)

struct InsightsTeaserPreviewSection: View {
    let recordCount: Int
    let topRecord: PersonalRecord?
    let measureTrackingMode: MeasureTrackingMode

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(AppDesign.Colors.brand)
                Text(Strings.Insights.Teaser.previewHeader)
                    .font(.headline)
                Spacer()
            }

            HStack {
                InsightsTeaserStatCard(value: "\(recordCount)", label: Strings.Insights.Teaser.statsRegistered)
                Spacer()
                if let top = topRecord {
                    let weight = measureTrackingMode == .pounds ? top.poundValue : top.kiloValue
                    let suffix = measureTrackingMode.suffix
                    InsightsTeaserStatCard(
                        value: "\(weight) \(suffix)",
                        label: Strings.Insights.Teaser.statsTopPR,
                        alignment: .trailing
                    )
                }
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
        }
    }
}

struct InsightsTeaserStatCard: View {
    let value: String
    let label: String
    var alignment: HorizontalAlignment = .leading

    var body: some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(AppDesign.Colors.brand)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Categories Section

struct InsightsTeaserCategoriesSection: View {
    let categories: [RecordGroup]
    let records: [PersonalRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.Insights.Teaser.categoriesHeader)
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { group in
                    InsightsTeaserCategoryChip(
                        group: group,
                        count: records.filter { $0.group == group }.count
                    )
                }
            }
        }
    }
}

struct InsightsTeaserCategoryChip: View {
    let group: RecordGroup
    let count: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconFor(group))
                .font(.caption)
            Text(group.localizedDisplayName)
                .font(.caption.weight(.medium))
            Text("(\(count))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppDesign.Colors.brand.opacity(0.1))
        .foregroundStyle(AppDesign.Colors.brand)
        .cornerRadius(20)
    }

    private func iconFor(_ group: RecordGroup) -> String {
        switch group {
        case .barbell: return "figure.strengthtraining.traditional"
        case .gymnastic: return "figure.gymnastics"
        case .endurance: return "figure.run"
        }
    }
}

// MARK: - Teaser Card

struct InsightsTeaserCardSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(AppDesign.Colors.proAccent)
                Text(Strings.tr("insight.teaser.title"))
                    .font(.title2.bold())
                Spacer()
                Text(Strings.Insights.proBadge)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppDesign.Colors.proAccent)
                    .foregroundStyle(.white)
                    .cornerRadius(4)
            }

            Text(Strings.tr("insight.teaser.description"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                InsightsTeaserFeatureLine(icon: "chart.bar.fill", text: Strings.tr("insight.teaser.feature1"))
                InsightsTeaserFeatureLine(icon: "exclamationmark.triangle.fill", text: Strings.tr("insight.teaser.feature2"))
                InsightsTeaserFeatureLine(icon: "target", text: Strings.tr("insight.teaser.feature3"))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppDesign.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppDesign.Colors.proAccent.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InsightsTeaserFeatureLine: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(AppDesign.Colors.proAccent)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

// MARK: - Features Section

struct InsightsTeaserFeaturesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Strings.Insights.Teaser.benefitsHeader)
                .font(.headline)

            VStack(spacing: 12) {
                InsightsTeaserProFeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: Strings.tr("proFeature.trendCharts"),
                    color: AppDesign.Colors.brand
                )
                InsightsTeaserProFeatureRow(
                    icon: "brain.head.profile",
                    title: Strings.tr("proFeature.detailedAIAnalysis"),
                    color: .purple
                )
                InsightsTeaserProFeatureRow(
                    icon: "target",
                    title: Strings.tr("proFeature.personalizedRecommendations"),
                    color: .orange
                )
                InsightsTeaserProFeatureRow(
                    icon: "bolt.fill",
                    title: Strings.tr("proFeature.workoutEngineAnalysis"),
                    color: .yellow
                )
            }
        }
    }
}

struct InsightsTeaserProFeatureRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 32, height: 32)
                .foregroundStyle(color)
            Text(title)
                .font(.subheadline)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - CTA

struct InsightsTeaserCTASection: View {
    @Binding var isPresentingPROUpgrade: Bool

    var body: some View {
        VStack(spacing: 8) {
            Button {
                isPresentingPROUpgrade = true
            } label: {
                HStack {
                    Text(Strings.tr("insight.teaser.cta"))
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppDesign.Colors.brand)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .accessibilityIdentifier("insights.teaser.pro.cta")

            Text(Strings.tr("purchase.lessthancoffe"))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
