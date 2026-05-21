import SwiftUI
import Domain
import Application
import SharedUI
import Localization

struct InsightsTeaserView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @Binding var isPresentingPROUpgrade: Bool

    private var hasRecords: Bool {
        !personalRecordClient.records.isEmpty
    }

    private var recordCount: Int {
        personalRecordClient.records.count
    }

    private var topRecord: PersonalRecord? {
        personalRecordClient.records.max { $0.poundValue < $1.poundValue }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                if hasRecords {
                    previewSection
                }

                teaserCard

                featuresSection

                ctaButton
            }
            .padding(20)
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(AppDesign.Colors.brand)
                Text("Sua evolução até aqui")
                    .font(.headline)
                Spacer()
            }

            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(recordCount)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(AppDesign.Colors.brand)
                        Text("PRs registrados")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if let top = topRecord {
                        VStack(alignment: .trailing, spacing: 4) {
                            let weight = settingsClient.measureTrackingMode == .pounds
                                ? top.poundValue
                                : top.kiloValue
                            let suffix = settingsClient.measureTrackingMode.suffix
                            Text("\(weight) \(suffix)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(AppDesign.Colors.brand)
                            Text("Maior PR")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
        }
    }

    private var teaserCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(AppDesign.Colors.proAccent)
                Text(Strings.tr("insight.teaser.title"))
                    .font(.title2.bold())
                Spacer()
                Text("PRO")
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
                teaserFeatureRow(icon: "chart.bar.fill", text: Strings.tr("insight.teaser.feature1"))
                teaserFeatureRow(icon: "exclamationmark.triangle.fill", text: Strings.tr("insight.teaser.feature2"))
                teaserFeatureRow(icon: "target", text: Strings.tr("insight.teaser.feature3"))
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

    private func teaserFeatureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(AppDesign.Colors.proAccent)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("O que você ganha")
                .font(.headline)

            VStack(spacing: 12) {
                featureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: Strings.tr("proFeature.trendCharts"),
                    color: AppDesign.Colors.brand
                )
                featureRow(
                    icon: "brain.head.profile",
                    title: Strings.tr("proFeature.detailedAIAnalysis"),
                    color: .purple
                )
                featureRow(
                    icon: "target",
                    title: Strings.tr("proFeature.personalizedRecommendations"),
                    color: .orange
                )
                featureRow(
                    icon: "bolt.fill",
                    title: Strings.tr("proFeature.workoutEngineAnalysis"),
                    color: .yellow
                )
            }
        }
    }

    private func featureRow(icon: String, title: String, color: Color) -> some View {
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

    private var ctaButton: some View {
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

            Text(Strings.tr("purchase.lessthancoffe"))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
