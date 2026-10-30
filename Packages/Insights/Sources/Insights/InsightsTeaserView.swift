import SwiftUI
import Domain
import Application
import SharedUI
import Localization

struct InsightsTeaserView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @Binding var isPresentingPROUpgrade: Bool

    private var hasRecords: Bool {
        !personalRecordClient.records.isEmpty
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                if hasRecords {
                    InsightsSummarySection(
                        records: personalRecordClient.records,
                        measureMode: settingsClient.measureTrackingMode
                    )
                    InsightsEngineCardsSection()
                    InsightsFreeChartTeaser(
                        records: personalRecordClient.records,
                        measureMode: settingsClient.measureTrackingMode
                    )
                    InsightsLastSessionSection()
                } else {
                    InsightsTeaserEmptySection()
                    InsightsFreeChartTeaser(
                        records: [],
                        measureMode: settingsClient.measureTrackingMode
                    )
                }

                InsightsLockedUpsellSection(isPresentingPROUpgrade: $isPresentingPROUpgrade)
            }
            .padding(AppDesign.Layout.horizontalPadding)
        }
        .background(AppDesign.Colors.background.ignoresSafeArea())
    }
}

extension Notification.Name {
    static let navigateToCategories = Notification.Name("navigateToCategories")
}
