//
//  CrossfitPRApp.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/04/22.
//

import SwiftUI

@main
struct CrossfitPRApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    var dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ViewLaunch())
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("Active")
            case .inactive:
                print("Inactive")
                dataManager.saveData()
            case .background:
                print("background")
                dataManager.saveData()
            default:
                print("unknown")
            }
        }
    }
}

