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

            Image("216")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
        }
        .onChange(of: launchScreenState.state) { newState in
            switch newState {
            case .firstStep:
                // Pulse inicial
                withAnimation(.easeInOut(duration: 0.4)) {
                    logoScale = 1.1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        logoScale = 1.0
                    }
                }
            case .secondStep:
                // Explosão estilo X — escala grande + fade out
                withAnimation(.easeIn(duration: 0.25)) {
                    logoScale = 15.0
                    logoOpacity = 0.0
                }
            case .finished:
                break
            }
        }
    }
}
