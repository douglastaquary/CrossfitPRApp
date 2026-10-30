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
    @State private var selectedAward: PRAward?

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

    private var context: PRSessionContext? {
        filteredRecords.compactMap(\.sessionContext).first
            ?? maxRecord.sessionContext
    }

    private var visibleAwards: [PRAward] {
        PRAwardEvaluator.awards(from: personalRecordClient.records)
            .filter { $0.isVisible(for: subscriptionClient.currentTier) }
    }

    private var primaryValue: String {
        switch section.group {
        case .barbell:
            let w = isPounds ? maxRecord.poundValue : maxRecord.kiloValue
            return "\(w) \(settingsClient.measureTrackingMode.suffix)"
        case .gymnastic:
            return "\(maxRecord.maxReps) reps"
        case .endurance:
            return "\(maxRecord.distance) km"
        }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                RecordDetailHero(
                    sectionName: section.name.localizedWorkoutTitle,
                    primaryValue: primaryValue,
                    record: maxRecord,
                    context: context
                )

                VStack(alignment: .leading, spacing: 16) {
                    Text(Strings.Record.exerciseDetails)
                        .font(AppDesign.Typography.sectionTitle)

                    if let context {
                        RecordDetailMetricsGrid(context: context)
                    } else {
                        RecordDetailFallbackMetrics(group: section.group, maxRecord: maxRecord, isPounds: isPounds)
                    }
                }
                .padding(.top, 8)

                if section.group == .barbell {
                    NavigationLink(value: maxRecord) {
                        HStack {
                            Text(Strings.Record.percentageSection)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(AppDesign.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }

                if !chartPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(Strings.Record.evolutionSection(section.name.localizedWorkoutTitle))
                            .font(AppDesign.Typography.sectionTitle)
                        Chart {
                            ForEach(chartPoints) { point in
                                BarMark(
                                    x: .value("Date", point.date),
                                    y: .value("Value", point.value)
                                )
                                .foregroundStyle(AppDesign.Colors.activityAccent)
                            }
                        }
                        .frame(height: 180)
                    }
                }

                if !visibleAwards.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(Strings.Record.awards)
                            .font(AppDesign.Typography.sectionTitle)
                        ForEach(visibleAwards) { award in
                            Button {
                                selectedAward = award
                            } label: {
                                PRAwardRowView(award: award)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(Strings.Record.recordsSection)
                        .font(AppDesign.Typography.sectionTitle)
                    ForEach(Array(filteredRecords.enumerated()), id: \.element.id) { index, record in
                        PersonalRecordRowView(record: record, isPounds: isPounds)
                            .contextMenu {
                                Button(Strings.Record.deleteButton, role: .destructive) {
                                    pendingDeleteOffsets = IndexSet(integer: index)
                                    confirmationShown = true
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, AppDesign.Layout.horizontalPadding)
            .padding(.bottom, 40)
        }
        .background(AppDesign.Colors.background.ignoresSafeArea())
        .navigationTitle(section.name.localizedWorkoutTitle)
        .navigationBarTitleDisplayMode(.inline)
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
        .sheet(item: $selectedAward) { award in
            PRAwardDetailSheet(award: award)
        }
        .brandTint()
    }

    private func deleteRecords() async {
        guard subscriptionClient.currentTier.isPaid else {
            showPROUpgrade = true
            return
        }
        guard let offsets = pendingDeleteOffsets else { return }
        for index in offsets {
            await personalRecordClient.delete(filteredRecords[index])
        }
    }
}

// MARK: - Hero

private struct RecordDetailHero: View {
    let sectionName: String
    let primaryValue: String
    let record: PersonalRecord
    let context: PRSessionContext?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let location = context?.locationName {
                Label(location, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text(sectionName)
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)

            Text(primaryValue)
                .font(.system(size: 34, weight: .bold).monospacedDigit())
                .foregroundStyle(AppDesign.Colors.activityAccent)

            Text(dateLine)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                if let context {
                    Label(sourceTitle(context.source), systemImage: context.source.displaySymbol)
                        .font(.caption.weight(.semibold))
                    if let temp = context.temperatureCelsius {
                        Text("\(Int(temp))°")
                            .font(.caption.weight(.semibold))
                    }
                    if let humidity = context.humidityPercent {
                        Text("\(Strings.Record.humidity) \(Int(humidity))%")
                            .font(.caption.weight(.semibold))
                    }
                } else {
                    Text(record.formattedShortDate)
                        .font(.caption.weight(.semibold))
                }
            }
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private var dateLine: String {
        if let start = context?.startedAt, let end = context?.endedAt {
            let day = start.formatted(.dateTime.day().month(.wide).year())
            let range = "\(start.formatted(date: .omitted, time: .shortened))–\(end.formatted(date: .omitted, time: .shortened))"
            return "\(day)  \(range)"
        }
        return record.recordDate.formatted(.dateTime.day().month(.wide).year())
    }

    private func sourceTitle(_ source: PRRecordSource) -> String {
        switch source {
        case .appleWatch: return Strings.PRHistory.Source.appleWatch
        case .manual: return Strings.PRHistory.Source.manual
        case .health: return Strings.PRHistory.Source.health
        }
    }
}

// MARK: - Metrics

private struct RecordDetailMetricsGrid: View {
    let context: PRSessionContext

    private var cells: [(String, String)] {
        var items: [(String, String)] = []
        if let exercise = context.exerciseTime, exercise > 0 {
            items.append((Strings.Insights.Hub.exerciseTime, formatDuration(exercise)))
        }
        if let duration = context.duration, duration > 0 {
            items.append((Strings.Insights.Hub.duration, formatDuration(duration)))
        }
        if let active = context.activeCalories {
            items.append((Strings.Insights.Hub.activeCalories, "\(Int(active.rounded())) CAL"))
        }
        if let total = context.totalCalories {
            items.append((Strings.Insights.Hub.totalCalories, "\(Int(total.rounded())) CAL"))
        }
        if let hr = context.averageHeartRate {
            items.append((Strings.Insights.Hub.averageHR, "\(hr) bpm"))
        }
        return items
    }

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
            alignment: .leading,
            spacing: 20
        ) {
            ForEach(Array(cells.enumerated()), id: \.offset) { _, cell in
                VStack(alignment: .leading, spacing: 4) {
                    Text(cell.0)
                        .font(AppDesign.Typography.metricLabel)
                        .foregroundStyle(.secondary)
                    Text(cell.1)
                        .font(.title2.bold().monospacedDigit())
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(AppDesign.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 14))
    }

    private func formatDuration(_ t: TimeInterval) -> String {
        let total = Int(t)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 { return String(format: "%d:%02d:%02d", h, m, s) }
        return String(format: "%d:%02d:%02d", 0, m, s)
    }
}

private struct RecordDetailFallbackMetrics: View {
    let group: RecordGroup
    let maxRecord: PersonalRecord
    let isPounds: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch group {
            case .barbell:
                metric(Strings.tr("record.weight.title"), isPounds ? "\(maxRecord.poundValue) lb" : "\(maxRecord.kiloValue) kg")
            case .gymnastic:
                metric(Strings.tr("record.maxReps.title"), "\(maxRecord.maxReps)")
                metric(Strings.tr("record.time.title"), "\(maxRecord.minTime) min")
            case .endurance:
                metric(Strings.tr("record.distance.title"), "\(maxRecord.distance) km")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppDesign.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 14))
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(AppDesign.Typography.metricLabel).foregroundStyle(.secondary)
            Text(value).font(.title2.bold())
        }
    }
}

