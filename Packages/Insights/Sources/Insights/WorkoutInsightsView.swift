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
            WorkoutInsightsTierContent(
                isPro: subscriptionClient.currentTier.isPaid,
                isPresentingPROUpgrade: $isPresentingPROUpgrade
            )
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

    private func loadRecordsIfNeeded() async {
        guard personalRecordClient.records.isEmpty else { return }
        await personalRecordClient.fetchRecords()
    }
}

private struct WorkoutInsightsTierContent: View {
    let isPro: Bool
    @Binding var isPresentingPROUpgrade: Bool

    var body: some View {
        if isPro {
            InsightsViewPRO()
        } else {
            InsightsTeaserView(isPresentingPROUpgrade: $isPresentingPROUpgrade)
        }
    }
}
