//
//  SettingsView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        NavigationView {
            Form {  
                Section(header: Text("Notifications settings")) {
                    Toggle(isOn: $settings.isNotificationEnabled) {
                        Text("Notification:")
                    }
                }

                Section(header: Text("Crossfit tracking settings")) {
                    Toggle(isOn: $settings.isSleepTrackingEnabled) {
                        Text("Sleep tracking:")
                    }

                    Picker(
                        selection: $settings.sleepTrackingMode,
                        label: Text("Sleep tracking mode")
                    ) {
                        ForEach(SettingsStore.SleepTrackingMode.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }

                    Stepper(value: $settings.sleepGoal, in: 0...24) {
                        Text("Training target is \(settings.sleepGoal)  ")
                    }
                }

                if !settings.isPro {
                    Section {
                        Button(action: {
                            self.settings.unlockPro()
                        }) {
                            Text("Unlock PRO")
                        }

                        Button(action: {
                            self.settings.restorePurchase()
                        }) {
                            Text("Restore purchase")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
