import SwiftUI
import Charts
import Domain
import Application
import Subscription
import PROUpgrade
import SharedUI
import Localization

public struct RecordDetailView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient

    let section: PRSection

    @State private var showPROUpgrade = false
    @State private var confirmationShown = false
    @State private var pendingDeleteOffsets: IndexSet?

    public init(section: PRSection) {
        self.section = section
    }

    private var filteredRecords: [PersonalRecord] {
        PersonalRecordGrouping.records(for: section, in: personalRecordClient.records)
    }

    private var maxRecord: PersonalRecord {
        PersonalRecordGrouping.maxRecord(
            in: filteredRecords,
            group: section.group,
            measureMode: settingsClient.measureTrackingMode
        ) ?? PersonalRecord(prName: section.name, group: section.group)
    }

    private var chartPoints: [RecordPoint] {
        PersonalRecordGrouping.chartPoints(
            from: filteredRecords,
            group: section.group,
            measureMode: settingsClient.measureTrackingMode
        )
    }

    private var isPounds: Bool { settingsClient.measureTrackingMode == .pounds }

    public var body: some View {
        Form {
            Section(Strings.Record.biggestSection) {
                maxRecordHeader
                HSubtitleView(
                    imageSystemName: "calendar",
                    titleKey: "record.date.title",
                    subtitle: maxRecord.formattedShortDate,
                    foregroundColor: AppDesign.Colors.metadataChip
                )
            }

            if section.group == .barbell {
                Section(Strings.Record.percentageSection) {
                    NavigationLink(value: maxRecord) {
                        HSubtitleView(
                            imageSystemName: "percent",
                            titleKey: "record.datail.percentage.title",
                            subtitle: "\(Int(maxRecord.percentage))%"
                        )
                    }
                }
            }

            Section(Strings.Record.evolutionSection(section.name)) {
                Chart {
                    ForEach(chartPoints) { point in
                        BarMark(
                            x: .value("Date", point.date),
                            y: .value("Value", point.value)
                        )
                        .annotation {
                            Text(verbatim: point.value.formatted())
                                .font(.caption)
                        }
                    }
                }
                .frame(height: AppDesign.Layout.chartHeight)
                .padding(.top)
            }

            Section(Strings.Record.recordsSection) {
                ForEach(filteredRecords) { record in
                    PersonalRecordRowView(record: record, isPounds: isPounds)
                }
                .onDelete { offsets in
                    pendingDeleteOffsets = offsets
                    confirmationShown = true
                }
            }
        }
        .navigationTitle(section.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: PersonalRecord.self) { record in
            PRPercentagesView(record: record)
        }
        .confirmationDialog(
            Strings.Record.deleteConfirmation,
            isPresented: $confirmationShown,
            titleVisibility: .visible
        ) {
            Button(Strings.Record.deleteButton, role: .destructive) {
                Task { await deleteRecords() }
            }
            Button(Strings.NewPR.cancel, role: .cancel) {}
        }
        .sheet(isPresented: $showPROUpgrade) {
            PROUpgradeView()
        }
        .brandTint()
    }

    @ViewBuilder
    private var maxRecordHeader: some View {
        switch section.group {
        case .barbell:
            HSubtitleView(
                titleKey: "record.weight.title",
                subtitle: isPounds ? "\(maxRecord.poundValue) lb" : "\(maxRecord.kiloValue) kg",
                foregroundColor: AppDesign.Colors.weightChip
            )
        case .gymnastic:
            HSubtitleView(
                imageSystemName: "flame",
                titleKey: "record.maxReps.title",
                subtitle: "\(maxRecord.maxReps)",
                foregroundColor: AppDesign.Colors.weightChip
            )
            HSubtitleView(
                imageSystemName: "timer",
                titleKey: "record.time.title",
                subtitle: "\(maxRecord.minTime) min",
                foregroundColor: AppDesign.Colors.proAccent
            )
        case .endurance:
            HSubtitleView(
                imageSystemName: "point.filled.topleft.down.curvedto.point.bottomright.up",
                titleKey: "record.distance.title",
                subtitle: "\(maxRecord.distance) km"
            )
            HSubtitleView(
                imageSystemName: "watchface.applewatch.case",
                titleKey: "record.time.title",
                subtitle: "\(maxRecord.minTime) min",
                foregroundColor: AppDesign.Colors.proAccent
            )
        }
    }

    private func deleteRecords() async {
        guard subscriptionClient.currentTier == .pro else {
            showPROUpgrade = true
            return
        }
        guard let offsets = pendingDeleteOffsets else { return }
        for index in offsets {
            await personalRecordClient.delete(filteredRecords[index])
        }
    }
}

public struct PRPercentagesView: View {
    let record: PersonalRecord

    public init(record: PersonalRecord) {
        self.record = record
    }

    private var percentages: [Int] {
        Array(stride(from: 10, through: 100, by: 10))
    }

    public var body: some View {
        List {
            ForEach(percentages, id: \.self) { pct in
                HStack {
                    Text("\(pct)%")
                    Spacer()
                    Text("\(Int(Double(record.poundValue) * Double(pct) / 100.0)) lb")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(Strings.Record.percentageSection)
        .brandTint()
    }
}
