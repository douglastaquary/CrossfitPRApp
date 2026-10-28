import Foundation

/// Calcula assessment por domínio e limiting factor (Domain puro — CPR-008).
public struct AthleteAssessmentService: Sendable {
    public init() {}

    public func assess(records: [PersonalRecord]) -> AthleteAssessment {
        guard !records.isEmpty else {
            return AthleteAssessment(scores: [], limitingFactor: nil, assessedRecordCount: 0)
        }

        let scores = AthleteDomain.allCases.map { domain in
            score(domain: domain, records: records)
        }

        let limiting = pickLimitingFactor(from: scores)
        return AthleteAssessment(
            scores: scores,
            limitingFactor: limiting,
            assessedRecordCount: records.count
        )
    }

    private func score(domain: AthleteDomain, records: [PersonalRecord]) -> DomainScore {
        let filtered = records.filter { matches($0, domain: domain) }
        let uniqueMoves = Set(filtered.map { $0.prName.lowercased() })
        let expectedMoves = expectedCoverage(for: domain)
        let coverage = min(1.0, Double(uniqueMoves.count) / Double(expectedMoves))

        let progress = progressIndex(for: filtered)
        let combined = (coverage * 0.55) + (progress * 0.45)
        return DomainScore(
            domain: domain,
            coverage: coverage,
            progress: progress,
            score: combined
        )
    }

    private func matches(_ record: PersonalRecord, domain: AthleteDomain) -> Bool {
        let name = record.prName.lowercased()
        switch domain {
        case .strength:
            return record.group == .barbell && !isOlympicName(name)
        case .olympic:
            return record.group == .barbell && isOlympicName(name)
        case .gymnastics:
            return record.group == .gymnastic
        case .engine:
            return record.group == .endurance
        }
    }

    private func isOlympicName(_ name: String) -> Bool {
        name.contains("snatch")
            || name.contains("clean")
            || name.contains("jerk")
            || name.contains("cluster")
    }

    private func expectedCoverage(for domain: AthleteDomain) -> Int {
        switch domain {
        case .strength: return 4
        case .olympic: return 3
        case .gymnastics: return 4
        case .engine: return 2
        }
    }

    private func progressIndex(for records: [PersonalRecord]) -> Double {
        let grouped = Dictionary(grouping: records, by: { $0.prName.lowercased() })
        guard !grouped.isEmpty else { return 0 }

        var deltas: [Double] = []
        for (_, prs) in grouped {
            let sorted = prs.sorted { $0.recordDate < $1.recordDate }
            guard let first = sorted.first, let last = sorted.last, sorted.count >= 2 else { continue }
            let firstValue = metricValue(first)
            let lastValue = metricValue(last)
            let baseline = max(firstValue, 1)
            let delta = Double(lastValue - firstValue) / Double(baseline)
            deltas.append(min(1.0, max(0, delta * 4)))
        }

        guard !deltas.isEmpty else {
            return records.isEmpty ? 0 : 0.35
        }
        return deltas.reduce(0, +) / Double(deltas.count)
    }

    private func metricValue(_ record: PersonalRecord) -> Int {
        switch record.group {
        case .barbell: return record.poundValue
        case .gymnastic: return record.maxReps
        case .endurance: return max(record.distance, record.minTime)
        }
    }

    private func pickLimitingFactor(from scores: [DomainScore]) -> AthleteDomain? {
        let withData = scores.filter { $0.coverage > 0 || $0.progress > 0 }
        if withData.isEmpty { return nil }

        // Domínio crítico vazio enquanto outros têm cobertura → teto óbvio.
        let emptyCritical = scores.first { $0.coverage == 0 && criticalDomain($0.domain) }
        if let emptyCritical, withData.contains(where: { $0.coverage >= 0.4 }) {
            return emptyCritical.domain
        }

        return withData.min(by: { $0.score < $1.score })?.domain
    }

    private func criticalDomain(_ domain: AthleteDomain) -> Bool {
        switch domain {
        case .strength, .gymnastics, .engine: return true
        case .olympic: return true
        }
    }
}
