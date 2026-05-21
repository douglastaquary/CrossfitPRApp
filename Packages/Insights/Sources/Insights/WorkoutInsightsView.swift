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
            Group {
                if subscriptionClient.currentTier == .pro {
                    InsightsViewPRO()
                } else {
                    InsightsTeaserView(isPresentingPROUpgrade: $isPresentingPROUpgrade)
                }
            }
            .navigationTitle(Strings.Screen.insights)
            .navigationBarTitleDisplayMode(.large)
            .task(id: personalRecordClient.records.count) {
                if personalRecordClient.records.isEmpty {
                    await personalRecordClient.fetchRecords()
                }
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
}
