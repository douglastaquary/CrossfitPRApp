//
//  InsightsViewPRO.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 16/09/22.
//

import SwiftUI
import Charts
import SwiftUICharts

struct InsightsViewPRO: View {
    @EnvironmentObject var store: InsightsStore
    
    var body: some View {
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
            }
        }
    }
    
}

//struct InsightsViewPRO_Previews: PreviewProvider {
//    static var previews: some View {
//        InsightsViewPRO(store: InsightsStore())
//    }
//}
