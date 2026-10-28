import SwiftUI

enum WatchDesign {
    static let brand = Color.green
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
