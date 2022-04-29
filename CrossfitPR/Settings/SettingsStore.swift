//
//  SettingsStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI
import Combine

final class SettingsStore: ObservableObject {
    private enum Keys {
        static let pro = "pro"
        static let trainingTargetGoal = "training_target_goal"
        static let notificationEnabled = "notifications_enabled"
        static let sleepTrackingEnabled = "sleep_tracking_enabled"
        static let measureTrackingMode = "measure_tracking_mode"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.trainingTargetGoal: 8,
            Keys.sleepTrackingEnabled: true,
            Keys.measureTrackingMode: MeasureTrackingMode.pounds.rawValue
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    var isNotificationEnabled: Bool {
        set { defaults.set(newValue, forKey: Keys.notificationEnabled) }
        get { defaults.bool(forKey: Keys.notificationEnabled) }
    }

    var isPro: Bool {
        set { defaults.set(newValue, forKey: Keys.pro) }
        get { defaults.bool(forKey: Keys.pro) }
    }

    var isSleepTrackingEnabled: Bool {
        set { defaults.set(newValue, forKey: Keys.sleepTrackingEnabled) }
        get { defaults.bool(forKey: Keys.sleepTrackingEnabled) }
    }

    var trainningTargetGoal: Int {
        set { defaults.set(newValue, forKey: Keys.trainingTargetGoal) }
        get { defaults.integer(forKey: Keys.trainingTargetGoal) }
    }

    enum MeasureTrackingMode: String, CaseIterable {
        case pounds
        case kilos
    }

    var measureTrackingMode: MeasureTrackingMode {
        get {
            return defaults.string(forKey: Keys.measureTrackingMode)
                .flatMap { MeasureTrackingMode(rawValue: $0) } ?? .pounds
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.measureTrackingMode)
        }
    }
}

extension SettingsStore {
    func unlockPro() {
        // You can do your in-app transactions here
        isPro = true
    }

    func restorePurchase() {
        // You can do you in-app purchase restore here
        isPro = true
    }
}
