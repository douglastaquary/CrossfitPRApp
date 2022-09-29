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
    @StateObject var storeKitManager = StoreKitManager()
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
                        switch store.category.group {
                        case .barbell:
                            HSubtitleView(title: "record.percentage.title", subtitle: "\(String(describing: store.record.percentage.clean)) %")
                            HSubtitleView(
                                title: "record.weight.title",
                                subtitle: isPounds ? "\(String(describing: store.record.poundValue)) lb" : "\(String(describing: store.record.kiloValue)) kg"
                            )
                        case .gymnastic:
                            HSubtitleView(title: "record.maxReps.title", subtitle: "\(String(describing: store.record.maxReps))")
                            HSubtitleView(title: "record.time.title", subtitle: "\(String(describing: store.record.minTime)) min")
                        case .endurance:
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
                    Chart(store.points) {
                        LineMark(
                            x: .value("Date", $0.legend),
                            y: .value("Weight", $0.value)
                        )
                        .foregroundStyle(.green)
                        .symbol(by: .value("Name", $0.name))
                    }
                    .chartYAxis(){
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 250)
                    .padding(.top)
                }
            }
        }
        .sheet(isPresented: $showPROsubsciptionView) {
            PurchaseView(storeKitManager: storeKitManager)
                .environmentObject(PurchaseStore(storeKitManager: storeKitManager))
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
