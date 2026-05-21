import SwiftUI
import Application
import Launch
import Localization

@main
struct CrossfitPRApp: App {
    @StateObject private var environment: AppEnvironmentHolder

    init() {
        _environment = StateObject(wrappedValue: AppEnvironmentHolder())
    }

    var body: some Scene {
        WindowGroup {
            AppLaunchContainer {
                MainTabView()
            }
            .brandTint()
            .environmentObject(environment.value.subscriptionClient)
            .environmentObject(environment.value.personalRecordClient)
            .environmentObject(environment.value.workoutEngineClient)
            .environmentObject(environment.value.settingsClient)
            .environmentObject(environment.value.notificationManager)
            .task {
                await environment.value.bootstrapServices()
            }
        }
    }
}

@MainActor
private final class AppEnvironmentHolder: ObservableObject {
    let value: AppEnvironment

    init() {
        value = AppEnvironment.make()
    }
}
