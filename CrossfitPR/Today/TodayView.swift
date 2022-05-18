//
//  PRHistoriesListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import SwiftUI
import Combine
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    var prs: FetchedResults<PR>
    
    @StateObject private var viewModel = HistoryViewModel()
    @State var showNewPRView = false
    @State var sections: [PRSection] = []
    @State private var searchText: String = ""
    
    var filteredPrs: [PR] {
        prs.filter { item in
            searchText.isEmpty ? true : item.prName.contains(searchText)
        }.sorted()
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                if prs.isEmpty {
                    EmptyView(message: "Get started\nnow by adding a new\npersonal record")
                } else {
                    ForEach(filteredPrs, id: \.id) { pr in
                        NavigationLink(destination: RecordDetail(record: pr)) {
                            PRView(record: pr)
                        }
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
    
    private func buildSections() {
        for pr in prs {
            if sections.isEmpty {
                let section = PRSection(name: pr.prName, prs: [pr])
                sections.append(section)
            } else {
                for s in 0..<sections.count {
                    if sections[s].name == pr.prName {
                        sections[s].addNewPR(pr)
                    } else {
                        let section = PRSection(name: pr.prName, prs: [pr])
                        sections.append(section)
                    }
                }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
