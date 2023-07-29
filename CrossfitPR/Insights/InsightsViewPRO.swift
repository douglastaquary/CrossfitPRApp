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
    @State var isShimmering: Bool = false
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Ranking
                    HStack {
                        Image(systemName: "trophy")
                            .foregroundColor(.primary)
                            .frame(width: 24, height: 24)
                        Text(LocalizedStringKey("insight.section.topranking.barbell.title"))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    LazyVGrid(columns: gridItemLayout, spacing: 14) {
                        ForEach(store.topRakingBarbellRecords) { barbell in
                            RankingView()
                            //.shimmering(active: isShimmering)
                                .environmentObject(
                                    RankingViewModel(
                                        record: barbell,
                                        measure: store.measureTrackingMode,
                                        percentageEvolutionValue: "\(barbell.evolutionPercentage)",
                                        legend: barbell.legend
                                    )
                                )
                            
                        }
                    }
                    
                    // Barbbell
                    VStack {
                        HStack {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(.primary)
                                .frame(width: 24, height: 24)
                            Text(LocalizedStringKey("insight.section.ranking.barbell.title"))
                                .foregroundColor(.primary)
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        
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
                        .shimmering(active: isShimmering)
                        .frame(height: 240)
                    }
                    .padding([.bottom, .top], 16)
                    
                    // Gynastic
                    VStack {
                        HStack {
                            Image(systemName: "figure.play")
                                .foregroundColor(.primary)
                                .frame(width: 24, height: 24)
                            Text(LocalizedStringKey("insight.section.ranking.gymnastic.title"))
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
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
                        .shimmering(active: isShimmering)
                    }
                    .padding(.bottom, 16)
                    //Endurence
                    VStack {
                        HStack {
                            Image(systemName: "flame")
                                .foregroundColor(.primary)
                                .frame(width: 24, height: 24)
                            Text(LocalizedStringKey("insight.section.ranking.endurance.title"))
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                            Spacer()
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
                        .shimmering(active: isShimmering)
                    }
                    
                }
                .navigationBarTitle(LocalizedStringKey("screen.insights.title"), displayMode: .large)
                .padding(16)
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
