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
                InsightsViewPROContent(
                    gridColumns: gridColumns,
                    measureMode: settingsClient.measureTrackingMode,
                    topBarbell: topBarbell,
                    barbellRecords: barbellRecords,
                    gymnasticRecords: gymnasticRecords,
                    enduranceRecords: enduranceRecords,
                    isShimmering: isShimmering
                )
            } else {
                InsightsViewPROEmptySection()
            }
        }
    }
}

// MARK: - Empty State

private struct InsightsViewPROEmptySection: View {
    var body: some View {
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
                    InsightsViewPROFeaturePreviewRow(
                        icon: "trophy.fill",
                        title: "Ranking de PRs",
                        description: "Veja seus melhores records organizados",
                        color: .orange
                    )
                    InsightsViewPROFeaturePreviewRow(
                        icon: "chart.bar.fill",
                        title: "Gráficos por categoria",
                        description: "Barbell, ginástico e resistência",
                        color: AppDesign.Colors.brand
                    )
                    InsightsViewPROFeaturePreviewRow(
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
}

private struct InsightsViewPROFeaturePreviewRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
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
}

// MARK: - Insights Content

private struct InsightsViewPROContent: View {
    let gridColumns: [GridItem]
    let measureMode: MeasureTrackingMode
    let topBarbell: [PersonalRecord]
    let barbellRecords: [PersonalRecord]
    let gymnasticRecords: [PersonalRecord]
    let enduranceRecords: [PersonalRecord]
    let isShimmering: Bool

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                if !topBarbell.isEmpty {
                    InsightsViewPRORankingSection(
                        gridColumns: gridColumns,
                        topBarbell: topBarbell,
                        measureMode: measureMode
                    )
                }
                if !barbellRecords.isEmpty {
                    InsightsViewPROChartSection(
                        icon: "figure.strengthtraining.traditional",
                        titleKey: "insight.section.ranking.barbell.title",
                        records: barbellRecords,
                        isShimmering: isShimmering,
                        annotation: { record in
                            InsightsRanking.chartAnnotation(for: record, measureMode: measureMode)
                        },
                        value: { record in
                            Double(measureMode == .pounds ? record.poundValue : record.kiloValue)
                        }
                    )
                }
                if !gymnasticRecords.isEmpty {
                    InsightsViewPROChartSection(
                        icon: "figure.play",
                        titleKey: "insight.section.ranking.gymnastic.title",
                        records: gymnasticRecords,
                        isShimmering: isShimmering,
                        annotation: { record in "\(record.maxReps) reps" },
                        value: { record in Double(record.maxReps) }
                    )
                }
                if !enduranceRecords.isEmpty {
                    InsightsViewPROChartSection(
                        icon: "flame",
                        titleKey: "insight.section.ranking.endurance.title",
                        records: enduranceRecords,
                        isShimmering: isShimmering,
                        annotation: { record in "\(record.distance) km" },
                        value: { record in Double(record.distance) }
                    )
                }
            }
            .padding(16)
        }
    }
}

private struct InsightsViewPRORankingSection: View {
    let gridColumns: [GridItem]
    let topBarbell: [PersonalRecord]
    let measureMode: MeasureTrackingMode

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            InsightsViewPROSectionHeader(icon: "trophy", titleKey: "insight.section.topranking.barbell.title")
            LazyVGrid(columns: gridColumns, spacing: 14) {
                ForEach(Array(topBarbell.enumerated()), id: \.element.id) { index, record in
                    RankingCardView(
                        record: record,
                        measureMode: measureMode,
                        accentColor: RankingAccent.color(for: index)
                    )
                }
            }
        }
    }
}

private struct InsightsViewPROSectionHeader: View {
    let icon: String
    let titleKey: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
            Text(Strings.tr(titleKey))
                .font(.title2.bold())
            Spacer()
        }
    }
}

private struct InsightsViewPROChartSection: View {
    let icon: String
    let titleKey: String
    let records: [PersonalRecord]
    let isShimmering: Bool
    let annotation: (PersonalRecord) -> String
    let value: (PersonalRecord) -> Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            InsightsViewPROSectionHeader(icon: icon, titleKey: titleKey)
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
