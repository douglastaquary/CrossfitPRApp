import Foundation

/// Contexto estilo Fitness anexado a um PR (CPR-013) — opcional / seedável.
public struct PRSessionContext: Hashable, Sendable, Codable {
    public var locationName: String?
    public var activeCalories: Double?
    public var totalCalories: Double?
    public var exerciseTime: TimeInterval?
    public var duration: TimeInterval?
    public var averageHeartRate: Int?
    public var temperatureCelsius: Double?
    public var humidityPercent: Double?
    public var source: PRRecordSource
    public var startedAt: Date?
    public var endedAt: Date?

    public init(
        locationName: String? = nil,
        activeCalories: Double? = nil,
        totalCalories: Double? = nil,
        exerciseTime: TimeInterval? = nil,
        duration: TimeInterval? = nil,
        averageHeartRate: Int? = nil,
        temperatureCelsius: Double? = nil,
        humidityPercent: Double? = nil,
        source: PRRecordSource = .manual,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) {
        self.locationName = locationName
        self.activeCalories = activeCalories
        self.totalCalories = totalCalories
        self.exerciseTime = exerciseTime
        self.duration = duration
        self.averageHeartRate = averageHeartRate
        self.temperatureCelsius = temperatureCelsius
        self.humidityPercent = humidityPercent
        self.source = source
        self.startedAt = startedAt
        self.endedAt = endedAt
    }

    public static func mockWatchBox(at date: Date = Date()) -> PRSessionContext {
        let start = Calendar.current.date(bySettingHour: 18, minute: 5, second: 0, of: date) ?? date
        return PRSessionContext(
            locationName: "Bertioga - SP",
            activeCalories: 317,
            totalCalories: 375,
            exerciseTime: 36 * 60 + 14,
            duration: 52 * 60 + 17,
            averageHeartRate: 145,
            temperatureCelsius: 25,
            humidityPercent: 82,
            source: .appleWatch,
            startedAt: start,
            endedAt: start.addingTimeInterval(52 * 60 + 17)
        )
    }
}

public enum PRRecordSource: String, Hashable, Sendable, Codable {
    case manual
    case appleWatch
    case health

    public var displaySymbol: String {
        switch self {
        case .manual: return "hand.tap"
        case .appleWatch: return "applewatch"
        case .health: return "heart.fill"
        }
    }
}
