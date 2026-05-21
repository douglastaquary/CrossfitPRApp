import Foundation

public enum PersonalRecordField: String, Sendable {
    case recordType = "PersonalRecord"
    case activity
    case date
    case pounds
    case goalDuration = "goal"
}
