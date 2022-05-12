//
//  LineViewGraph.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 11/05/22.
//

import SwiftUI
import SwiftUICharts

let prEvolution = Legend(color: .yellow, label: "PR evolution", order: 3)
let mostRecent = Legend(color: .green, label: "Most recent pr", order: 4)
let lowestPR = Legend(color: .gray, label: "Lowest pr", order: 2)


let points: [DataPoint] = [
    .init(value: 70, label: "70 lb", legend: lowestPR),
    .init(value: 90, label: "90 lb", legend: prEvolution),
    .init(value: 91, label: "91 lb", legend: prEvolution),
    .init(value: 92, label: "92 lb", legend: prEvolution),
    .init(value: 110, label: "110 lb", legend: prEvolution),
    .init(value: 124, label: "124 lb", legend: mostRecent),
    .init(value: 135, label: "135 lb", legend: mostRecent)
]

struct LineViewGraph: View {
    var body: some View {
        VStack{
            LineChartView(dataPoints: points)
                .padding(.top)
        }
        
    }
}

struct LineViewGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineViewGraph()
    }
}
