//
//  CategoryListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 18/05/22.
//

import SwiftUI
import CoreData

struct Category: Identifiable, Comparable {
    
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.title < rhs.title
    }
    
    let id = UUID()
    var title: String
}

struct CategoryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    var prs: FetchedResults<PR>
    
    @EnvironmentObject var store: CategoryStore
//    @State private var searchText: String = ""
    @State var showNewPRView = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(store.filteredCategories, id: \.id) { category in
                    NavigationLink(
                        destination:RecordDetail(recordType:category.title)
                            .environmentObject(RecordStore(records: prs, recordType: category.title))
                    ) {
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
        .searchable(text: $store.searchText, prompt: "search by name")
        .onAppear {
            UINavigationBar.appearance().tintColor = .green
        }
        .navigationBarTitle("Personal records", displayMode: .large)
        
        
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
