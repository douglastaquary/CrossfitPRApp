import Foundation

/// Análise de ranking e charts PRO — lógica pura (substitui InsightsViewModel).
public enum InsightsRanking {
    public static func records(for group: RecordGroup, in allRecords: [PersonalRecord]) -> [PersonalRecord] {
        allRecords
            .filter { $0.group == group }
            .sorted { $0.recordDate < $1.recordDate }
    }

    public static func topBarbellRecords(
        in barbellRecords: [PersonalRecord],
        measureMode: MeasureTrackingMode
    ) -> [PersonalRecord] {
        guard !barbellRecords.isEmpty else { return [] }

        let value: (PersonalRecord) -> Int = measureMode == .pounds
            ? { $0.poundValue }
            : { $0.kiloValue }

        let maxVal = barbellRecords.map(value).max() ?? 0
        guard let maxPR = barbellRecords.first(where: { value($0) == maxVal }) else { return [] }

        var ranking = [maxPR]
        let others = barbellRecords
            .filter { $0.prName != maxPR.prName && value($0) < maxVal }
            .sorted { value($0) > value($1) }

        if let evolution = others.first {
            ranking.append(withEvolution(evolution, comparedTo: maxPR, measureMode: measureMode))
        }

        let minVal = barbellRecords.map(value).min() ?? 0
        if let minPR = barbellRecords.first(where: { value($0) == minVal && $0.prName != maxPR.prName }) {
            ranking.append(minPR)
        }

        return ranking
            .uniqued(by: \.id)
            .sorted { value($0) > value($1) }
    }

    public static func topGymnasticRecords(in records: [PersonalRecord]) -> [PersonalRecord] {
        guard !records.isEmpty else { return [] }
        let maxReps = records.map(\.maxReps).max() ?? 0
        guard let maxPR = records.first(where: { $0.maxReps == maxReps }) else { return [] }
        var ranking = [maxPR]
        if let evolution = records.first(where: { $0.maxReps < maxReps && $0.prName != maxPR.prName }) {
            ranking.append(evolution)
        }
        return ranking.uniqued(by: \.id).sorted { $0.maxReps > $1.maxReps }
    }

    public static func topEnduranceRecords(in records: [PersonalRecord]) -> [PersonalRecord] {
        guard !records.isEmpty else { return [] }
        let maxDistance = records.map(\.distance).max() ?? 0
        guard let maxPR = records.first(where: { $0.distance == maxDistance }) else { return [] }
        var ranking = [maxPR]
        if let evolution = records.first(where: {
            $0.distance < maxDistance && $0.prName != maxPR.prName
        }) {
            ranking.append(evolution)
        }
        return ranking.uniqued(by: \.id).sorted { $0.distance > $1.distance }
    }

    public static func chartAnnotation(for record: PersonalRecord, measureMode: MeasureTrackingMode) -> String {
        switch record.group {
        case .barbell:
            return measureMode == .pounds
                ? "\(record.poundValue) lbs"
                : "\(record.kiloValue) kg"
        case .gymnastic:
            return "\(record.maxReps) reps"
        case .endurance:
            return "\(record.distance) km"
        }
    }

    public static func marketValue(for record: PersonalRecord, measureMode: MeasureTrackingMode) -> (text: String, numeric: Double) {
        switch record.group {
        case .barbell:
            if measureMode == .pounds {
                return ("\(record.poundValue) lb", Double(record.poundValue))
            }
            return ("\(record.kiloValue) kg", Double(record.kiloValue))
        case .gymnastic:
            return ("\(record.maxReps) reps", Double(record.maxReps))
        case .endurance:
            return ("\(record.distance) km", Double(record.distance))
        }
    }

    private static func withEvolution(
        _ record: PersonalRecord,
        comparedTo maxPR: PersonalRecord,
        measureMode: MeasureTrackingMode
    ) -> PersonalRecord {
        var copy = record
        let delta: Int
        if measureMode == .pounds {
            delta = maxPR.poundValue - record.poundValue
        } else {
            delta = maxPR.kiloValue - record.kiloValue
        }
        copy.evolutionPercentage = max(delta, 0)
        return copy
    }
}

private extension Array {
    func uniqued<ID: Hashable>(by keyPath: KeyPath<Element, ID>) -> [Element] {
        var seen = Set<ID>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
