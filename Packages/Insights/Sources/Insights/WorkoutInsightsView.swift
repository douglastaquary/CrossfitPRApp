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
                    freeTeaserContent
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
        }
        .brandTint()
    }

    private var freeTeaserContent: some View {
        VStack {
            Button { isPresentingPROUpgrade = true } label: {
                CardGroupView(
                    cardTitle: "insight.view.card.pro.title",
                    cardDescription: "insight.view.card.pro.description",
                    buttonTitle: "insight.view.card.unlockprobutton.title",
                    iconSystemName: "chart.bar.fill"
                )
            }
            Spacer()
        }
        .padding(22)
        .sheet(isPresented: $isPresentingPROUpgrade) {
            PROUpgradeView()
        }
    }
}
