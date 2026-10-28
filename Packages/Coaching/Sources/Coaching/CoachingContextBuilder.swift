import Foundation
import Domain

/// Monta snapshot compacto a partir de PRs + sinais do WorkoutEngine.
public struct CoachingContextBuilder: Sendable {
    public var windowDays: Int
    public var maxMovements: Int

    public init(windowDays: Int = 90, maxMovements: Int = 12) {
        self.windowDays = windowDays
        self.maxMovements = maxMovements
    }

    public func build(
        from records: [PersonalRecord],
        engineInsights: [WorkoutInsight]
    ) -> CoachingContextSnapshot {
        let cutoff = Calendar.current.date(byAdding: .day, value: -windowDays, to: Date()) ?? .distantPast
        let recent = records.filter { $0.recordDate >= cutoff }
        let grouped = Dictionary(grouping: recent, by: { $0.prName.lowercased() })

        var summaries: [CoachingContextSnapshot.MovementSummary] = []
        for (_, prs) in grouped {
            guard let latest = prs.max(by: { $0.recordDate < $1.recordDate }) else { continue }
            let sorted = prs.sorted { $0.recordDate < $1.recordDate }
            let delta = percentDelta(sorted: sorted, latest: latest)
            summaries.append(
                CoachingContextSnapshot.MovementSummary(
                    name: latest.prName,
                    group: latest.group.rawValue,
                    lastValue: displayValue(for: latest),
                    deltaPercent: delta,
                    lastDateISO: isoDay(latest.recordDate)
                )
            )
        }

        summaries.sort { $0.lastDateISO > $1.lastDateISO }
        if summaries.count > maxMovements {
            summaries = Array(summaries.prefix(maxMovements))
        }

        let stalled = summaries.filter { $0.deltaPercent <= 2 }.map(\.name).prefix(3).map { $0 }
        let rising = summaries.filter { $0.deltaPercent >= 8 }.map(\.name).prefix(3).map { $0 }
        let tags = engineInsights
            .filter {
                switch $0.category {
                case .workoutEngine, .trend, .eliteAssessment, .eliteLimitingFactor:
                    return true
                default:
                    return false
                }
            }
            .prefix(6)
            .map { shortTag($0) }

        let hashInput = summaries.map { "\($0.name):\($0.lastValue):\($0.deltaPercent)" }.joined(separator: "|")
        let contextHash = CoachingContextBuilder.stableHash(hashInput)

        return CoachingContextSnapshot(
            windowDays: windowDays,
            contextHash: contextHash,
            movements: summaries,
            stalled: stalled,
            rising: rising,
            engineSignals: CoachingSignals(tags: tags)
        )
    }

    public static func stableHash(_ input: String) -> String {
        var hash: UInt64 = 5381
        for byte in input.utf8 {
            hash = ((hash << 5) &+ hash) &+ UInt64(byte)
        }
        return String(format: "%016llx", hash)
    }

    private func displayValue(for record: PersonalRecord) -> Int {
        switch record.group {
        case .barbell: return record.poundValue
        case .gymnastic: return record.maxReps
        case .endurance: return record.distance
        }
    }

    private func percentDelta(sorted: [PersonalRecord], latest: PersonalRecord) -> Int {
        guard sorted.count >= 2, let first = sorted.first else { return 0 }
        let a = Double(displayValue(for: first))
        let b = Double(displayValue(for: latest))
        guard a > 0 else { return 0 }
        return Int(((b - a) / a) * 100.0)
    }

    private func isoDay(_ date: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f.string(from: date)
    }

    private func shortTag(_ insight: WorkoutInsight) -> String {
        let prefix = insight.category.rawValue
        if let ex = insight.relatedExercise {
            return "\(prefix):\(ex.rawValue)"
        }
        return prefix
    }
}
