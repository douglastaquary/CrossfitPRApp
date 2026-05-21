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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                rankingSection
                barbellChartSection
                gymnasticChartSection
                enduranceChartSection
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
