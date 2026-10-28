import SwiftUI

/// Shell CPR-009 no relógio — sessão, descanso e respiração (sem LLM no device).
public struct WatchCompanionRootView: View {
    public init() {}

    public var body: some View {
        TabView {
            WatchSessionTipView()
                .tabItem {
                    Label(WatchL10n.sessionTitle, systemImage: "figure.strengthtraining.traditional")
                }
                .accessibilityIdentifier("watch.tab.session")

            WatchRestTimerView()
                .tabItem {
                    Label(WatchL10n.restLabel, systemImage: "timer")
                }
                .accessibilityIdentifier("watch.tab.rest")

            WatchBreathingView()
                .tabItem {
                    Label(WatchL10n.breathTitle, systemImage: "wind")
                }
                .accessibilityIdentifier("watch.tab.breath")
        }
        .accessibilityIdentifier("watch.companion.root")
    }
}
