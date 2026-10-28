import SwiftUI
import Application

/// Instala clients globais e bootstrap de serviços — único ponto de wiring na hierarquia SwiftUI.
extension View {
    @MainActor
    func withCrossfitPRDependencyGraph(_ environment: AppEnvironment) -> some View {
        self
            .environmentObject(environment.subscriptionClient)
            .environmentObject(environment.personalRecordClient)
            .environmentObject(environment.workoutEngineClient)
            .environmentObject(environment.settingsClient)
            .environmentObject(environment.notificationManager)
            .environmentObject(environment.coachingClient)
            .task {
                await environment.bootstrapServices()
            }
    }
}
