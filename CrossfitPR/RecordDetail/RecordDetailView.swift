//
//  RecordDetail.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 19/04/22.
//

import SwiftUI
import Charts

struct RecordDetailView: View {
    @EnvironmentObject var store: RecordDetailViewModel
    @EnvironmentObject var settings: SettingsStore
    @Environment(\.isPro) var isPRO
    
    @StateObject var storeKitManager = StoreKitManager()
    @State var showPROsubsciptionView = false
    @State private var confirmationShow = false
    @State var record: PersonalRecord = PersonalRecord()
    @State var points: [RecordPoint] = []
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

                        let group = store.category?.group ?? .barbell
                        switch group {
                        case .barbell:
                            HSubtitleView(
                                title: "record.weight.title",
                                subtitle: isPounds ? "\(String(describing: record.poundValue)) lb" : "\(String(describing: record.kiloValue)) kg",
                                foregroundColor: .purple
                            )
                        case .gymnastic:
                            HSubtitleView(imageSystemName: "flame", title: "record.maxReps.title", subtitle: "\(String(describing: record.maxReps))", foregroundColor: .purple)
                            HSubtitleView(imageSystemName: "timer", title: "record.time.title", subtitle: "\(String(describing: record.minTime)) min", foregroundColor: .orange)
                        case .endurance:
                            HSubtitleView(imageSystemName: "point.filled.topleft.down.curvedto.point.bottomright.up", title: "record.distance.title", subtitle: "\(String(describing: record.distance))km")
                            HSubtitleView(imageSystemName: "watchface.applewatch.case", title: "timer", subtitle: "\(String(describing: record.minTime)) min", foregroundColor: .orange)
                        }

                        HSubtitleView(imageSystemName: "calendar", title: "record.date.title", subtitle: "\(String(describing: record.dateFormatter))", foregroundColor: .gray)
                    }
                    
                    if store.category?.group == .barbell {
                        Section("record.datail.section.percentage.title") {
                            NavigationLink(value: record) {
                                HSubtitleView(imageSystemName: "percent",
                                    title: "record.datail.percentage.title",
                                    subtitle: "\(String(describing: record.percentage.clean))%"
                                )
                            }
                        }
                    }
                    
                }
                
                
                Section(header: Text("record.evolution.section.title \(store.category?.name ?? "")"), footer: Text("record.evolution.section.description \(store.category?.name ?? "")")) {
                    Chart {
                        ForEach(points, id: \.id) { point in
                            BarMark(
                                x: .value("Date", point.date),
                                y: .value("Weight", point.value)
                            )
                            .position(by: .value("Date", point.date))
                            .annotation {
                                Text(verbatim: point.value.formatted())
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(height: 250)
                    .padding(.top)
                }

                Group {
                    Section("record.records.section.title") {
                        ForEach(store.filteredPrs, id: \.id) { pr in
                            PersonalRecordView(record: pr)
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
            }
        }
        .sheet(isPresented: $showPROsubsciptionView) {
            PurchaseView(storeKitManager: storeKitManager)
                .environmentObject(PurchaseStore(storeKitManager: storeKitManager))
        }
        .navigationBarTitle(Text(prName))
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            UINavigationBar.appearance().tintColor = .green
            record = store.getMaxRecord(prs: store.filteredPrs)
            points = store.getPoints()
        }
        .navigationDestination(for: PersonalRecord.self) { record in
            PRPercentagesView(record: record)
        }
        .accentColor(.green)
    }
    
    func validateIfPro() {
        if isPRO {
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
        RecordDetailView()
    }
}
