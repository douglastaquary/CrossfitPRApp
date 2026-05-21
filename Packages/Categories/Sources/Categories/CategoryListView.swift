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

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    CategorySegmentView(items: groupNames, selectedIndex: $selectedGroupIndex)
                        .onChange(of: selectedGroupIndex) { _ in impact.impactOccurred() }
                        .padding(.horizontal, AppDesign.Layout.horizontalPadding)
                        .padding(.bottom)

                    HStack {
                        Text("💡")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .padding(.leading, 20)
                        Text(Strings.Category.listHeader)
                    }
                    Divider().padding([.leading, .trailing, .top])

                    ForEach(displayedCategories) { category in
                        CategoryItemView(
                            title: category.title,
                            groupKey: category.group.localizedKey
                        )
                        .onTapGesture {
                            selectedCategory = category
                            impact.impactOccurred()
                        }
                    }
                }
            }
            .navigationTitle(Strings.Screen.category)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: Strings.Category.searchPrompt)
            .sheet(item: $selectedCategory) { category in
                NewPRRecordView(category: category)
            }
        }
        .brandTint()
    }

    private var displayedCategories: [WorkoutCategory] {
        let group = RecordGroup.allCases[selectedGroupIndex]
        if searchText.isEmpty {
            return PersonalRecordGrouping.categories(in: group)
        }
        return PersonalRecordGrouping.searchCategories(for: searchText)
            .filter { $0.group == group }
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
