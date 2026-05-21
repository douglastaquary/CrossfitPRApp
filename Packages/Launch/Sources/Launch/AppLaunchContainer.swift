import SwiftUI
import Application
import Localization

/// Container do app — splash animado → LaunchView → conteúdo principal.
public struct AppLaunchContainer<MainContent: View>: View {
    @StateObject private var launchScreenState = LaunchScreenStateManager()
    @State private var showSplash = true

    private let mainContent: MainContent

    public init(@ViewBuilder mainContent: () -> MainContent) {
        self.mainContent = mainContent()
    }

    public var body: some View {
        ZStack {
            LaunchView {
                mainContent
            }

            if showSplash {
                LaunchScreenView()
                    .environmentObject(launchScreenState)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            launchScreenState.start()
        }
        .onChange(of: launchScreenState.state) { step in
            if step == .finished {
                withAnimation(.easeOut(duration: 0.35)) {
                    showSplash = false
                }
            }
        }
    }
}
