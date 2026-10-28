import SwiftUI
import Application
import Launch
import Localization
import WatchCompanion

@main
struct CrossfitPRApp: App {
    @StateObject private var environment: AppEnvironmentHolder

    init() {
        _environment = StateObject(wrappedValue: AppEnvironmentHolder())
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if UITestLaunchSupport.shouldShowWatchScreenshotGallery {
                    WatchPOCGalleryView()
                } else {
                    AppLaunchContainer {
                        MainTabView()
                    }
                }
            }
            .brandTint()
            .withCrossfitPRDependencyGraph(environment.value)
        }
    }
}

@MainActor
private final class AppEnvironmentHolder: ObservableObject {
    /// `App.init()` roda antes do processo receber `launchEnvironment` do XCTest; lazy adia `make()` até o body.
    lazy var value: AppEnvironment = AppEnvironment.make()
}
