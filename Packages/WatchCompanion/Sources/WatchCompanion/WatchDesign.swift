import SwiftUI

/// Tokens visuais do companion watchOS (CPR-009 Design).
/// Espelha a intenção de `AppDesign` no iPhone sem depender do pacote Localization.
enum WatchDesign {
    /// Verde claro (watch é dark-first) — alinhado ao `brand` dark do iPhone.
    static let brand = Color(red: 0.63, green: 0.94, blue: 0.0)

    /// Label secundário (caption hierarchy).
    static let secondaryLabel = Color.secondary

    static let timerFont = Font.system(size: 34, weight: .bold, design: .rounded)
    static let phaseFont = Font.title3.monospacedDigit().weight(.semibold)
    static let sectionLabel = Font.caption.weight(.semibold)
    static let bodyTip = Font.caption
    static let micro = Font.caption2

    static let ringLineWidth: CGFloat = 5
    static let breathRingSize: CGFloat = 78
    static let restRingSize: CGFloat = 96
}

enum WatchL10n {
    static var sessionTitle: String { tr("watch.session.title") }
    static var sessionTip: String { tr("watch.session.tip") }
    static var restLabel: String { tr("watch.rest.label") }
    static var restMotivation: String { tr("watch.rest.motivation") }
    static var breathTitle: String { tr("watch.breath.title") }
    static var breathPattern: String { tr("watch.breath.pattern") }
    static var breathInhale: String { tr("watch.breath.inhale") }
    static var breathExhale: String { tr("watch.breath.exhale") }
    static var breathHapticsToggle: String { tr("watch.breath.haptics") }
    static var restStart: String { tr("watch.rest.start") }
    static var restPause: String { tr("watch.rest.pause") }

    private static func tr(_ key: String) -> String {
        #if SWIFT_PACKAGE
        return NSLocalizedString(key, bundle: .module, comment: "")
        #else
        return NSLocalizedString(key, comment: "")
        #endif
    }
}
