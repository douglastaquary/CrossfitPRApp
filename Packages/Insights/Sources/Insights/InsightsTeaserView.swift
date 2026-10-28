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

    private var recordCount: Int {
        personalRecordClient.records.count
    }

    private var topRecord: PersonalRecord? {
        personalRecordClient.records.max { $0.poundValue < $1.poundValue }
    }

    private var categoriesWithRecords: [RecordGroup] {
        let groups = Set(personalRecordClient.records.map(\.group))
        return RecordGroup.allCases.filter { groups.contains($0) }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                if hasRecords {
                    InsightsTeaserPreviewSection(
                        recordCount: recordCount,
                        topRecord: topRecord,
                        measureTrackingMode: settingsClient.measureTrackingMode
                    )
                    InsightsTeaserCategoriesSection(
                        categories: categoriesWithRecords,
                        records: personalRecordClient.records
                    )
                } else {
                    InsightsTeaserEmptySection()
                }

                InsightsTeaserCardSection()
                InsightsTeaserFeaturesSection()
                InsightsTeaserCTASection(isPresentingPROUpgrade: $isPresentingPROUpgrade)
            }
            .padding(20)
        }
    }
}

extension Notification.Name {
    static let navigateToCategories = Notification.Name("navigateToCategories")
}
