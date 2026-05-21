import SwiftUI
import Domain
import Application

/// Splash animado com asset `216` (beta baseline).
public struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var firstAnimation = false
    @State private var secondAnimation = false
    @State private var startFadeoutAnimation = false

    private let animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    public init() {}

    public var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea()
            Image("216")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .rotationEffect(firstAnimation ? .degrees(900) : .degrees(1800))
                .scaleEffect(secondAnimation ? 0 : 1)
                .offset(y: secondAnimation ? 400 : 0)
        }
        .onReceive(animationTimer) { _ in updateAnimation() }
        .opacity(startFadeoutAnimation ? 0 : 1)
    }

    private func updateAnimation() {
        switch launchScreenState.state {
        case .firstStep:
            withAnimation(.easeInOut(duration: 0.9)) {
                firstAnimation.toggle()
            }
        case .secondStep:
            if !secondAnimation {
                withAnimation(.linear) {
                    secondAnimation = true
                    startFadeoutAnimation = true
                }
            }
        case .finished:
            break
        }
    }
}
