import SwiftUI

@main
struct CrossfitPRWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchCompanionRootView()
                .onAppear { WatchLinkBootstrap.activate() }
        }
    }
}
