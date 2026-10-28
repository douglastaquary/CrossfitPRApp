import SwiftUI
import Domain
import Application
import PRHistory
import SharedUI
import Localization

public struct CategoryListView: View {
    @EnvironmentObject private var personalRecordClient: PersonalRecordClient
    @State private var selectedGroupIndex = 0
    @State private var searchText = ""
    @State private var selectedCategory: WorkoutCategory?
    private let impact = UIImpactFeedbackGenerator(style: .light)

    private let groupNames = RecordGroup.allCases.map(\.rawValue)

    public init() {}

    private var displayedCategories: [WorkoutCategory] {
        let group = RecordGroup.allCases[selectedGroupIndex]
        if searchText.isEmpty {
            return PersonalRecordGrouping.categories(in: group)
        }
        return PersonalRecordGrouping.searchCategories(for: searchText)
            .filter { $0.group == group }
    }

    public var body: some View {
        NavigationStack {
            CategoryListScrollContent(
                groupNames: groupNames,
                selectedGroupIndex: $selectedGroupIndex,
                categories: displayedCategories,
                onGroupChanged: { impact.impactOccurred() },
                onSelectCategory: { category in
                    selectedCategory = category
                    impact.impactOccurred()
                }
            )
            .navigationTitle(Strings.Screen.category)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: Strings.Category.searchPrompt)
            .sheet(item: $selectedCategory) { category in
                NewPRRecordView(category: category)
            }
        }
        .brandTint()
    }
}

private struct CategoryListScrollContent: View {
    let groupNames: [String]
    @Binding var selectedGroupIndex: Int
    let categories: [WorkoutCategory]
    let onGroupChanged: () -> Void
    let onSelectCategory: (WorkoutCategory) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                CategorySegmentView(items: groupNames, selectedIndex: $selectedGroupIndex)
                    .onChange(of: selectedGroupIndex) { _ in onGroupChanged() }
                    .padding(.horizontal, AppDesign.Layout.horizontalPadding)
                    .padding(.bottom)

                CategoryListTipHeader()

                ForEach(categories) { category in
                    CategoryItemView(
                        title: category.title,
                        groupKey: category.group.localizedKey
                    )
                    .onTapGesture {
                        onSelectCategory(category)
                    }
                }
            }
        }
    }
}

private struct CategoryListTipHeader: View {
    var body: some View {
        HStack {
            Text("💡")
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .padding(.leading, 20)
            Text(Strings.Category.listHeader)
        }
        Divider().padding([.leading, .trailing, .top])
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
