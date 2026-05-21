import Foundation

/// Identificador tipado de exercício CrossFit (REASONS E — Entities).
public enum ActivityKind: String, Codable, Sendable, CaseIterable, Identifiable {
    case airSquat = "AIR SQUAT (AS)"
    case backSquat = "BACK SQUAT"
    case barMuscleUp = "BAR MUSCLE-UP"
    case benchPress = "BENCH PRESS"
    case boxJump = "BOX JUMP (BJ)"
    case burpee = "BURPEE"
    case clean = "CLEAN"
    case cleanAndJerk = "CLEAN & JERK"
    case deadlift = "DEADLIFT"
    case empty = ""

    public var id: String { rawValue }
}
