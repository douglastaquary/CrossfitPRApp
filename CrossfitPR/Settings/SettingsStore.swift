//
//  SettingsStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI
import Combine
import UserNotifications


enum SettingStoreKeys {
    static let pro = "pro"
    static let trainingTargetGoal = "training_target_goal"
    static let notificationEnabled = "notifications_enabled"
    static let sleepTrackingEnabled = "sleep_tracking_enabled"
    static let measureTrackingMode = "measure_tracking_mode"
    static let enabledSortedByValue = "enabled_sorted_by_value"
}

enum MeasureTrackingMode: String, CaseIterable {
    case pounds
    case kilos
}

final class SettingsStore: ObservableObject {

    private let cancellable: Cancellable
    private let defaults: UserDefaults
    let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        self.defaults.register(defaults: [
            SettingStoreKeys.trainingTargetGoal: 8,
            SettingStoreKeys.sleepTrackingEnabled: true,
            SettingStoreKeys.measureTrackingMode: MeasureTrackingMode.pounds.rawValue
        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    var isNotificationEnabled: Bool {
        set {
            defaults.set(newValue, forKey: SettingStoreKeys.notificationEnabled)
        }
        get { defaults.bool(forKey: SettingStoreKeys.notificationEnabled) }
    }

    var isPro: Bool {
        set { defaults.set(newValue, forKey: SettingStoreKeys.pro) }
        get { defaults.bool(forKey: SettingStoreKeys.pro) }
    }

    var isSleepTrackingEnabled: Bool {
        set { defaults.set(newValue, forKey: SettingStoreKeys.sleepTrackingEnabled) }
        get { defaults.bool(forKey: SettingStoreKeys.sleepTrackingEnabled) }
    }
    
    var trainningTargetGoal: Int {
        set { defaults.set(newValue, forKey: SettingStoreKeys.trainingTargetGoal) }
       
        get { defaults.integer(forKey: SettingStoreKeys.trainingTargetGoal)}
    }

    var measureTrackingMode: MeasureTrackingMode {
        get {
            return defaults.string(forKey: SettingStoreKeys.measureTrackingMode)
                .flatMap { MeasureTrackingMode(rawValue: $0) } ?? .pounds
        }
        set {
            UserDefaultsConfig.shared.measureTrackingMode = newValue.rawValue
            defaults.set(newValue.rawValue, forKey: SettingStoreKeys.measureTrackingMode)
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
        isPro = false
    }
}


