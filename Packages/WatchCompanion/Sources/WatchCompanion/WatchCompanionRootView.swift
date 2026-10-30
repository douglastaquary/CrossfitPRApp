import SwiftUI

/// Shell CPR-009 Design — sessão, descanso e respiração (sem LLM no device).
public struct WatchCompanionRootView: View {
    @State private var selectedTab: Int

    public init() {
        _selectedTab = State(initialValue: WatchCompanionLaunchConfig.initialTab)
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            WatchSessionTipView()
                .tag(0)
                .tabItem {
                    Label(WatchL10n.sessionTitle, systemImage: "figure.strengthtraining.traditional")
                }
                .accessibilityIdentifier("watch.tab.session")

            WatchRestTimerView()
                .tag(1)
                .tabItem {
                    Label(WatchL10n.restLabel, systemImage: "timer")
                }
                .accessibilityIdentifier("watch.tab.rest")

            WatchBreathingView()
                .tag(2)
                .tabItem {
                    Label(WatchL10n.breathTitle, systemImage: "wind")
                }
                .accessibilityIdentifier("watch.tab.breath")
        }
        .tint(WatchDesign.brand)
        .accessibilityIdentifier("watch.companion.root")
    }
}
