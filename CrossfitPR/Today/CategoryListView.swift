//
//  CategoryListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 18/05/22.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    let impact = UIImpactFeedbackGenerator(style: .light)
    @EnvironmentObject var store: CategoryStore
    @State var showNewPRView = false
    @State var showAddNewPRView = false
    @State var selectedCategoryItem: Int = 0
    @State var selectedCategory: Category? = nil
    @State var searchText = ""
    @State var categories: [Category] = []
    @State var categoryNames: [String] = [
        RecordGroup.barbell.rawValue,
        RecordGroup.gymnastic.rawValue,
        RecordGroup.endurance.rawValue
    ]

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                    CategoryView(
                        items: categoryNames,
                        selectedCategory: $selectedCategoryItem
                    )
                    .onChange(of: selectedCategoryItem) { index in
                        categories = store.fetchCategoryPerGroup(
                            recordGroup: RecordGroup(rawValue: categoryNames[index]) ?? RecordGroup.barbell
                        )
                        impact.impactOccurred()
                    }
                    .padding([.trailing, .leading], 16)
                    .padding(.bottom)
                        Text("💡Clique no exercício para cadastrar um novo PR")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .padding(.leading, 20)
                        ForEach(searchResults, id: \.self) { exercise in
                            CategoryItemView(title: exercise.title, group: exercise.group.rawValue)
                                .onTapGesture {
                                    if let index = searchResults.firstIndex(where: { $0.id == exercise.id }) {
                                        categoryBuilder(category: searchResults[index])
                                        impact.impactOccurred()
                                        self.showAddNewPRView.toggle()
                                    }
                                }
                        }
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("screen.category.title"), displayMode: .large)
            .searchable(text: $searchText, prompt: LocalizedStringKey("category.search.descript")).foregroundColor(.green)
            .onSubmit(of: .search) {
                categories = store.searchExercise(for: searchText)
            }
            .onAppear {
                UINavigationBar.appearance().tintColor = .green
                categories = store.fetchCategoryPerGroup(
                    recordGroup: RecordGroup(rawValue: categoryNames[selectedCategoryItem]) ?? RecordGroup.barbell
                )
            }
            .sheet(isPresented: $showAddNewPRView) {
                NewRecordView()
                    .environmentObject(NewRecordViewModel(category: selectedCategory))
            }
        }
        .onChange(of: searchText) { searchText in
            categories = store.searchExercise(for: searchText)
        }
    }
    
    private func categoryBuilder(category: Category) {
        selectedCategory = category
        selectedCategory?.group = category.group
        selectedCategory?.type = category.type
    }
    
    var searchResults: [Category] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.title.contains(searchText) }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
            .environmentObject(CategoryStore())
    }
}

//
//
//struct CategoryCollectionView: View {
//    @EnvironmentObject var store: CategoryStore
//    @State var showNewPRView = false
//
//    var body: some View {
//        NavigationStack {
//            ScrollViewReader { scrollView in
//                Picker(selection: $viewModel.selectedCategory, label: Text("Crossfit PR").foregroundColor(.secondary)) {
//                    ForEach(0..<store.filteredCategories. .count, id: \.self) {
//                        Text(viewModel.personalRecordTypeList[$0].title)
//                    }
//                }
//                .foregroundColor(.primary)
//                .padding(.bottom, 12)
//
//
//
//
//
//
//
//                ScrollView {
//                    ForEach(store.filteredCategories, id: \.id) { category in
//                        NavigationLink(value: category) {
//                            CategoryItemView(title: category.title, group: category.group.rawValue)
//                        }
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    Button(action: { self.showNewPRView.toggle() }) {
//                        Image(systemName: "plus.circle")
//                            .font(.headline)
//                            .foregroundColor(.green)
//                            .accessibility(label: Text("add new record"))
//                    }.sheet(isPresented: $showNewPRView) {
//                        NewRecordView()
//                    }
//                }
//            }
//            .navigationBarTitle(LocalizedStringKey("screen.category.title"), displayMode: .large)
//            .searchable(text: $store.searchText, prompt: LocalizedStringKey("category.search.descript"))
//            .onAppear {
//                UINavigationBar.appearance().tintColor = .green
//            }
//            .navigationDestination(for: Category.self) { category in
//                RecordDetail(prName: category.title)
//                    .environmentObject(RecordStore(recordCategory: category))
//            }
//        }
//    }
//}
//
//struct CategoryCollectionViewT_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryCollectionView()
//    }
//}
