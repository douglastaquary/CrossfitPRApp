//
//  PRDetailView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/04/22.
//

import SwiftUI
import SwiftUICharts
import CoreData
import Charts

struct AnnotationView: View {
    let recordValue: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(recordValue)
            //Image(systemName: "figure.stand")
        }
        .font(.caption)
        .foregroundStyle(.black)
    }
}

struct InsightsView: View {
    @State var showPROsubsciptionView = false
    @EnvironmentObject var store: InsightsStore

    var body: some View {
        //if store.isPro {
        if !store.records.isEmpty {
                VStack {
                    Form {
                        Section("insight.section.ranking.barbell.title") {
                            if store.barbellHorizontalBarList.isEmpty {
                                Text(LocalizedStringKey("insight.view.error.description"))
                            } else {
                                HorizontalBarChartView(dataPoints: store.barbellHorizontalBarList)
                            }
                        }
                        Chart {
                            ForEach(store.barbellRecords) { record in
                                BarMark(
                                    x: .value("Record Name", record.prName),
                                    y: .value("Intensity", record.poundValue)
                                )
                                .foregroundStyle(by: .value("Weight", record.prName))
                                .annotation(position: .top) {
                                    AnnotationView(recordValue: "\(record.poundValue) lb")
                                }

                            }
                        }
                        .frame(height: 240)
                        .padding(.top, 12)
                        
                        Section("insight.section.ranking.gymnastic.title") {
                            if store.gynmnasticHorizontalBarList.isEmpty {
                                Text(LocalizedStringKey("insight.view.error.description"))
                            } else {
                                HorizontalBarChartView(dataPoints: store.gynmnasticHorizontalBarList)
                            }
                        }
                        Chart {
                            ForEach(store.gymnasticRecords) { record in
                                BarMark(
                                    x: .value("Record Name", record.prName),
                                    y: .value("Reps", record.maxReps)
                                )
                                .foregroundStyle(by: .value("Record Name", record.prName))
                                .annotation(position: .top) {
                                    AnnotationView(recordValue: "\(record.maxReps) reps")
                                }

                            }
                        }
                        .frame(height: 240)
                        .padding(.top, 12)
                        
                        Section("insight.section.ranking.endurance.title") {
                            if store.enduranceHorizontalBarList.isEmpty {
                                Text(LocalizedStringKey("insight.view.error.description"))
                            } else {
                                HorizontalBarChartView(dataPoints: store.enduranceHorizontalBarList)
                            }
                        }
                        Chart {
                            ForEach(store.enduranceRecords) { record in
                                BarMark(
                                    x: .value("Record Name", record.prName),
                                    y: .value("Endurance", record.distance)
                                )
                                .foregroundStyle(by: .value("Record Name", record.prName))
                                .annotation(position: .top) {
                                    AnnotationView(recordValue: "\(record.distance) km")
                                }
                            }
                        }
                        .frame(height: 240)
                        .padding(.top, 12)
//
//                        Section("insight.section.information.title") {
//                            let recordTypeName = store.biggestPR?.prName ?? ""
//                            if store.measureTrackingMode == .pounds {
//                                HSubtitleView(
//                                    title: recordTypeName,
//                                    subtitle: "\(store.biggestPR?.poundValue ?? 0) lb"
//                                )
//                            } else {
//                                HSubtitleView(
//                                    title: recordTypeName,
//                                    subtitle: "\(store.biggestPR?.kiloValue ?? 0) kg"
//                                )
//                            }
//                            HSubtitleView(
//                                title: "insight.view.intensity.title",
//                                subtitle: "\(store.biggestPR?.percentage.clean ?? "") %"
//                            )
//                        }
                    }
                }
            } else {
                EmptyView(message: "emptyView.screen.message")
            }
       // } else {
//            VStack {
//                Button {
//                    self.showPROsubsciptionView.toggle()
//                } label: {
//                    CardGroupView(
//                        cardTitle: "insight.view.card.pro.title",
//                        cardDescript: "insight.view.card.pro.description",
//                        buttonTitle: "insight.view.card.unlockprobutton.title",
//                        iconSystemText: "chart.bar.fill"
//                    )
//                }.sheet(isPresented: $showPROsubsciptionView) {
//                    PurchaseView()
//                }.onAppear {
//                    UINavigationBar.appearance().tintColor = .green
//                }
//                Spacer()
//            }
//            .padding(22)
       // }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView().preferredColorScheme(.dark)
    }
}
