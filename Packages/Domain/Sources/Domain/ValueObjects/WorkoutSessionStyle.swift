import Foundation

/// Estilo de WOD/metcon — CPR-012.
public enum WorkoutSessionStyle: String, CaseIterable, Sendable, Codable, Hashable {
    case amrap
    case emom
    case forTime
    case custom
}
