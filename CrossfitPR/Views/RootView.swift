//
//  RootView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 05/04/22.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @SceneStorage("selectedTab")
    private var selectedTab = 0
    
    @State var showNewPRView = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                VStack {
                    CategoryListView()
                        .environment(\.managedObjectContext, viewContext)
                        .environmentObject(CategoryStore())
                }
                
            }
            .tabItem {
                Image(systemName: "heart")
                Text(LocalizedStringKey("tabbar.today.title"))
            }
            .tag(0)
            
            NavigationView {
                VStack{
                    InsightsView()
                        .environment(\.managedObjectContext, viewContext)
                        .navigationTitle(LocalizedStringKey("screen.insights.title"))
                        .environmentObject(InsightsStore())
                }
                    
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text(LocalizedStringKey("tabbar.insights.title"))
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
                    .navigationTitle(LocalizedStringKey("screen.settings.title"))
                    .environmentObject(SettingsStore())
            }
            .tabItem {
                Image(systemName: "gear")
                Text(LocalizedStringKey("tabbar.settings.title"))
            }
            .tag(1)
        }.accentColor(.green)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
