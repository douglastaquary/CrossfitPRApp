//
//  PRView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI
import SwiftUICharts

struct PRView: View {
    var record: PR
    
    @State var biggestPoint: DataPoint = DataPoint.init(value: 60.0, label: "", legend: Legend(color: .green, label: "60 lb", order: 1))
    @State var evolutionPoint: DataPoint = DataPoint.init(value: 98.0, label: "75 lb", legend: Legend(color: .yellow, label: "pr", order: 2))
    @State var lowPoint: DataPoint = DataPoint.init(value: 50.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                ProgressView(progressValue: (60/100))
                VStack(alignment: .leading) {
                    Text("\(record.dateFormatter)")
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                    Text("Personal record")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    HorizontalBarChartView(dataPoints: [evolutionPoint])
                }
            }
            Divider()
        }
    }
}


struct PRView_Previews: PreviewProvider {
    static var previews: some View {
        PRView(record: PersistenceController.prMock)
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
