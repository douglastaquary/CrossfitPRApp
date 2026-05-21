import Foundation

/// Entidade principal — registro de PR (Personal Record) de um exercício (REASONS E).
public struct PersonalRecord: Identifiable, Hashable, Sendable, Codable {
    public var id: UUID
    public var prName: String
    public var recordDate: Date
    public var kiloValue: Int
    public var poundValue: Int
    public var distance: Int
    public var percentage: Float
    public var crossfitLevel: CrossfitLevel?
    public var recordMode: RecordMode
    public var group: RecordGroup
    public var maxReps: Int
    public var minTime: Int
    public var comments: String
    public var evolutionPercentage: Int

    public init(
        id: UUID = UUID(),
        prName: String = "",
        recordDate: Date = Date(),
        kiloValue: Int = 0,
        poundValue: Int = 0,
        distance: Int = 0,
        percentage: Float = 10,
        crossfitLevel: CrossfitLevel? = nil,
        recordMode: RecordMode = .maxWeight,
        group: RecordGroup = .barbell,
        maxReps: Int = 0,
        minTime: Int = 0,
        comments: String = "",
        evolutionPercentage: Int = 0
    ) {
        self.id = id
        self.prName = prName
        self.recordDate = recordDate
        self.kiloValue = kiloValue
        self.poundValue = poundValue
        self.distance = distance
        self.percentage = percentage
        self.crossfitLevel = crossfitLevel
        self.recordMode = recordMode
        self.group = group
        self.maxReps = maxReps
        self.minTime = minTime
        self.comments = comments
        self.evolutionPercentage = evolutionPercentage
    }

    /// Init legado — compatível com WorkoutEngine e testes SPM.
    public init(
        exercise: Exercise,
        date: Date,
        pounds: Double,
        goalDuration: TimeInterval
    ) {
        self.init(
            prName: exercise.kind.rawValue,
            recordDate: date,
            kiloValue: Int(pounds * 0.453592),
            poundValue: Int(pounds),
            recordMode: .maxWeight,
            group: .barbell,
            minTime: Int(goalDuration)
        )
    }

    // MARK: - Compat aliases (WorkoutEngine / clients)

    public var date: Date { recordDate }
    public var pounds: Double { Double(poundValue) }
    public var goalDuration: TimeInterval { TimeInterval(minTime) }

    public var exercise: Exercise {
        Exercise(kind: ActivityKind.fromTitle(prName) ?? .empty)
    }

    public var formattedShortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: recordDate)
    }
}

public extension PersonalRecord {
    /// PR mais recente para o mesmo exercício?
    func isImprovement(over previousBest: PersonalRecord?) -> Bool {
        guard let previousBest else { return true }
        guard prName.caseInsensitiveCompare(previousBest.prName) == .orderedSame else { return false }
        switch group {
        case .barbell:
            return poundValue > previousBest.poundValue
        case .gymnastic:
            return maxReps > previousBest.maxReps
        case .endurance:
            return distance > previousBest.distance
        }
    }
}

extension PersonalRecord: Comparable {
    public static func < (lhs: PersonalRecord, rhs: PersonalRecord) -> Bool {
        lhs.recordDate < rhs.recordDate
    }
}
