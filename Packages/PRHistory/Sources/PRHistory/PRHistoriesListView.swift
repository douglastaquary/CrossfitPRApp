import SwiftUI
import Domain
import Application
import SharedUI
import RecordDetail
import Localization

public struct PRHistoriesListView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @EnvironmentObject private var settingsClient: SettingsClient
    @State private var searchText = ""

    public init() {}

    private var sections: [PRSection] {
        PersonalRecordGrouping.sections(from: personalRecordClient.records)
    }

    private var filteredSections: [PRSection] {
        guard !searchText.isEmpty else { return sections }
        return sections.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    public var body: some View {
        NavigationStack {
            Group {
                if personalRecordClient.isLoading && sections.isEmpty {
                    ProgressView(Strings.PRHistory.loading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if sections.isEmpty {
                    VStack {
                        Text(Strings.PRHistory.emptyMessage)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 64)
                    }
                } else {
                    ScrollView {
                        ForEach(filteredSections) { section in
                            NavigationLink(value: section) {
                                CategoryItemView(
                                    title: section.name,
                                    groupKey: section.group.localizedKey
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle(Strings.Screen.records)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: Strings.Category.searchPrompt)
            .navigationDestination(for: PRSection.self) { section in
                RecordDetailView(section: section)
            }
            .task { await personalRecordClient.fetchRecords() }
            .refreshable { await personalRecordClient.fetchRecords() }
        }
        .brandTint()
    }
}

private extension RecordGroup {
    var localizedKey: String {
        switch self {
        case .barbell: return "category.group.barbell.descript"
        case .gymnastic: return "category.group.gymnastic.descript"
        case .endurance: return "category.group.endurance.descript"
        }
    }
}
