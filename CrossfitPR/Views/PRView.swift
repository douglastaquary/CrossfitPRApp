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
                    
                    if let category = record.group {
                        switch category {
                        case .barbell:
                            RingProgressView(progressValue: (record.percentage/100))
                            VStack(alignment: .leading) {
                                Text("\(record.dateFormatter)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 8)
                                HorizontalBarChartView(dataPoints: [
                                    DataPoint.init(
                                        value: Double(isPounds ? record.poundValue : record.kiloValue),
                                        label: isPounds ? "\(record.poundValue) lb" : "\(record.kiloValue) kg",
                                        legend: Legend(color: .yellow, label: "\(record.crossfitLevel?.rawValue ?? "")", order: 2)
                                    )
                                ])
                            }
                            
                        case .endurance:
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
                                        legend: Legend(color: .yellow, label: "\(record.crossfitLevel?.rawValue ?? "")", order: 2)
                                    )
                                ])
                            }
                        case .gymnastic:
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
                                        legend: Legend(color: .yellow, label: "\(record.crossfitLevel?.rawValue ?? "")", order: 2)
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
    @State var group: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.top, 8)
                .padding(.leading, 22)
            Text(LocalizedStringKey(group))
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading, 22)
            Divider()
        }
    }
}

struct CategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemView(title: "Snatch", group: "Barra")
    }
}

struct RecordImageInformationView: View {
    var imageSystemName: String = "bolt.fill" //bolt.fill
    var title: String
    var foregroundColor: Color = .green
    var body: some View {
        ZStack {
            HStack {
                Rectangle()
                    .foregroundColor(foregroundColor.opacity(0.1))
                    .frame(width: .infinity , height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .overlay(
                        HStack {
                            Image(systemName: imageSystemName)
                                .foregroundColor(foregroundColor)
                            Text(title)
                                .font(.callout)
                                .foregroundColor(foregroundColor)
                                //.bold()
                        }
                        
                    )

            }
        }
    }
}

struct RecordImageInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RecordImageInformationView(title: "180 lb")
    }
}


struct PersonalRecordView: View {
    var record: PersonalRecord
    var isPounds: Bool {
        UserDefaultsConfig.shared.measureTrackingMode == MeasureTrackingMode.pounds.rawValue
    }
    var imageSystemName: String = "figure.strengthtraining.traditional" //bolt.fill
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.1))
                        .frame(width: 32 , height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
                        .overlay(Image(systemName: imageSystemName).foregroundColor(.black))
                    
                        .padding(.trailing, 4)

                    Text(LocalizedStringKey(record.prName))
                        .bold()
                    Spacer()
                }
                .frame(height: 42)
                
            }
            HStack(spacing: 12) {
                RecordImageInformationView(
                    imageSystemName: "calendar",
                    title: "\(record.dateFormatter)",
                    foregroundColor: .yellow
                )
                RecordImageInformationView(
                    imageSystemName: "bolt.fill",
                    title: isPounds ? "\(record.poundValue)lb" : "\(record.kiloValue)kg",
                    foregroundColor: .green
                )
                
                RecordImageInformationView(
                    imageSystemName: "chart.bar.fill",
                    title: "\(Float(record.percentage))%",
                    foregroundColor: .red
                )
                Spacer()
            }
        }
    }
}

struct PersonalRecordView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalRecordView(record: PersonalRecord.recordMock)
    }
}
