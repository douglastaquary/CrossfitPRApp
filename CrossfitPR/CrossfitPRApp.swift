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
    private let storeKitService: StoreKitManager = StoreKitManager()

    var body: some Scene {
        WindowGroup {
            LaunchView(
                storeKitManager: storeKitService,
                appDefaults: UserDefaults.standard
            )
            .environmentObject(ViewLaunch())
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("🟢 [App State] App in foreground.\n")
            case .inactive:
                print("🟢 [App State] App inactive. Saving data.\n")
                dataManager.saveData()
            case .background:
                print("🟢 [App State] App in background.\n")
                dataManager.saveData()
            default:
                print("🔶 [App State] App unknown state..\n")
            }
        }
    }
}

