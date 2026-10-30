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
                    isShimmering: isShimmering,
                    records: personalRecordClient.records
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
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Image(systemName: AppDesign.Icon.emptyInsights)
                    .font(.system(size: AppDesign.Layout.emptyStateIconSize))
                    .foregroundStyle(AppDesign.Colors.brand)

                Text(Strings.Insights.ProEmpty.title)
                    .font(AppDesign.Typography.sectionTitle)

                Text(Strings.Insights.ProEmpty.message)
                    .font(AppDesign.Typography.bodySecondary)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button {
                    NotificationCenter.default.post(name: .navigateToCategories, object: nil)
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(Strings.Insights.ProEmpty.cta)
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
        .background(AppDesign.Colors.background.ignoresSafeArea())
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
    let records: [PersonalRecord]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                InsightsSummarySection(records: records, measureMode: measureMode)
                InsightsLastSessionSection()
                InsightsEngineCardsSection()
                InsightsEliteSection()
                InsightsCoachSection()
                InsightsRecentSessionsSection()

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
            .padding(AppDesign.Layout.horizontalPadding)
        }
        .background(AppDesign.Colors.background.ignoresSafeArea())
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
                .font(AppDesign.Typography.sectionTitle)
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
                    .foregroundStyle(by: .value("Name", record.prName.localizedWorkoutTitle))
                    .annotation(position: .top) {
                        Text(annotation(record))
                            .font(AppDesign.Typography.captionSecondary)
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
