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
                        HSubtitleView(title: "record.category.title", subtitle: store.category?.name ?? "")
                        let group = store.category?.group ?? .barbell
                        switch group {
                        case .barbell:
                            HSubtitleView(
                                title: "record.weight.title",
                                subtitle: isPounds ? "\(String(describing: record.poundValue)) lb" : "\(String(describing: record.kiloValue)) kg"
                            )
                        case .gymnastic:
                            HSubtitleView(title: "record.maxReps.title", subtitle: "\(String(describing: record.maxReps))")
                            HSubtitleView(title: "record.time.title", subtitle: "\(String(describing: record.minTime)) min")
                        case .endurance:
                            HSubtitleView(title: "record.distance.title", subtitle: "\(String(describing: record.distance))km")
                            HSubtitleView(title: "record.time.title", subtitle: "\(String(describing: record.minTime)) min")
                        }

                        HSubtitleView(title: "record.date.title", subtitle: "\(String(describing: record.dateFormatter))")
                    }
                    
                    if store.category?.group == .barbell {
                        Section("Porcentagens do PR") {
                            NavigationLink(value: record) {
                                HSubtitleView(
                                    title: "Porcentagem",
                                    subtitle: "\(String(describing: record.percentage.clean))%"
                                )
                            }
                        }
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
                
                Section(header: Text("record.evolution.section.title \(store.category?.name ?? "")"), footer: Text("record.evolution.section.description \(store.category?.name ?? "")")) {
                    Chart {
                        ForEach(points, id: \.id) { point in
                            BarMark(
                                x: .value("Date", point.date),
                                y: .value("Weight", point.value)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
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
        RecordDetail()
    }
}
