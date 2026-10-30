import Foundation

/// Variantes de layout do sheet de planos (CPR-014) — A/B/C para homologação de conversão.
public enum PROUpgradeLayoutVariant: String, CaseIterable, Sendable {
    case a
    case b
    case c

    public static var current: PROUpgradeLayoutVariant {
        let env = ProcessInfo.processInfo.environment["UITEST_PAYWALL_VARIANT"]
        let defaults = UserDefaults.standard.string(forKey: "UITEST_PAYWALL_VARIANT")
        let raw = (env ?? defaults)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        if let raw, let value = PROUpgradeLayoutVariant(rawValue: raw) {
            return value
        }
        // Produção: variante B (passos — CPR-014 escolha de conversão).
        return .b
    }
}
