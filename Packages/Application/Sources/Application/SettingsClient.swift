import Foundation
import Combine
import Domain

/// Preferências do app — unidade de medida, notificações (Application layer).
@MainActor
public final class SettingsClient: ObservableObject {
    private enum Keys {
        static let measureTrackingMode = "measureTrackingMode"
        static let isNotificationEnabled = "isNotificationEnabled"
        static let launchBefore = "LaunchBefore"
    }

    private let defaults: UserDefaults

    @Published public var measureTrackingMode: MeasureTrackingMode {
        didSet { defaults.set(measureTrackingMode.rawValue, forKey: Keys.measureTrackingMode) }
    }

    @Published public var isNotificationEnabled: Bool {
        didSet { defaults.set(isNotificationEnabled, forKey: Keys.isNotificationEnabled) }
    }

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let storedMeasure = defaults.string(forKey: Keys.measureTrackingMode)
            .flatMap { MeasureTrackingMode(rawValue: $0) } ?? .pounds
        measureTrackingMode = storedMeasure
        isNotificationEnabled = defaults.bool(forKey: Keys.isNotificationEnabled)
    }

    public var hasCompletedLaunch: Bool {
        get { defaults.bool(forKey: Keys.launchBefore) }
        set { defaults.set(newValue, forKey: Keys.launchBefore) }
    }
}
