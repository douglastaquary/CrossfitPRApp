import Foundation

/// Unidade de medida preferida pelo atleta.
public enum MeasureTrackingMode: String, Codable, Sendable, CaseIterable, Hashable {
    case pounds = "settings.screen.section.tracking.measure.pounds"
    case kilograms = "settings.screen.section.tracking.measure.kilograms"
}
