import Foundation

/// Modelo de notificação local agendada.
public struct LocalNotification: Sendable {
    public enum ScheduleType: Sendable {
        case time
        case calendar
    }

    public var identifier: String
    public var scheduleType: ScheduleType
    public var title: String
    public var body: String
    public var subtitle: String?
    public var timeInterval: Double?
    public var dateComponents: DateComponents?
    public var repeats: Bool
    public var categoryIdentifier: String?

    public init(
        identifier: String,
        title: String,
        body: String,
        timeInterval: Double,
        repeats: Bool
    ) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }

    public init(
        identifier: String,
        title: String,
        body: String,
        dateComponents: DateComponents,
        repeats: Bool
    ) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
}
