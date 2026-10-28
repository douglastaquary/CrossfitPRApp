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
            PRHistoriesListContent(
                isLoading: personalRecordClient.isLoading,
                sections: sections,
                filteredSections: filteredSections
            )
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

private struct PRHistoriesListContent: View {
    let isLoading: Bool
    let sections: [PRSection]
    let filteredSections: [PRSection]

    var body: some View {
        Group {
            if isLoading && sections.isEmpty {
                PRHistoriesLoadingState()
            } else if sections.isEmpty {
                PRHistoriesEmptyState()
            } else {
                PRHistoriesSectionsList(sections: filteredSections)
            }
        }
    }
}

private struct PRHistoriesLoadingState: View {
    var body: some View {
        ProgressView(Strings.PRHistory.loading)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct PRHistoriesEmptyState: View {
    var body: some View {
        VStack {
            Text(Strings.PRHistory.emptyMessage)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 64)
        }
    }
}

private struct PRHistoriesSectionsList: View {
    let sections: [PRSection]

    var body: some View {
        ScrollView {
            ForEach(sections) { section in
                NavigationLink(value: section) {
                    CategoryItemView(
                        title: section.name,
                        groupKey: section.group.localizationKey
                    )
                }
            }
        }
    }
}
