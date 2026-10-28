import SwiftUI
import Domain
import Application
import Subscription
import PROUpgrade
import SharedUI
import Localization

public struct WorkoutInsightsView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var subscriptionClient: SubscriptionClient
    @State private var isPresentingPROUpgrade = false

    public init() {}

    public var body: some View {
        NavigationStack {
            insightsContent
                .navigationTitle(Strings.Screen.insights)
                .navigationBarTitleDisplayMode(.large)
                .task(id: personalRecordClient.records.count) {
                    await loadRecordsIfNeeded()
                }
                .refreshable {
                    await personalRecordClient.fetchRecords()
                }
                .sheet(isPresented: $isPresentingPROUpgrade) {
                    PROUpgradeView()
                }
        }
        .brandTint()
    }

    @ViewBuilder
    private var insightsContent: some View {
        if subscriptionClient.currentTier == .pro {
            InsightsViewPRO()
        } else {
            InsightsTeaserView(isPresentingPROUpgrade: $isPresentingPROUpgrade)
        }
    }

    private func loadRecordsIfNeeded() async {
        guard personalRecordClient.records.isEmpty else { return }
        await personalRecordClient.fetchRecords()
    }
}
