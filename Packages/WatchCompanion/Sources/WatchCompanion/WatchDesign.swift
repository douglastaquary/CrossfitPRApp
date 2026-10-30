import Foundation
import SwiftUI

/// Presets de descanso no pulso (CPR-009 / CPR-016) — valores iguais, chaves AppStorage distintas por tab.
enum WatchRestDuration {
    static let presets: [Int] = [60, 90, 120, 180]
    static let defaultSec = 90

    static let restTabKey = "watch.rest.durationSec"
    static let wodTabKey = "watch.wod.restDurationSec"

    static func clamped(_ sec: Int) -> Int {
        let value = max(1, sec)
        if presets.contains(value) { return value }
        return presets.min(by: { abs($0 - value) < abs($1 - value) }) ?? defaultSec
    }

    static func label(seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        if s == 0 { return "\(m):00" }
        return String(format: "%d:%02d", m, s)
    }
}

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
    static var restDuration: String { tr("watch.rest.duration") }
    static var breathTitle: String { tr("watch.breath.title") }
    static var breathPattern: String { tr("watch.breath.pattern") }
    static var breathInhale: String { tr("watch.breath.inhale") }
    static var breathExhale: String { tr("watch.breath.exhale") }
    static var breathHapticsToggle: String { tr("watch.breath.haptics") }
    static var breathTapHint: String { tr("watch.breath.tapHint") }
    static var restStart: String { tr("watch.rest.start") }
    static var restPause: String { tr("watch.rest.pause") }
    static var loadTitle: String { tr("watch.load.title") }
    static var loadOneRM: String { tr("watch.load.oneRM") }
    static var loadDetailHint: String { tr("watch.load.detailHint") }
    static var wodReset: String { tr("watch.wod.reset") }
    static var wodRestLabel: String { tr("watch.wod.restLabel") }
    static var wodRestDuration: String { tr("watch.wod.restDuration") }
    static var wodRestStart: String { tr("watch.wod.restStart") }

    static func tr(_ key: String) -> String {
        #if SWIFT_PACKAGE
        return NSLocalizedString(key, bundle: .module, comment: "")
        #else
        return NSLocalizedString(key, comment: "")
        #endif
    }
}
