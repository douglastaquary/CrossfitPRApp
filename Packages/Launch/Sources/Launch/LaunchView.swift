import SwiftUI
import Application
import Onboarding
import SharedUI
import Localization

/// Gate de rede + roteamento onboarding/app principal (beta baseline).
public struct LaunchView<MainContent: View>: View {
    @EnvironmentObject private var settingsClient: SettingsClient
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showNetworkAlert = false
    @State private var didCompleteOnboarding = false

    private let mainContent: () -> MainContent

    public init(@ViewBuilder mainContent: @escaping () -> MainContent) {
        self.mainContent = mainContent
    }

    private var shouldShowOnboarding: Bool {
        !didCompleteOnboarding && !settingsClient.hasCompletedLaunch
    }

    public var body: some View {
        ZStack {
            if !networkMonitor.isConnected {
                offlineContent
            } else if shouldShowOnboarding {
                OnboardingView {
                    print("🟢 ONBOARDING COMPLETE CALLED!")
                    settingsClient.hasCompletedLaunch = true
                    withAnimation(.easeInOut(duration: 0.3)) {
                        didCompleteOnboarding = true
                    }
                }
                .transition(.opacity)
            } else {
                mainContent()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: shouldShowOnboarding)
        .onAppear {
            didCompleteOnboarding = settingsClient.hasCompletedLaunch
        }
        .brandTint()
    }

    private var offlineContent: some View {
        VStack {
            Text("CrossFitPR")
                .font(AppDesign.Typography.screenTitle)
                .frame(width: 300, alignment: .leading)

            HViewImageAndText(
                image: "wifi.slash",
                imageColor: AppDesign.Colors.brand,
                title: "Not connected!",
                description: "Please enable Wifi or Celular data"
            )

            Spacer()

            Button("Perform network request") {
                showNetworkAlert = true
            }
            .buttonStyle(FilledButtonStyle(fullWidth: true))
        }
        .padding()
        .alert(Strings.Launch.networkAlertTitle, isPresented: $showNetworkAlert) {
            Button(Strings.Launch.networkAlertCancel, role: .cancel) {}
        } message: {
            Text(Strings.Launch.networkAlertMessage)
        }
    }
}
