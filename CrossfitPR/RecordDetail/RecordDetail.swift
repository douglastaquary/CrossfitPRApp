//
//  RecordDetail.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 19/04/22.
//

import SwiftUI
import Charts

struct RecordDetail: View {
    @EnvironmentObject var store: RecordStore
    @State var showPROsubsciptionView = false
    @State private var confirmationShow = false
    @State private var indexSet: IndexSet?
    var recordType: String = ""
    var prName: String = ""
    var isPounds: Bool {
        store.measureTrackingMode == .pounds
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Form {
                Group {
                    Section("record.biggest.section.title") {
                        HSubtitleView(title: "record.category.title", subtitle: "\(String(describing: store.record.category?.rawValue ?? ""))")
                        HSubtitleView(title: "record.percentage.title", subtitle: "\(String(describing: store.record.percentage.clean)) %")
                        
                        HSubtitleView(
                            title: "record.weight.title",
                            subtitle: isPounds ? "\(String(describing: store.record.poundValue)) lb" : "\(String(describing: store.record.kiloValue)) kg"
                        )
                        HSubtitleView(title: "record.date.title", subtitle: "\(String(describing: store.record.dateFormatter))")
                    }
                }
                Group {
                    Section("record.records.section.title") {
                        ForEach(store.filteredPrs, id: \.id) { pr in
                            PRView(record: pr)
                        }
                        .onDelete { indexSet in
                            confirmationShow = true
                            self.indexSet = indexSet
                        }
                        .confirmationDialog(
                            "record.screen.delete.confirmation.title",
                            isPresented: $confirmationShow,
                            titleVisibility: .visible
                        ) {
                            Button("record.screen.delete.button.title", role: .destructive) {
                                validateIfPro()
                            }
                            Button("record.screen.cancel.button.title", role: .cancel) { }
                        }
                    }
                }
                
                Section(header: Text("\(recordType) record.evolution.section.title"), footer: Text("record.evolution.section.description \(recordType)")) {
                    LineViewGraph(points: store.points)
                }
            }
        }
        .sheet(isPresented: $showPROsubsciptionView) {
            PurchaseView()
        }
        .navigationBarTitle(Text(recordType))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UINavigationBar.appearance().tintColor = .green
        }
        .accentColor(.green)
    }
    
    func validateIfPro() {
        if store.isPro {
            guard let indexSet = self.indexSet else {
                return
            }
            store.delete(at: indexSet)
        } else {
            self.showPROsubsciptionView.toggle()
        }
    }
}

struct RecordDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetail(recordType: "DEADLIFT")
    }
}
