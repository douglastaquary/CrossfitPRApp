import Foundation

/// Prêmio / marco de PR (CPR-013) — densidade varia por plano.
public struct PRAward: Identifiable, Hashable, Sendable, Codable {
    public var id: String
    public var titleKey: String
    public var bodyKey: String
    public var earnedCount: Int
    public var latestDate: Date
    public var minimumTier: SubscriptionTier

    public init(
        id: String,
        titleKey: String,
        bodyKey: String,
        earnedCount: Int = 1,
        latestDate: Date = Date(),
        minimumTier: SubscriptionTier = .free
    ) {
        self.id = id
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.earnedCount = earnedCount
        self.latestDate = latestDate
        self.minimumTier = minimumTier
    }

    public func isVisible(for tier: SubscriptionTier) -> Bool {
        switch minimumTier {
        case .free: return true
        case .pro: return tier == .pro || tier == .elite
        case .elite: return tier == .elite
        }
    }
}

public enum PRAwardEvaluator {
    public static func awards(from records: [PersonalRecord], asOf date: Date = Date()) -> [PRAward] {
        guard !records.isEmpty else { return [] }
        var result: [PRAward] = []

        if let newest = records.max(by: { $0.recordDate < $1.recordDate }) {
            result.append(
                PRAward(
                    id: "new-pr",
                    titleKey: "award.newPR.title",
                    bodyKey: "award.newPR.body",
                    earnedCount: records.count,
                    latestDate: newest.recordDate,
                    minimumTier: .free
                )
            )
        }

        let calendar = Calendar.current
        let weekRecords = records.filter { calendar.isDate($0.recordDate, equalTo: date, toGranularity: .weekOfYear) }
        if weekRecords.count >= 3 {
            result.append(
                PRAward(
                    id: "week-active",
                    titleKey: "award.weekActive.title",
                    bodyKey: "award.weekActive.body",
                    earnedCount: max(1, weekRecords.count / 3),
                    latestDate: weekRecords.map(\.recordDate).max() ?? date,
                    minimumTier: .pro
                )
            )
        }

        let improved = records.filter { $0.evolutionPercentage >= 5 }
        if improved.count >= 2 {
            result.append(
                PRAward(
                    id: "evolution",
                    titleKey: "award.evolution.title",
                    bodyKey: "award.evolution.body",
                    earnedCount: improved.count,
                    latestDate: improved.map(\.recordDate).max() ?? date,
                    minimumTier: .pro
                )
            )
        }

        let eliteLifts = records.filter { $0.group == .barbell && $0.poundValue >= 300 }
        if !eliteLifts.isEmpty {
            result.append(
                PRAward(
                    id: "heavy-metal",
                    titleKey: "award.heavyMetal.title",
                    bodyKey: "award.heavyMetal.body",
                    earnedCount: eliteLifts.count,
                    latestDate: eliteLifts.map(\.recordDate).max() ?? date,
                    minimumTier: .elite
                )
            )
        }

        return result
    }
}
