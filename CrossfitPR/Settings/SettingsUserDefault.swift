//
//  SettingsUserDefault.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 09/06/22.
//

import SwiftUI
import Combine

@propertyWrapper
struct SettingsUserDefault<T> {
    let userDefaults: UserDefaults
    let key: String
    let defaultValue: T

    init(
        userDefaults: UserDefaults = UserDefaults.standard,
        key: String,
        defaultValue: T
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = userDefaults.object(forKey: key) as? T else { return self.defaultValue }
            return data
        }

        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}


enum StorageKeys: String {
   case measureTrackingMode, trainingTargetGoal
}

class UserDefaultsConfig: ObservableObject {
    static let shared = UserDefaultsConfig()
    
    @AppStorage(StorageKeys.measureTrackingMode.rawValue, store: .standard) var measureTrackingMode = MeasureTrackingMode.pounds.rawValue
    @AppStorage(StorageKeys.trainingTargetGoal.rawValue, store: .standard) var trainingTargetGoal = "08"
    @AppStorage("isPro", store: .standard) var isPro = false

    let objectWillChange = PassthroughSubject<Void, Never>()

//    @SettingsUserDefault(key: "com.taquarylab.crosfitprapp.pro", defaultValue: false)
//    var pro: Bool {
//        willSet {
//            objectWillChange.send()
//        }
//    }
//
//    @SettingsUserDefault(key: "com.taquarylab.crosfitprapp.trainingTargetGoal", defaultValue: false)
//    var trainingTargetGoal: Bool {
//        willSet {
//            objectWillChange.send()
//        }
//    }
//
    @SettingsUserDefault(key: "com.taquarylab.crosfitprapp.isNotificationEnabled", defaultValue: false)
    var isNotificationEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @SettingsUserDefault(key: "com.taquarylab.crosfitprapp.sleepTrackingEnabled", defaultValue: false)
    var sleepTrackingEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
    }
//    
//    @SettingsUserDefault(key: "com.taquarylab.crosfitprapp.measureTrackingMode", defaultValue: 0)
//    var measureTrackingMode: Int {
//        willSet {
//            objectWillChange.send()
//        }
//    }
}

extension Binding {
    init<RootType>(keyPath: ReferenceWritableKeyPath<RootType, Value>, object: RootType) {
        self.init(
            get: { object[keyPath: keyPath] },
            set: { object[keyPath: keyPath] = $0}
        )
    }
}

struct UserDefaultsConfigToggleItemView: View {
    @ObservedObject var defaultsConfig = UserDefaultsConfig.shared
    let path: ReferenceWritableKeyPath<UserDefaultsConfig, Bool>
    let name: String

    var body: some View {
        HStack {
            Toggle(isOn: Binding(keyPath: self.path, object: self.defaultsConfig)) {
                Text(LocalizedStringKey(name))
            }
            Spacer()
        }
    }
}

