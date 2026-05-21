import Foundation

/// Nível CrossFit do PR (Beginner, Scale, Rx).
public enum CrossfitLevel: String, Codable, Sendable, CaseIterable, Hashable {
    case beginner = "Beginner"
    case scale = "Scale"
    case rx = "Rx"
}
