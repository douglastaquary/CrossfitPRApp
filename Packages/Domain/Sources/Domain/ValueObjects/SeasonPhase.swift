import Foundation

/// Fase da temporada do atleta Elite (CPR-015) — sem programming diário.
public enum SeasonPhase: String, Sendable, Codable, CaseIterable, Identifiable {
    case offSeason
    case build
    case open
    case peaking
    case deload

    public var id: String { rawValue }

    public var localizationKey: String {
        "season.phase.\(rawValue)"
    }
}
