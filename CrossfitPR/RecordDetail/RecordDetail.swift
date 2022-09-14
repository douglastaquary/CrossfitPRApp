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
                        HSubtitleView(title: "record.category.title", subtitle: store.category.title)
                        switch store.category.type {
                        case .maxWeight:
                            HSubtitleView(title: "record.percentage.title", subtitle: "\(String(describing: store.record.percentage.clean)) %")
                            HSubtitleView(
                                title: "record.weight.title",
                                subtitle: isPounds ? "\(String(describing: store.record.poundValue)) lb" : "\(String(describing: store.record.kiloValue)) kg"
                            )
                        case .maxRepetition:
                            HSubtitleView(title: "record.maxReps.title", subtitle: "\(String(describing: store.record.maxReps))")
                            HSubtitleView(title: "record.time.title", subtitle: "\(String(describing: store.record.minTime)) min")
                        case .maxDistance:
                            HSubtitleView(title: "record.distance.title", subtitle: "\(String(describing: store.record.distance)) km")
                            HSubtitleView(title: "record.time.title", subtitle: "\(String(describing: store.record.minTime)) min")
                        }
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
                
                Section(header: Text("record.evolution.section.title \(store.category.title)"), footer: Text("record.evolution.section.description \(store.category.title)")) {
                    LineViewGraph(points: store.points)
                }
            }
        }
        .sheet(isPresented: $showPROsubsciptionView) {
            PurchaseView()
        }
        .navigationBarTitle(Text(prName))
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
        RecordDetail()
    }
}
