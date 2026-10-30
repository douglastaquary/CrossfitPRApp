import SwiftUI
import Domain
import Application
import SharedUI
import RecordDetail
import Localization

public struct PRHistoriesListView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @State private var searchText = ""
    @State private var selectedFilter: PRListFilter = .all

    public init() {}

    private var sections: [PRSection] {
        PersonalRecordGrouping.sections(from: personalRecordClient.records)
    }

    private var filteredSections: [PRSection] {
        var result = sections
        if selectedFilter != .all {
            result = result.filter { $0.group == selectedFilter.group }
        }
        guard !searchText.isEmpty else { return result }
        return result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var monthGroups: [(key: String, sections: [PRSection])] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")

        let grouped = Dictionary(grouping: filteredSections) { section -> DateComponents in
            let date = section.records.map(\.recordDate).max() ?? Date()
            return calendar.dateComponents([.year, .month], from: date)
        }

        return grouped.keys.sorted { lhs, rhs in
            let ld = calendar.date(from: lhs) ?? .distantPast
            let rd = calendar.date(from: rhs) ?? .distantPast
            return ld > rd
        }
        .compactMap { comps -> (String, [PRSection])? in
            guard let date = calendar.date(from: comps) else { return nil }
            let title = formatter.string(from: date)
            let secs = (grouped[comps] ?? []).sorted {
                ($0.records.map(\.recordDate).max() ?? .distantPast)
                    > ($1.records.map(\.recordDate).max() ?? .distantPast)
            }
            return (title, secs)
        }
    }

    public var body: some View {
        NavigationStack {
            Group {
                if personalRecordClient.isLoading && sections.isEmpty {
                    ProgressView(Strings.PRHistory.loading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if sections.isEmpty {
                    PRHistoriesEmptyState()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            PRCategoryFilterChips(selected: $selectedFilter)
                                .padding(.horizontal, AppDesign.Layout.horizontalPadding)
                                .padding(.vertical, 8)

                            ForEach(monthGroups, id: \.key) { group in
                                Section {
                                    ForEach(group.sections) { section in
                                        NavigationLink(value: section) {
                                            PRSessionRowView(
                                                section: section,
                                                measureMode: settingsClient.measureTrackingMode
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                } header: {
                                    PRMonthStickyHeader(title: group.key)
                                }
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .background(AppDesign.Colors.background.ignoresSafeArea())
                }
            }
            .navigationTitle(Strings.Screen.records)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: Strings.Category.searchPrompt)
            .navigationDestination(for: PRSection.self) { section in
                RecordDetailView(section: section)
            }
            .task { await personalRecordClient.fetchRecords() }
            .refreshable { await personalRecordClient.fetchRecords() }
        }
        .brandTint()
    }
}

// MARK: - Filter

enum PRListFilter: String, CaseIterable, Identifiable {
    case all, barbell, gymnastic, endurance
    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return Strings.PRHistory.Filter.all
        case .barbell: return Strings.PRHistory.Filter.barbell
        case .gymnastic: return Strings.PRHistory.Filter.gymnastic
        case .endurance: return Strings.PRHistory.Filter.endurance
        }
    }

    var group: RecordGroup? {
        switch self {
        case .all: return nil
        case .barbell: return .barbell
        case .gymnastic: return .gymnastic
        case .endurance: return .endurance
        }
    }
}

private struct PRCategoryFilterChips: View {
    @Binding var selected: PRListFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PRListFilter.allCases) { filter in
                    Button {
                        selected = filter
                    } label: {
                        Text(filter.title)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(
                                    selected == filter
                                        ? AppDesign.Colors.activityAccent
                                        : AppDesign.Colors.cardBackground
                                )
                            )
                            .foregroundStyle(selected == filter ? Color.black : Color.primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("pr.filter.\(filter.rawValue)")
                }
            }
        }
    }
}

private struct PRMonthStickyHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppDesign.Layout.horizontalPadding)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
    }
}

private struct PRSessionRowView: View {
    let section: PRSection
    let measureMode: MeasureTrackingMode

    private var latest: PersonalRecord? {
        section.records.max(by: { $0.recordDate < $1.recordDate })
    }

    private var valueText: String {
        guard let record = latest else { return "—" }
        switch section.group {
        case .barbell:
            let w = measureMode == .pounds ? record.poundValue : record.kiloValue
            return "\(w) \(measureMode.suffix)"
        case .gymnastic:
            return "\(record.maxReps) reps"
        case .endurance:
            return "\(record.distance) km"
        }
    }

    private var iconName: String {
        switch section.group {
        case .barbell: return "figure.strengthtraining.traditional"
        case .gymnastic: return "figure.play"
        case .endurance: return "flame.fill"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(AppDesign.Colors.activityAccent)
                .frame(width: 36, height: 36)
                .background(AppDesign.Colors.activityAccent.opacity(0.15), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(section.name.localizedWorkoutTitle)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(valueText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let latest {
                Text(latest.recordDate, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, AppDesign.Layout.horizontalPadding)
        .padding(.vertical, 12)
        .background(AppDesign.Colors.background)
        .accessibilityIdentifier("pr.row.\(section.name)")
    }
}

private struct PRHistoriesEmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: AppDesign.Icon.emptyPRs)
                .font(.system(size: AppDesign.Layout.emptyStateIconSize))
                .foregroundStyle(AppDesign.Colors.brand)
            Text(Strings.PRHistory.emptyMessage)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppDesign.Colors.background.ignoresSafeArea())
    }
}
