import SwiftUI
import Application
import Localization

@main
struct CrossfitPRApp: App {
    @StateObject private var environment: AppEnvironmentHolder

    init() {
        _environment = StateObject(wrappedValue: AppEnvironmentHolder())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .brandTint()
                .environmentObject(environment.value.subscriptionClient)
                .environmentObject(environment.value.personalRecordClient)
                .environmentObject(environment.value.workoutEngineClient)
                .task {
                    await environment.value.bootstrapServices()
                }
        }
    }
}

/// Wrapper `ObservableObject` para injetar `AppEnvironment` via `@StateObject`.
@MainActor
private final class AppEnvironmentHolder: ObservableObject {
    let value: AppEnvironment

    init() {
        value = AppEnvironment.make()
    }
}
