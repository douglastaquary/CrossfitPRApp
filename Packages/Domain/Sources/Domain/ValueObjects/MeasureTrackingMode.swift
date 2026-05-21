import Foundation

/// Unidade de medida preferida pelo atleta.
public enum MeasureTrackingMode: String, Codable, Sendable, CaseIterable, Hashable {
    case pounds = "settings.screen.section.tracking.measure.pounds"
    case kilograms = "settings.screen.section.tracking.measure.kilograms"

    // MARK: - Conversion factors

    /// Fator de conversão: 1 lb = 0.453592 kg
    public static let poundsToKilograms: Double = 0.453592
    public static let kilogramsToPounds: Double = 1.0 / 0.453592

    // MARK: - Conversion helpers

    /// Converte libras para quilos.
    public static func toKilograms(pounds: Double) -> Double {
        pounds * poundsToKilograms
    }

    /// Converte quilos para libras.
    public static func toPounds(kilograms: Double) -> Double {
        kilograms * kilogramsToPounds
    }

    /// Converte valor de libras para a unidade atual.
    public func convert(fromPounds pounds: Int) -> Int {
        switch self {
        case .pounds:
            return pounds
        case .kilograms:
            return Int(Double(pounds) * Self.poundsToKilograms)
        }
    }

    /// Converte valor de quilos para a unidade atual.
    public func convert(fromKilograms kilograms: Int) -> Int {
        switch self {
        case .pounds:
            return Int(Double(kilograms) * Self.kilogramsToPounds)
        case .kilograms:
            return kilograms
        }
    }

    // MARK: - Formatting

    /// Sufixo da unidade (ex: "lb" ou "kg").
    public var suffix: String {
        switch self {
        case .pounds: return "lb"
        case .kilograms: return "kg"
        }
    }

    /// Formata um valor de peso com sufixo (ex: "100 lb" ou "45 kg").
    public func format(pounds: Int) -> String {
        "\(convert(fromPounds: pounds)) \(suffix)"
    }

    /// Formata um valor de peso a partir de quilos (ex: "100 lb" ou "45 kg").
    public func format(kilograms: Int) -> String {
        "\(convert(fromKilograms: kilograms)) \(suffix)"
    }

    /// Retorna o valor correto de um PersonalRecord baseado na unidade.
    public func weightValue(poundValue: Int, kiloValue: Int) -> Int {
        switch self {
        case .pounds: return poundValue
        case .kilograms: return kiloValue
        }
    }

    /// Formata o peso de um record com sufixo.
    public func formatWeight(poundValue: Int, kiloValue: Int) -> String {
        "\(weightValue(poundValue: poundValue, kiloValue: kiloValue)) \(suffix)"
    }
}
