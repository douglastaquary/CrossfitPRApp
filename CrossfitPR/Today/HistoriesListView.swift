//
//  PRHistoriesListView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import SwiftUI
import Combine
import CoreData

typealias AppStore = Store<AppState, AppAction, AppDependencies>

struct HistoriesListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    
    var prs: FetchedResults<PR>
    
    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject var viewlaunch: ViewLaunch
    @State var showNewPRView = false

    var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ScrollView {
                    ForEach(prs, id: \.id) { pr in
                        NavigationLink(destination: RecordDetail(record: pr)) {
                            PRView(record: pr)
                        }
                    }
//                    .onDelete(perform: delete)
//                    .onMove(perform: move)
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
                    Button(action: {
                        self.showNewPRView.toggle()
                    }){
                    Text("New PR")
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
            .navigationTitle("Personal Records")
        }
    }
}

struct PRHistoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoriesListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct PRView: View {
    var record: PR
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.prName)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            HStack {
                Text("\(record.prValue) lb")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(record.dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
            }
            Divider()
        }
        .padding(.leading, 16)
    }
}
