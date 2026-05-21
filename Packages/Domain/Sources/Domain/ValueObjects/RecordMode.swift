import Foundation

/// Modo de registro do PR (peso, repetições ou distância).
public enum RecordMode: String, Codable, Sendable, Hashable {
    case maxWeight
    case maxRepetition
    case maxDistance

    public var index: Int {
        switch self {
        case .maxWeight: return 0
        case .maxRepetition: return 1
        case .maxDistance: return 2
        }
    }
}
