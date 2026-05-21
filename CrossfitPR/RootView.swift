import SwiftUI
import PRHistory
import Insights
import Onboarding
import Localization

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView {
                hasCompletedOnboarding = true
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            PRHistoriesListView()
                .tabItem {
                    Label(Strings.Tab.prs, systemImage: AppDesign.Icon.tabPRs)
                }

            WorkoutInsightsView()
                .tabItem {
                    Label(Strings.Tab.evolution, systemImage: AppDesign.Icon.tabInsights)
                }
        }
        .brandTint()
    }
}
