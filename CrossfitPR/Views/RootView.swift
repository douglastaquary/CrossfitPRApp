//
//  RootView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI

struct RootView: View {
    @SceneStorage("selectedTab")
    private var selectedTab = 0
    
    @StateObject var localNotificationManager = LocalNotificationManager()
    @Environment(\.storeKitManager) var storeManager
    @Environment(\.dismiss) var dismiss
    
    @State var showNewPRView = false
    @State var selectCategoryItemInitialize: Int = 0
    @State var accountStatusAlertShown = false
    let appDefaults: UserDefaults

    init(defaults: UserDefaults) {
        self.appDefaults = defaults
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                VStack {
                    CategoryListView()
                        .environmentObject(CategoryStore())
                }
            }
            .tabItem {
                Image(systemName: "square.grid.3x3")
                Text(LocalizedStringKey("tabbar.categories.title"))
            }
            .tag(0)
            NavigationView {
                VStack {
                    MyRecordsView(appDefaults: appDefaults)
                        .environmentObject(RecordDetailViewModel())
                        .environmentObject(SettingsStore(defaults: self.appDefaults))
                }
            }
            .tabItem {
                Image(systemName: "trophy.circle.fill")
                Text(LocalizedStringKey("tabbar.myrecords.title"))
            }
            .tag(1)

            NavigationView {
                VStack{
                    InsightsView()
                        .navigationTitle(LocalizedStringKey("screen.insights.title"))
                        .environment(\.storeKitManager, storeManager)
                        .environmentObject(InsightsViewModel(defaults: appDefaults, storeKitService: storeManager))
                        .environmentObject(SettingsStore(defaults: appDefaults))
                }
                    
            }
            .tabItem {
                Image(systemName: "chart.xyaxis.line")
                Text(LocalizedStringKey("tabbar.insights.title"))
            }
            .tag(2)
            
            NavigationView {
                SettingsView(appDefaults: self.appDefaults)
                    .navigationTitle(LocalizedStringKey("screen.settings.title"))
                    .environmentObject(SettingsStore(defaults: appDefaults))
                    .environmentObject(localNotificationManager)
                    .environment(\.storeKitManager, storeManager)
            }
            .tabItem {
                Image(systemName: "gear")
                Text(LocalizedStringKey("tabbar.settings.title"))
            }
            .tag(3)
            
        }
        .accentColor(.green)
        .onChange(of: selectedTab) { newValue in
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        .onAppear {
            performSetupStatus()
        }
        .alert(isPresented: $accountStatusAlertShown) {
            Alert(
                title: Text("onboarding.alert.icloud.account.title"),
                message: Text("onboarding.alert.icloud.account.message"),
                dismissButton: .default(Text("onboarding.alert.cancel.button.title")) {
                    dismiss()
                }
            )
        }
    }
    
}

extension RootView {
    func performSetupStatus() {
        self.appDefaults.set(true, forKey: SettingStoreKeys.pro)

//        Task {
//            //_ = try await storeManager.updatePurchases()
//            if storeManager.transactionState == .purchased {
//                self.appDefaults.set(true, forKey: SettingStoreKeys.pro)
//            } else {
//                self.appDefaults.set(false, forKey: SettingStoreKeys.pro)
//            }
//            throw RequestError.fail(message: "[LOG] purchase(), Unexpected result")
//        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(defaults: UserDefaults.standard)
    }
}
