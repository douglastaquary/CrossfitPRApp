//
//  CategoryListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 18/05/22.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    @EnvironmentObject var store: CategoryStore
    @State var showNewPRView = false
    @State var showAddNewPRView = false
    @Binding var selectedCategoryItem: Int
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
                    CategoryView(
                        items: categoryNames,
                        selectedCategory: $selectedCategoryItem
                    )
                    .onChange(of: selectedCategoryItem) { index in
                        categories = store.fetchCategoryPerGroup(
                            recordGroup: RecordGroup(rawValue: categoryNames[index]) ?? RecordGroup.barbell
                        )
                    }
                    .padding([.trailing, .leading], 12)
                    ForEach(categories, id: \.id) { category in
                        CategoryItemView(title: category.title, group: category.group.rawValue)
                            .onTapGesture {
                                self.showAddNewPRView.toggle()
                            }.sheet(isPresented: $showAddNewPRView) {
                                NewRecordView(viewModel: NewRecordViewModel(category: category))
                                    .environmentObject(NewRecordViewModel(category: category))
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { self.showNewPRView.toggle() }) {
                        Image(systemName: "plus.circle")
                            .font(.headline)
                            .foregroundColor(.green)
                            .accessibility(label: Text("add new record"))
                    }.sheet(isPresented: $showNewPRView) {
                        NewRecordView(viewModel: NewRecordViewModel())
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("screen.category.title"), displayMode: .large)
            .searchable(text: $searchText, prompt: LocalizedStringKey("category.search.descript"))
            .onSubmit(of: .search) {
                categories = store.searchExercise(for: searchText)
            }
            .onAppear {
                UINavigationBar.appearance().tintColor = .green
                categories = store.fetchCategoryPerGroup(
                    recordGroup: RecordGroup(rawValue: categoryNames[selectedCategoryItem]) ?? RecordGroup.barbell
                )
            }
        }
        .onChange(of: searchText) { searchText in
            categories = store.searchExercise(for: searchText)
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(selectedCategoryItem: .constant(0))
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
