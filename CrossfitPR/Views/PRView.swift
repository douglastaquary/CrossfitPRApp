//
//  PRView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI
import SwiftUICharts

struct PRView: View {
    var record: PersonalRecord
    var isPounds: Bool {
        UserDefaultsConfig.shared.measureTrackingMode == MeasureTrackingMode.pounds.rawValue
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                    
                    if let category = record.recordMode {
                        switch category {
                        case .maxWeight:
                            ProgressView(progressValue: (record.percentage/100))
                            VStack(alignment: .leading) {
                                Text("\(record.dateFormatter)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 8)
                                Text(record.prName)
                                    .font(.footnote)
                                .foregroundColor(.secondary)
                                HorizontalBarChartView(dataPoints: [
                                    DataPoint.init(
                                        value: Double(isPounds ? record.poundValue : record.kiloValue),
                                        label: isPounds ? "\(record.poundValue) lb" : "\(record.kiloValue) kg",
                                        legend: Legend(color: .yellow, label: "\(record.category?.rawValue ?? "")", order: 2)
                                    )
                                ])
                            }
                            
                        case .maxDistance:
                            VStack(alignment: .leading) {
                                Text("\(record.dateFormatter)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 8)
                                Text(record.prName)
                                    .font(.footnote)
                                .foregroundColor(.secondary)
                                HorizontalBarChartView(dataPoints: [
                                    DataPoint.init(
                                        value: Double(record.minTime),
                                        label: "\(record.minTime) min",
                                        legend: Legend(color: .blue, label: "record.time.title", order: 3)
                                    ),
                                    DataPoint.init(
                                        value: Double(record.distance),
                                        label: "\(record.distance) km",
                                        legend: Legend(color: .yellow, label: "\(record.category?.rawValue ?? "")", order: 2)
                                    )
                                ])
                            }
                        case .maxRepetition:
                            VStack(alignment: .leading) {
                                Text("\(record.dateFormatter)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 8)
                                Text(record.prName)
                                    .font(.footnote)
                                .foregroundColor(.secondary)
                                HorizontalBarChartView(dataPoints: [
                                    DataPoint.init(
                                        value: Double(record.minTime),
                                        label: "\(record.minTime) min",
                                        legend: Legend(color: .blue, label: "record.time.title", order: 3)
                                    ),
                                    DataPoint.init(
                                        value: Double(record.maxReps),
                                        label: "\(record.maxReps) reps",
                                        legend: Legend(color: .yellow, label: "\(record.category?.rawValue ?? "")", order: 2)
                                    )
                                ])
                            }
                        }
                    }
                
            }
        }
    }
}


struct PRView_Previews: PreviewProvider {
    static var previews: some View {
        PRView(record: PersonalRecord.recordMock)
    }
}


struct CategoryItemView: View {
    @State var title: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding([.top, .bottom], 8)
                .padding(.leading, 12)
            Divider()
        }
    }
}

struct CategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemView(title: "DEADLIFT")
    }
}
