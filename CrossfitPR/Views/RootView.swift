//
//  RootView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI

struct RootView: View {
    @StateObject var lnManager = LocalNotificationManager()
    private let cloudKitService = CloudKitService()
    @EnvironmentObject var settings: InsightsStore
    
    @SceneStorage("selectedTab")
    private var selectedTab = 0
    
    @State var showNewPRView = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                VStack {
                    CategoryListView()
                        .environmentObject(CategoryStore())
                        .user(settings.isPro)
                        //.environment(\.isPro, settings.isPro)
                }
            }
            .tabItem {
                Image(systemName: "rosette")
                Text(LocalizedStringKey("tabbar.records.title"))
            }
            .tag(0)
            
            NavigationView {
                VStack{
                    InsightsView()
                        .navigationTitle(LocalizedStringKey("screen.insights.title"))
                        .environmentObject(InsightsStore())
                        .user(settings.isPro)
                        //.environment(\.isPro, settings.isPro)
                }
                    
            }
            .tabItem {
                Image(systemName: "chart.xyaxis.line")
                Text(LocalizedStringKey("tabbar.insights.title"))
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
                    .navigationTitle(LocalizedStringKey("screen.settings.title"))
                    .environmentObject(SettingsStore())
                    .environmentObject(lnManager)
                    .user(settings.isPro)
                    //.environment(\.isPro, settings.isPro)
            }
            .tabItem {
                Image(systemName: "gear")
                Text(LocalizedStringKey("tabbar.settings.title"))
            }
            .tag(2)
        }
        .accentColor(.green)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
