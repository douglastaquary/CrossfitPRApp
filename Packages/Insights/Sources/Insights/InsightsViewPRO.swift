import SwiftUI
import Charts
import Domain
import Application
import SharedUI
import Localization

struct InsightsViewPRO: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient

    @State private var isShimmering = false

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]

    private var hasRecords: Bool {
        !personalRecordClient.records.isEmpty
    }

    private var barbellRecords: [PersonalRecord] {
        InsightsRanking.records(for: .barbell, in: personalRecordClient.records)
    }

    private var gymnasticRecords: [PersonalRecord] {
        InsightsRanking.records(for: .gymnastic, in: personalRecordClient.records)
    }

    private var enduranceRecords: [PersonalRecord] {
        InsightsRanking.records(for: .endurance, in: personalRecordClient.records)
    }

    private var topBarbell: [PersonalRecord] {
        InsightsRanking.topBarbellRecords(in: barbellRecords, measureMode: settingsClient.measureTrackingMode)
    }

    var body: some View {
        Group {
            if hasRecords {
                insightsContent
            } else {
                emptyStateView
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(AppDesign.Colors.brand.opacity(0.1))
                            .frame(width: 120, height: 120)

                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 48))
                            .foregroundStyle(AppDesign.Colors.brand)
                    }

                    VStack(spacing: 12) {
                        Text("Seus insights estão prontos")
                            .font(.title2.bold())

                        Text("Registre seu primeiro PR e veja gráficos de evolução, rankings e análises personalizadas aparecerem aqui.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }

                VStack(spacing: 16) {
                    featurePreview(
                        icon: "trophy.fill",
                        title: "Ranking de PRs",
                        description: "Veja seus melhores records organizados",
                        color: .orange
                    )
                    featurePreview(
                        icon: "chart.bar.fill",
                        title: "Gráficos por categoria",
                        description: "Barbell, ginástico e resistência",
                        color: AppDesign.Colors.brand
                    )
                    featurePreview(
                        icon: "target",
                        title: "Metas personalizadas",
                        description: "Projeções baseadas no seu ritmo",
                        color: .purple
                    )
                }
                .padding(.horizontal, 24)

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
                .padding(.horizontal, 24)

                Spacer(minLength: 40)
            }
        }
    }

    private func featurePreview(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 44, height: 44)
                .foregroundStyle(color)
                .background(color.opacity(0.1))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(AppDesign.Colors.cardBackground)
        .cornerRadius(12)
    }

    // MARK: - Insights Content

    private var insightsContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                if !topBarbell.isEmpty {
                    rankingSection
                }
                if !barbellRecords.isEmpty {
                    barbellChartSection
                }
                if !gymnasticRecords.isEmpty {
                    gymnasticChartSection
                }
                if !enduranceRecords.isEmpty {
                    enduranceChartSection
                }
            }
            .padding(16)
        }
    }

    private var rankingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(icon: "trophy", titleKey: "insight.section.topranking.barbell.title")
            LazyVGrid(columns: gridColumns, spacing: 14) {
                ForEach(Array(topBarbell.enumerated()), id: \.element.id) { index, record in
                    RankingCardView(
                        record: record,
                        measureMode: settingsClient.measureTrackingMode,
                        accentColor: RankingAccent.color(for: index)
                    )
                }
            }
        }
    }

    private var barbellChartSection: some View {
        chartSection(
            icon: "figure.strengthtraining.traditional",
            titleKey: "insight.section.ranking.barbell.title",
            records: barbellRecords
        ) { record in
            InsightsRanking.chartAnnotation(for: record, measureMode: settingsClient.measureTrackingMode)
        } value: { record in
            Double(settingsClient.measureTrackingMode == .pounds ? record.poundValue : record.kiloValue)
        }
    }

    private var gymnasticChartSection: some View {
        chartSection(
            icon: "figure.play",
            titleKey: "insight.section.ranking.gymnastic.title",
            records: gymnasticRecords
        ) { record in
            "\(record.maxReps) reps"
        } value: { record in
            Double(record.maxReps)
        }
    }

    private var enduranceChartSection: some View {
        chartSection(
            icon: "flame",
            titleKey: "insight.section.ranking.endurance.title",
            records: enduranceRecords
        ) { record in
            "\(record.distance) km"
        } value: { record in
            Double(record.distance)
        }
    }

    private func sectionHeader(icon: String, titleKey: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
            Text(Strings.tr(titleKey))
                .font(.title2.bold())
            Spacer()
        }
    }

    private func chartSection(
        icon: String,
        titleKey: String,
        records: [PersonalRecord],
        annotation: @escaping (PersonalRecord) -> String,
        value: @escaping (PersonalRecord) -> Double
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(icon: icon, titleKey: titleKey)
            Chart {
                ForEach(records) { record in
                    BarMark(
                        x: .value("Date", record.formattedShortDate),
                        y: .value("Value", value(record))
                    )
                    .foregroundStyle(by: .value("Name", record.prName))
                    .annotation(position: .top) {
                        Text(annotation(record))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: AppDesign.Layout.chartHeight)
            .shimmering(active: isShimmering)
        }
        .padding(.vertical, 8)
    }
}
