//
//  CategoryListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 18/05/22.
//

import SwiftUI

struct Category: Identifiable, Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.title < rhs.title
    }
    
    let id = UUID()
    var title: String
}

struct CategoryListView: View {
    @State private var searchText: String = ""
    @State var showNewPRView = false
    
    var filteredCategories: [Category] {
        ActivitiesRecordKey.allCases.map {
            Category(title: $0.rawValue)
        }.filter {
            searchText.isEmpty ? true : $0.title.contains(searchText)
        }.sorted()
    }

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(filteredCategories, id: \.id) { category in
                    NavigationLink(destination: RecordDetail(record: PersistenceController.prMock, prName: category.title)) {
                            CategoryItemView(title: category.title)
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
                        .accessibility(label: Text("add"))
                }.sheet(isPresented: $showNewPRView) {
                    NewPRRecordView()
                }
            }
        }
        .navigationBarTitle("Personal records", displayMode: .large)
        .searchable(text: $searchText, prompt: "search by name")
        .onAppear {
            UINavigationBar.appearance().tintColor = .green
        }
        

    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
