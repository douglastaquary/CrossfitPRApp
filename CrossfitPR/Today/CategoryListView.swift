//
//  CategoryListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 18/05/22.
//

import SwiftUI
import CoreData
import ActivityKit

struct CategoryListView: View {
    @EnvironmentObject var store: CategoryStore
    @State var showNewPRView = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(store.filteredCategories, id: \.id) { category in
                        NavigationLink(value: category) {
                            CategoryItemView(title: category.title, group: category.group.rawValue)
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
                        NewRecordView()
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("screen.category.title"), displayMode: .large)
            .searchable(text: $store.searchText, prompt: LocalizedStringKey("category.search.descript"))
            .onAppear {
                UINavigationBar.appearance().tintColor = .green
                if #available(iOS 16.1, *) {
                    store.startLiveActivity()
                } else {
                    // Fallback on earlier versions
                }
            }
            .navigationDestination(for: Category.self) { category in
                RecordDetail(prName: category.title)
                    .environmentObject(RecordStore(recordCategory: category))
            }   
        }

    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
