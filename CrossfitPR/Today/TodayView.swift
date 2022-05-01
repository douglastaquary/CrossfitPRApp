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
        }
    }

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ScrollView {
                    if prs.isEmpty {
                        EmptyView(message: "Get started now\nby adding a new personal record")
                    } else {
                        ForEach(filteredPrs, id: \.id) { pr in
                            NavigationLink(destination: RecordDetail(record: pr)) {
                                PRView(record: pr)
                            }
                        }
                    }
                    
                    Button(action: {
                        self.showNewPRView.toggle()
                    }){
                    Text("New record")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 350, height: 48)
                        .background(Color.green)
                        .cornerRadius(8)
                        .padding(.top, 12)
                    }
                    .sheet(isPresented: $showNewPRView) {
                        NewPRRecordView()
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search pr")
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
