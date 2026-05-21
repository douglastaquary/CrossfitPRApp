import Foundation

/// Grupo de exercício CrossFit (barbell, gymnastic, endurance).
public enum RecordGroup: String, Codable, Sendable, CaseIterable, Hashable {
    case barbell = "Barbell"
    case gymnastic = "Gymnastic"
    case endurance = "Endurance"
}
