//
//  RootView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI

struct RootView: View {
    @StateObject var lnManager = LocalNotificationManager()
    @Environment(\.storeKitManager) var storeManager
    
    @SceneStorage("selectedTab")
    private var selectedTab = 0
    @State var showNewPRView = false
    @State var selectCategoryItemInitialize: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                VStack {
                    MyRecordsView(searchText: .constant(""))
                        .environmentObject(RecordDetailViewModel())
                        .environmentObject(SettingsStore())
                }
            }
            .tabItem {
                Image(systemName: "trophy.circle.fill")
                Text(LocalizedStringKey("tabbar.myrecords.title"))
            }
            .tag(0)
            
            
            NavigationView {
                VStack {
                    CategoryListView(selectedCategoryItem: $selectCategoryItemInitialize)
                        .environmentObject(CategoryStore())
                }
            }
            .tabItem {
                Image(systemName: "square.grid.3x3")
                Text(LocalizedStringKey("tabbar.categories.title"))
            }
            .tag(1)
            
            
            NavigationView {
                VStack{
                    InsightsView()
                        .navigationTitle(LocalizedStringKey("screen.insights.title"))
                        .environment(\.storeKitManager, storeManager)
                        .environmentObject(InsightsViewModel(storeKitService: storeManager))
                        .environmentObject(SettingsStore())
                }
                    
            }
            .tabItem {
                Image(systemName: "chart.xyaxis.line")
                Text(LocalizedStringKey("tabbar.insights.title"))
            }
            .tag(2)
            
            
            NavigationView {
                SettingsView()
                    .navigationTitle(LocalizedStringKey("screen.settings.title"))
                    .environmentObject(SettingsStore())
                    .environmentObject(lnManager)
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
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
