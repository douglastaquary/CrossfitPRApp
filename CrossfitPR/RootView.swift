import SwiftUI
import Application
import Categories
import PRHistory
import Insights
import Settings
import Localization

/// Tab shell principal — onboarding/rede ficam no LaunchView.
struct MainTabView: View {
    @SceneStorage("selectedTab") private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoryListView()
                .tabItem {
                    Label(Strings.Tab.categories, systemImage: AppDesign.Icon.tabCategories)
                }
                .tag(0)

            PRHistoriesListView()
                .tabItem {
                    Label(Strings.Tab.records, systemImage: AppDesign.Icon.tabRecords)
                }
                .tag(1)

            WorkoutInsightsView()
                .tabItem {
                    Label(Strings.Tab.insights, systemImage: AppDesign.Icon.tabInsights)
                }
                .tag(2)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(Strings.Tab.settings, systemImage: AppDesign.Icon.tabSettings)
            }
            .tag(3)
        }
        .accentColor(AppDesign.Colors.brand)
        .onChange(of: selectedTab) { _ in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToCategories)) { _ in
            selectedTab = 0
        }
    }
}

extension Notification.Name {
    static let navigateToCategories = Notification.Name("navigateToCategories")
}
