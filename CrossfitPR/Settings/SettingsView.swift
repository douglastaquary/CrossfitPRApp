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
    @Environment(\.openURL) var openURL
    @Environment(\.storeKitManager) var storeKitManager
    @Environment(\.isPro) var isPRO
    @State var showPROsubsciptionView = false
    @State var showSubscriptionsSheet = false
    @State private var scheduleDate = Date()
    let appDefaults: UserDefaults
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    init(appDefaults: UserDefaults) {
        self.appDefaults = appDefaults
    }

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
                DatePicker(selection: dateProxy) {
                    Image(systemName: "calendar")
                        .font(.system(size: 18)).foregroundColor(.green)
                }
            }
            Section(header: Text("settings.screen.section.tracking.title")) {
                Picker(
                    selection: $settings.measureTrackingMode,
                    label: Text("settings.screen.section.tracking.measure.title")
                ) {
                    ForEach(MeasureTrackingMode.allCases, id: \.self) {
                        Text(LocalizedStringKey($0.rawValue)).tag($0)
                    }
                }
            }
            Section(header: Text("settings.screen.section.crossfitpro.title")) {
                if settings.isPRO {
                    Button(action: {
                        self.showSubscriptionsSheet.toggle()
                    }) {
                        Text("settings.screen.section.nocommitment.title")
                    }
                    .manageSubscriptionsSheet(isPresented: $showSubscriptionsSheet)
                    
                } else {
                    Button(action: {
                        self.showPROsubsciptionView.toggle()
                    }) {
                        Text("settings.screen.section.unlockpro.title")
                    }
                    .sheet(isPresented: $showPROsubsciptionView) {
                        Text("")
                        PurchaseView(storeKitManager: storeKitManager)
                            .environmentObject(PurchaseStore(storeKitManager: storeKitManager))
                            .environmentObject(SettingsStore(defaults: self.appDefaults))
                    }
                }
                
            }
            Section(header: Text("settings.screen.section.about.title")) {
                Button(action: {
                    openURL(URL(string: "https://www.apple.com")!)
                }) {
                    Text(LocalizedStringKey("settings.screen.section.privacy.title"))
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
        SettingsView(appDefaults: UserDefaults.standard)
    }
}
