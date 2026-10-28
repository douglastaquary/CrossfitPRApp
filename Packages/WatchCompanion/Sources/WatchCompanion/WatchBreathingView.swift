import SwiftUI
#if os(watchOS)
import WatchKit
#endif

/// Respiração 4-4-4-4 — haptic leve opcional (CPR-009).
public struct WatchBreathingView: View {
    @AppStorage("watch.breath.hapticsEnabled") private var hapticsEnabled = true
    @State private var inhale = true
    @State private var scale: CGFloat = 0.85

    public init() {}

    public var body: some View {
        VStack(spacing: 12) {
            Toggle(WatchL10n.breathHapticsToggle, isOn: $hapticsEnabled)
                .font(.caption2)
                .accessibilityIdentifier("watch.breath.haptics")

            Text(WatchL10n.breathTitle)
                .font(.headline)
            Text(WatchL10n.breathPattern)
                .font(.title3.monospaced())
            Circle()
                .stroke(WatchDesign.brand.opacity(0.5), lineWidth: 3)
                .frame(width: 72, height: 72)
                .scaleEffect(scale)
                .overlay(
                    Text(inhale ? WatchL10n.breathInhale : WatchL10n.breathExhale)
                        .font(.caption2)
                )
                .animation(.easeInOut(duration: 4), value: scale)
        }
        .padding()
        .accessibilityIdentifier("watch.poc.breath")
        .task { await runBreathCycle() }
    }

    @MainActor
    private func runBreathCycle() async {
        while !Task.isCancelled {
            inhale = true
            scale = 1.05
            pulseHaptic(start: true)
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            inhale = false
            scale = 0.85
            pulseHaptic(start: false)
            try? await Task.sleep(nanoseconds: 4_000_000_000)
        }
    }

    private func pulseHaptic(start: Bool) {
        guard hapticsEnabled else { return }
        #if os(watchOS)
        WKInterfaceDevice.current().play(start ? .start : .click)
        #endif
    }
}
