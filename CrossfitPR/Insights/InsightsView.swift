//
//  PRDetailView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/04/22.
//

import SwiftUI
import SwiftUICharts
import CoreData

struct InsightsView: View {
    @State var biggestPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .green, label: "", order: 1))
    @State var lowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 2))
    @State var limit: DataPoint = DataPoint(value: 0, label: "", legend: Legend(color: .clear, label: ""))
    @State var barPoints: [DataPoint] = []
    
    @EnvironmentObject var store: InsightsStore
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    var prs: FetchedResults<PR>

    var body: some View {
        Form {
            Section("Resume") {
                HorizontalBarChartView(dataPoints: [biggestPoint, lowPoint])
            }
            Section("Graph Details") {
                if barPoints.isEmpty {
                    Text("There is no data to display chart...")
                } else {
                    BarChartView(dataPoints: barPoints, limit: limit)
                }
            }
            Section("PR informations") {
                HSubtitleView(title: "biggest pr", subtitle: "160 lb")
                HSubtitleView(title: "percentage pr", subtitle: "70 %")
            }
        }.onAppear {
            loadGraph()
            loadPRInfos()
        }
    }
    
    private func build() -> [PR] {
        let prs: [PR] = Array(Set(prs.map { $0 }))
        return prs
    }
    
    private func loadGraph() {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        barPoints = prs.map { pr in
            if pr.prValue == max {
                self.limit = DataPoint(value: Double(max) , label: "\(pr.prName)", legend: store.biggestPr)
            }
            return DataPoint.init(value: Double(pr.prValue), label: "", legend: validateCategoryInformation(pr))
        }
    }
    
    private func loadPRInfos() {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        let min: Int = prs.map { $0.prValue }.min() ?? 0
        for pr in prs {
            if pr.prValue == max {
                biggestPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
            } else if pr.prValue == min {
                lowPoint = DataPoint.init(value: Double(pr.prValue), label: "\(pr.prValue) lb", legend: Legend(color: .gray, label: "\(pr.prName)", order: 2))
            }
        }
    }
    
    private func validateCategoryInformation(_ pr: PR) -> Legend {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        let min: Int = prs.map { $0.prValue }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        if pr.prValue >= max {
            return biggestPr
        } else if pr.prValue == min {
            return lowestRecord
        } else {
            return evolutionPr
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView().preferredColorScheme(.dark)
    }
}

struct HSubtitleView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(subtitle)
                .bold()
        }
    }
}
