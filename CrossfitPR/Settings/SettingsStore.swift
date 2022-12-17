//
//  SettingsStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI
import Combine
import UserNotifications
import StoreKit


enum SettingStoreKeys {
    static let pro = "is_pro"
    static let trainingTargetGoal = "training_target_goal"
    static let notificationEnabled = "notifications_enabled"
    static let sleepTrackingEnabled = "sleep_tracking_enabled"
    static let measureTrackingMode = "measure_tracking_mode"
    static let enabledSortedByValue = "enabled_sorted_by_value"
}

enum MeasureTrackingMode: String, CaseIterable {
    case pounds = "settings.pounds.title"
    case kilos = "settings.kilo.title"
}

@MainActor
final class SettingsStore: ObservableObject {

    @Published var storeKitManager: StoreKitManager
    @Published private(set) var state = UserPurchaseState.loading
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    var anyCancellable: AnyCancellable? = nil
    let objectWillChange = PassthroughSubject<Void, Never>()

    init(storeKitManager: StoreKitManager =  StoreKitManager(), defaults: UserDefaults = .standard) {
        self.storeKitManager = storeKitManager
        self.defaults = defaults
//
//        self.defaults.register(defaults: [
//            SettingStoreKeys.trainingTargetGoal: 8,
//            SettingStoreKeys.sleepTrackingEnabled: true,
//            SettingStoreKeys.measureTrackingMode: MeasureTrackingMode.pounds.rawValue
//        ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)

        Task {
            await updatePurchases()
        }
    }

    var isNotificationEnabled: Bool {
        set {
            defaults.set(newValue, forKey: SettingStoreKeys.notificationEnabled)
        }
        get { defaults.bool(forKey: SettingStoreKeys.notificationEnabled) }
    }
    
    @Published var isPro: Bool = false

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
    func updatePurchases() async {
        Task {
            do {
                let transaction = try await storeKitManager.updatePurchases()
                if try await transaction.value.ownershipType == .purchased {
                    DispatchQueue.main.async {
                        self.isPro = true
                        self.state = .unlockPro
                    }
                }
            } catch {
                self.isPro = false
                throw RequestError.fail(message: "[LOG] SettingsStore.updatePurchases(), Error: \(error)")
            }
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
    
    func lockPro() {
        // You can do you in-app purchase restore here
        isPro = false
    }
}


