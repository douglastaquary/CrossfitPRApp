//
//  SettingsView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: SettingsStore
    @Environment(\.scenePhase) var scenePhase
    @State var showPROsubsciptionView = false
    @State private var scheduleDate = Date()
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    private var dateProxy:Binding<Date> {
            Binding<Date>(get: { self.scheduleDate }, set: {
                self.scheduleDate = $0
                Task{
                    await self.updateWeekAndDayFromDate()
                }
            })
        }

    var body: some View {
        Form {
            Section(header: Text("settings.screen.section.notification.title")) {
                Toggle(isOn: $settings.isNotificationEnabled) {
                    Text("settings.screen.section.notification.toggle.title")
                }
            }
            
            Section(header: Text("settings.screen.section.tracking.title")) {
                Picker(
                    selection: $settings.measureTrackingMode,
                    label: Text("settings.screen.section.tracking.measure.title")
                ) {
                    ForEach(MeasureTrackingMode.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }

                DatePicker(selection: dateProxy) {
                    Text("settings.screen.section.tracking.target.title")
                }
            }
            
            if !settings.isPro {
                Section {
                    Button(action: {
                        self.settings.unlockPro()
                    }) {
                        Text("settings.screen.section.unlockpro.title")
                    }.sheet(isPresented: $showPROsubsciptionView) {
                        PurchaseView()
                    }
                }
            }
        }
        .task {
            try? await lnManager.requestAuthorization()
        }
    }
    
    func updateWeekAndDayFromDate() async {
        if settings.isNotificationEnabled {
            self.lnManager.clearRequests()
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduleDate)
            let randomTitle = String.randomNotificationMessage(list: ["Hora de treinar! 💪🏼", "E ai?? Bora tirar o atraso?!"])
            let randomBody = String.randomNotificationMessage(list: ["Hoje o treino promete! 🏋🏻", "No pain, no gain! 😄"])
            let localNotification = LocalNotification(
                identifier: UUID().uuidString,
                title: randomTitle,
                body: randomBody,
                dateComponents: dateComponents,
                repeats: false
            )
            await lnManager.schedule(localNotification: localNotification)
        } else {
            // show alert
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
