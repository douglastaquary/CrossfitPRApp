import SwiftUI

/// Shell CPR-009/016 — sessão timer, % load, descanso e cool-down (sem LLM).
public struct WatchCompanionRootView: View {
    @State private var selectedTab: Int

    public init() {
        _selectedTab = State(initialValue: WatchCompanionLaunchConfig.initialTab)
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            WatchWODTimerView()
                .tag(0)
                .tabItem {
                    Label(WatchL10n.sessionTitle, systemImage: "flame.fill")
                }
                .accessibilityIdentifier("watch.tab.session")

            WatchPercentLoadView()
                .tag(1)
                .tabItem {
                    Label(WatchL10n.loadTitle, systemImage: "percent")
                }
                .accessibilityIdentifier("watch.tab.load")

            WatchRestTimerView()
                .tag(2)
                .tabItem {
                    Label(WatchL10n.restLabel, systemImage: "timer")
                }
                .accessibilityIdentifier("watch.tab.rest")

            WatchBreathingView()
                .tag(3)
                .tabItem {
                    Label(WatchL10n.breathTitle, systemImage: "wind")
                }
                .accessibilityIdentifier("watch.tab.breath")
        }
        .tint(WatchDesign.brand)
        .accessibilityIdentifier("watch.companion.root")
    }
}
