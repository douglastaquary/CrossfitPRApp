import SwiftUI

/// Dica contextual na sessão (CPR-009 Design — tip curta, sem densidade de iPhone).
public struct WatchSessionTipView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.title2)
                .foregroundStyle(WatchDesign.brand)
                .symbolRenderingMode(.hierarchical)
            Text(WatchL10n.sessionTitle)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(WatchL10n.sessionTip)
                .font(WatchDesign.bodyTip)
                .foregroundStyle(WatchDesign.secondaryLabel)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 6)
        .accessibilityIdentifier("watch.poc.session")
    }
}
