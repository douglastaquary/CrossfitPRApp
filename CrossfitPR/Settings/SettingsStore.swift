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
    
    private var storeKitTaskHandle: Task<Void, Error>?

    init(storeKitManager: StoreKitManager =  StoreKitManager(), defaults: UserDefaults) {
        self.storeKitManager = storeKitManager
        self.defaults = defaults

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)

        Task {
            self.defaults.register(defaults: [
                SettingStoreKeys.trainingTargetGoal: 8,
                SettingStoreKeys.sleepTrackingEnabled: true,
                SettingStoreKeys.measureTrackingMode: MeasureTrackingMode.pounds.rawValue
            ])
            //await updatePurchases()
        }
    }
    
    var isPRO: Bool {
        set { defaults.set(newValue, forKey: SettingStoreKeys.pro) }
        get { defaults.bool(forKey: SettingStoreKeys.pro) }
    }

    var isNotificationEnabled: Bool {
        set {
            defaults.set(newValue, forKey: SettingStoreKeys.notificationEnabled)
        }
        get { defaults.bool(forKey: SettingStoreKeys.notificationEnabled) }
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
    
    // Call this early in the app's lifecycle.
    func startStoreKitListener() {
        storeKitTaskHandle = StoreKitManager.listenForStoreKitUpdates()
    }
}

extension SettingsStore {
    func updatePurchases() async {
        Task {
            do {
                let transaction = try await storeKitManager.updatePurchases()
                if try await transaction.value.ownershipType == .purchased {
                    DispatchQueue.main.async {
                        self.state = .unlockPro
                    }
                }
            } catch {
                self.state = .blockPro
                throw RequestError.fail(message: "[LOG] Error: \(error)")
            }
        }
    }
}

extension SettingsStore {
    func unlockPro() {
        // You can do your in-app transactions here
       isPRO = true
    }

    func lockPro() {
        // You can do you in-app purchase restore here
        isPRO = false
    }
}