// MARK: - Awards

private struct PRAwardRowView: View {
    let award: PRAward

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "medal.fill")
                .font(.title2)
                .foregroundStyle(AppDesign.Colors.eliteAccent)
                .frame(width: 40, height: 40)
                .background(AppDesign.Colors.eliteAccent.opacity(0.18), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(Strings.tr(award.titleKey))
                    .font(.body.weight(.semibold))
                Text(Strings.Award.earnedTimes(award.earnedCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(AppDesign.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 12))
        .accessibilityIdentifier("pr.award.\(award.id)")
    }
}

public struct PRPercentagesView: View {
    @EnvironmentObject private var settingsClient: SettingsClient

    let record: PersonalRecord

    public init(record: PersonalRecord) {
        self.record = record
    }

    private var percentages: [Int] {
        Array(stride(from: 10, through: 100, by: 10))
    }

    private var measureMode: MeasureTrackingMode {
        settingsClient.measureTrackingMode
    }

    private var baseWeight: Int {
        measureMode.weightValue(poundValue: record.poundValue, kiloValue: record.kiloValue)
    }

    public var body: some View {
        List {
            ForEach(percentages, id: \.self) { pct in
                HStack {
                    Text("\(pct)%")
                    Spacer()
                    Text("\(Int(Double(baseWeight) * Double(pct) / 100.0)) \(measureMode.suffix)")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(Strings.Record.percentageSection)
        .brandTint()
    }
}
