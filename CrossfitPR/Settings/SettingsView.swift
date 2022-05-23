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
        Form {
            Section(header: Text("Notifications settings")) {
                Toggle(isOn: $settings.isNotificationEnabled) {
                    Text("Notification:")
                }
            }
            
            Section(header: Text("Crossfit tracking settings")) {
                Picker(
                    selection: $settings.measureTrackingMode,
                    label: Text("Measure tracking mode")
                ) {
                    ForEach(SettingsStore.MeasureTrackingMode.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                
                Stepper(value: $settings.trainningTargetGoal, in: 0...24) {
                    Text("Training target is \(settings.trainningTargetGoal):00")
                }
            }
            
            if !settings.isPro {
                Section {
                    Button(action: {
                        self.settings.unlockPro()
                    }) {
                        Text("Unlock PRO")
                    }
                }
            } else {
                Button(action: {
                    self.settings.restorePurchase()
                }) {
                    Text("Restore purchase")
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
