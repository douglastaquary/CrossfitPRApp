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

    private var categoriesWithRecords: [RecordGroup] {
        let groups = Set(personalRecordClient.records.map(\.group))
        return RecordGroup.allCases.filter { groups.contains($0) }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                if hasRecords {
                    previewSection
                    categoriesSection
                } else {
                    emptyStateSection
                }

                teaserCard

                featuresSection

                ctaButton
            }
            .padding(20)
        }
    }

    // MARK: - Empty State

    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundStyle(AppDesign.Colors.brand.opacity(0.6))

            VStack(spacing: 8) {
                Text("Sua jornada começa aqui")
                    .font(.title2.bold())

                Text("Registre seu primeiro PR e veja sua evolução ganhar forma. Cada record conta uma história de superação.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                NotificationCenter.default.post(name: .navigateToCategories, object: nil)
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar meu primeiro PR")
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

    // MARK: - Preview Section (com PRs)

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(AppDesign.Colors.brand)
                Text("Sua evolução até aqui")
                    .font(.headline)
                Spacer()
            }

            HStack {
                statCard(value: "\(recordCount)", label: "PRs registrados")
                Spacer()
                if let top = topRecord {
                    let weight = settingsClient.measureTrackingMode == .pounds
                        ? top.poundValue
                        : top.kiloValue
                    let suffix = settingsClient.measureTrackingMode.suffix
                    statCard(value: "\(weight) \(suffix)", label: "Maior PR", alignment: .trailing)
                }
            }
            .padding()
            .background(AppDesign.Colors.cardBackground)
            .cornerRadius(12)
        }
    }

    private func statCard(value: String, label: String, alignment: HorizontalAlignment = .leading) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(AppDesign.Colors.brand)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Categories Section

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categorias com PRs")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(categoriesWithRecords, id: \.self) { group in
                    categoryChip(for: group)
                }
            }
        }
    }

    private func categoryChip(for group: RecordGroup) -> some View {
        let count = personalRecordClient.records.filter { $0.group == group }.count
        return HStack(spacing: 6) {
            Image(systemName: iconFor(group))
                .font(.caption)
            Text("\(group.rawValue.capitalized)")
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

    // MARK: - Teaser Card

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

    // MARK: - Features Section

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

    // MARK: - CTA

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

// MARK: - Notification Extension

extension Notification.Name {
    static let navigateToCategories = Notification.Name("navigateToCategories")
}
