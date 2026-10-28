import SwiftUI

/// Telas CPR-009 — companion watchOS (tips, descanso, respiração).
public struct WatchSessionTipView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.title2)
                .foregroundStyle(WatchDesign.brand)
            Text(WatchL10n.sessionTitle)
                .font(.headline)
            Text(WatchL10n.sessionTip)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .accessibilityIdentifier("watch.poc.session")
    }
}

public struct WatchRestTimerView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 10) {
            Text(WatchL10n.restLabel)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text("1:30")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()
            Text(WatchL10n.restMotivation)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .accessibilityIdentifier("watch.poc.rest")
    }
}

public struct WatchBreathingView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 12) {
            Text(WatchL10n.breathTitle)
                .font(.headline)
            Text(WatchL10n.breathPattern)
                .font(.title3.monospaced())
            Circle()
                .stroke(WatchDesign.brand.opacity(0.5), lineWidth: 3)
                .frame(width: 72, height: 72)
                .overlay(
                    Text(WatchL10n.breathInhale)
                        .font(.caption2)
                )
        }
        .padding()
        .accessibilityIdentifier("watch.poc.breath")
    }
}
