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
                }
                
            }
            .tabItem {
                Image(systemName: "heart")
                Text("today")
            }
            .tag(0)
            
            NavigationView {
                InsightsView()
                    .navigationTitle("Insights")
                    .environmentObject(InsightsStore())
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("insights")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
                    .navigationTitle("Settings")
                    .environmentObject(SettingsStore())
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
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
