import SwiftUI
import Application
import Categories
import PRHistory
import Insights
import Settings
import Localization
import WatchCompanion

/// Tab shell principal — onboarding/rede ficam no LaunchView.
struct MainTabView: View {
    @SceneStorage("selectedTab") private var selectedTab = 0

    var body: some View {
        ZStack {
            if UITestLaunchSupport.shouldShowWatchScreenshotGallery {
                WatchPOCGalleryView()
            } else {
                mainTabs
            }
        }
    }

    private var mainTabs: some View {
        TabView(selection: $selectedTab) {
            CategoryListView()
                .accessibilityIdentifier("tab.categories")
                .tabItem {
                    Label(Strings.Tab.categories, systemImage: AppDesign.Icon.tabCategories)
                }
                .tag(0)

            PRHistoriesListView()
                .accessibilityIdentifier("tab.records")
                .tabItem {
                    Label(Strings.Tab.records, systemImage: AppDesign.Icon.tabRecords)
                }
                .tag(1)

            WorkoutInsightsView()
                .accessibilityIdentifier("tab.insights")
                .tabItem {
                    Label(Strings.Tab.insights, systemImage: AppDesign.Icon.tabInsights)
                }
                .tag(2)

            NavigationStack {
                SettingsView()
            }
            .accessibilityIdentifier("tab.settings")
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
