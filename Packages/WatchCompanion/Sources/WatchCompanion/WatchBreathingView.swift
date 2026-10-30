import SwiftUI
#if os(watchOS)
import WatchKit
#endif

/// Respiração 4-4 — Design CPR-009: anel + fase; tap inicia/pausa; haptic opt-in.
public struct WatchBreathingView: View {
    @AppStorage("watch.breath.hapticsEnabled") private var hapticsEnabled = true
    @State private var inhale = true
    @State private var scale: CGFloat = 0.85
    @State private var isRunning = false
    @State private var cycleTask: Task<Void, Never>?

    public init() {}

    public var body: some View {
        VStack(spacing: 8) {
            Toggle(WatchL10n.breathHapticsToggle, isOn: $hapticsEnabled)
                .font(WatchDesign.micro)
                .tint(WatchDesign.brand)
                .accessibilityIdentifier("watch.breath.haptics")

            Text(WatchL10n.breathTitle)
                .font(WatchDesign.sectionLabel)
                .foregroundStyle(WatchDesign.secondaryLabel)

            ZStack {
                Circle()
                    .stroke(WatchDesign.brand.opacity(0.25), lineWidth: WatchDesign.ringLineWidth)
                    .frame(width: WatchDesign.breathRingSize, height: WatchDesign.breathRingSize)
                Circle()
                    .stroke(WatchDesign.brand, lineWidth: WatchDesign.ringLineWidth)
                    .frame(width: WatchDesign.breathRingSize, height: WatchDesign.breathRingSize)
                    .scaleEffect(scale)
                    .opacity(inhale ? 1 : 0.55)
                Text(inhale ? WatchL10n.breathInhale : WatchL10n.breathExhale)
                    .font(WatchDesign.phaseFont)
                    .foregroundStyle(WatchDesign.brand)
            }
            .animation(.easeInOut(duration: 4), value: scale)
            .contentShape(Circle())
            .onTapGesture { toggleCycle() }
            .accessibilityIdentifier("watch.breath.togglePhase")
            .accessibilityAddTraits(.isButton)
            .accessibilityHint(WatchL10n.breathTapHint)

            Text(isRunning ? WatchL10n.breathPattern : WatchL10n.breathTapHint)
                .font(WatchDesign.micro)
                .foregroundStyle(WatchDesign.secondaryLabel)
                .monospacedDigit()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 4)
        .accessibilityIdentifier("watch.poc.breath")
        .onDisappear { stopCycle() }
    }

    private func toggleCycle() {
        if isRunning {
            stopCycle()
        } else {
            startCycle()
        }
    }

    private func startCycle() {
        isRunning = true
        cycleTask?.cancel()
        cycleTask = Task { @MainActor in
            await runBreathCycle()
        }
    }

    private func stopCycle() {
        isRunning = false
        cycleTask?.cancel()
        cycleTask = nil
    }

    @MainActor
    private func runBreathCycle() async {
        while !Task.isCancelled {
            inhale = true
            scale = 1.08
            pulseHaptic(start: true)
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            guard !Task.isCancelled else { return }
            inhale = false
            scale = 0.82
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
