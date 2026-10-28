import SwiftUI

/// Dica contextual na sessão (CPR-009).
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
