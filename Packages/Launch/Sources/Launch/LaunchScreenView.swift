import SwiftUI
import Domain
import Application
import Localization

/// Splash animado estilo X/Twitter — logo escala e desaparece.
public struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var logoScale: CGFloat = 1.0
    @State private var logoOpacity: Double = 1.0

    public init() {}

    public var body: some View {
        ZStack {
            AppDesign.Colors.brand
                .ignoresSafeArea()

            LaunchScreenLogo(scale: logoScale, opacity: logoOpacity)
        }
        .onChange(of: launchScreenState.state) { newState in
            applyLaunchAnimation(for: newState)
        }
    }

    private func applyLaunchAnimation(for state: LaunchScreenStep) {
        switch state {
        case .firstStep:
            withAnimation(.easeInOut(duration: 0.4)) {
                logoScale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    logoScale = 1.0
                }
            }
        case .secondStep:
            withAnimation(.easeIn(duration: 0.25)) {
                logoScale = 15.0
                logoOpacity = 0.0
            }
        case .finished:
            break
        }
    }
}

private struct LaunchScreenLogo: View {
    let scale: CGFloat
    let opacity: Double

    var body: some View {
        Image("216")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .scaleEffect(scale)
            .opacity(opacity)
    }
}
