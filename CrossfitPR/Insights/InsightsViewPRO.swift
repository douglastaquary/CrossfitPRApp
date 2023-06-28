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
    @EnvironmentObject var store: InsightsViewModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("insight.section.topranking.barbell.title"),
                        footer: Text("insight.section.footer.rank.barbell.title")) {
                    if store.barbellRecords.isEmpty {
                        Text(LocalizedStringKey("insight.view.error.description"))
                    } else {
                        ForEach(store.topRakingBarbellRecords) { barbell in
                            RankingView()
                                .environmentObject(
                                    RankingViewModel(
                                        record: barbell,
                                        measure: store.measureTrackingMode, percentageEvolutionValue: "\(barbell.evolutionPercentage)", legend: barbell.legend)
                                )
                            
                        }
                    }
                }
                Section(LocalizedStringKey("insight.section.section.barbell.title")) {
                    if store.barbellRecords.isEmpty {
                        Text(LocalizedStringKey("insight.view.error.description"))
                    } else {
                        Chart {
                            ForEach(store.barbellRecords) { record in
                                BarMark(
                                    x: .value("Record Name", record.dateFormatter),
                                    y: .value("Measure", record.poundValue)
                                )
                                .foregroundStyle(by: .value("Weight", record.prName))
                                .annotation(position: .top) {
                                    AnnotationView(recordValue: validateAnnotation(record: record))
                                }
                            }
                        }
                        .frame(height: 240)
                        .padding(.top, 12)
                    }
                }
                Section(LocalizedStringKey("insight.section.ranking.gymnastic.title")) {
                    Chart {
                        ForEach(store.gymnasticRecords) { record in
                            BarMark(
                                x: .value("Record Name", record.dateFormatter),
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
                }
                Section(LocalizedStringKey("insight.section.ranking.endurance.title")) {
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
    
    private func validateIfKilosOrPounds(record: PersonalRecord) -> Int {
        if store.measureTrackingMode == .pounds {
            return record.poundValue
        }
        return record.kiloValue
    }
    
    private func validateAnnotation(record: PersonalRecord) -> String {
        if store.measureTrackingMode == .pounds {
            return "\(record.poundValue) lbs"
        }
        return "\(record.kiloValue) kg"
    }
}

struct RackingSection: Identifiable {
    let id: UUID = UUID()
    var name: String
    var records: [PersonalRecord]
    var measure: MeasureTrackingMode
}

struct RankingViewPRO: View {
    
    @State var sections: [RackingSection]
    
    var body: some View {
        VStack {
            Form {
                ForEach(sections, id: \.id) { section in
                    Section(
                        header: Text(section.name),
                        footer: Text("Evolução de 30% em relação ao ultimo PR registrado.")
                    ) {
                        ForEach(section.records) { record in
                            RankingView()
                                .environmentObject(
                                    RankingViewModel(
                                        record: record,
                                        measure: section.measure,
                                        percentageEvolutionValue: "\(record.evolutionPercentage)"
                                )
                            )
                        }
                    }
                }
            }
        }
    }
}
