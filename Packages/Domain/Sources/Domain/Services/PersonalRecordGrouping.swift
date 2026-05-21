import Foundation

/// Agrupa e analisa PRs — lógica pura de domínio (sem ViewModels).
public enum PersonalRecordGrouping {
    public static func sections(from records: [PersonalRecord]) -> [PRSection] {
        let grouped = Dictionary(grouping: records) { $0.prName.lowercased() }
        return grouped.map { _, prs in
            let sorted = prs.sorted { $0.recordDate > $1.recordDate }
            let first = sorted.first!
            return PRSection(name: first.prName, group: first.group, records: sorted)
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    public static func records(for section: PRSection, in allRecords: [PersonalRecord]) -> [PersonalRecord] {
        allRecords
            .filter { $0.prName.caseInsensitiveCompare(section.name) == .orderedSame }
            .sorted { $0.recordDate > $1.recordDate }
    }

    public static func maxRecord(
        in records: [PersonalRecord],
        group: RecordGroup,
        measureMode: MeasureTrackingMode
    ) -> PersonalRecord? {
        guard !records.isEmpty else { return nil }
        switch group {
        case .barbell:
            if measureMode == .pounds {
                let maxVal = records.map(\.poundValue).max() ?? 0
                return records.first { $0.poundValue == maxVal }
            }
            let maxVal = records.map(\.kiloValue).max() ?? 0
            return records.first { $0.kiloValue == maxVal }
        case .endurance:
            let maxVal = records.map(\.distance).max() ?? 0
            return records.first { $0.distance == maxVal }
        case .gymnastic:
            let maxVal = records.map(\.maxReps).max() ?? 0
            return records.first { $0.maxReps == maxVal }
        }
    }

    public static func chartPoints(
        from records: [PersonalRecord],
        group: RecordGroup,
        measureMode: MeasureTrackingMode
    ) -> [RecordPoint] {
        let sorted = records.sorted { $0.recordDate < $1.recordDate }
        switch group {
        case .barbell:
            let usePounds = measureMode == .pounds
            return sorted.map { pr in
                RecordPoint(
                    name: pr.prName,
                    date: pr.formattedShortDate,
                    legend: "\(pr.percentage)",
                    value: Double(usePounds ? pr.poundValue : pr.kiloValue)
                )
            }
        case .endurance:
            return sorted.map { pr in
                RecordPoint(
                    name: pr.prName,
                    date: pr.formattedShortDate,
                    legend: "\(pr.minTime)",
                    value: Double(pr.distance)
                )
            }
        case .gymnastic:
            return sorted.map { pr in
                RecordPoint(
                    name: pr.prName,
                    date: pr.formattedShortDate,
                    legend: "\(pr.minTime)",
                    value: Double(pr.maxReps)
                )
            }
        }
    }

    public static func categories(in group: RecordGroup, searchText: String = "") -> [WorkoutCategory] {
        let filtered = CrossfitCatalog.allCategories.filter { $0.group == group }
        guard !searchText.isEmpty else { return filtered.sorted() }
        return filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }.sorted()
    }

    public static func searchCategories(for searchText: String) -> [WorkoutCategory] {
        guard !searchText.isEmpty else { return CrossfitCatalog.allCategories.sorted() }
        return CrossfitCatalog.allCategories
            .filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            .sorted()
    }
}
