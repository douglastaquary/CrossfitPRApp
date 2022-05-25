//
//  CrossfitPRApp.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/04/22.
//

import SwiftUI

@main
struct CrossfitPRApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ViewLaunch())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

