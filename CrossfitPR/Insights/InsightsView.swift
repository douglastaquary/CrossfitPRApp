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
    @State var evolutionPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .yellow, label: "", order: 2))
    @State var lowPoint: DataPoint = DataPoint.init(value: 0.0, label: "", legend: Legend(color: .gray, label: "", order: 3))
    @State var limit: DataPoint = DataPoint(value: 0, label: "", legend: Legend(color: .clear, label: ""))
    @State var barPoints: [DataPoint] = []
    @State var biggestPRName: String = ""
    @State var biggestPR: PR?
    @State var showPROsubsciptionView = false
    
    @EnvironmentObject var store: InsightsStore
    //@Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PR.entity(), sortDescriptors: [], predicate: NSPredicate(format: "prName != %@", PRType.empty.rawValue))
    var prs: FetchedResults<PR>
    
    var body: some View {
        if prs.count > 3 {
            VStack {
                Form {
                    Section("Records ranking") {
                        HorizontalBarChartView(dataPoints: [biggestPoint, evolutionPoint, lowPoint])
                    }
                    Section("Graph Details") {
                        if barPoints.isEmpty {
                            Text("There is no data to display chart...")
                        } else {
                            BarChartView(dataPoints: barPoints, limit: limit)
                        }
                    }
                    Section("PR informations") {
                        if store.measureTrackingMode == .pounds {
                            HSubtitleView(title: "the biggest pr is " + "\(biggestPR?.prName ?? "")".lowercased(), subtitle: "\(biggestPR?.recordPound ?? 0) lb")
                        } else {
                            HSubtitleView(title: "the biggest pr is " + "\(biggestPR?.prName ?? "")".lowercased(), subtitle: "\(biggestPR?.recordKilo ?? 0) kg")
                        }
                        
                        HSubtitleView(title: "with intensity of", subtitle: "\(biggestPR?.percentage.clean ?? "") %")
                    }
                    
                    Button {
                        self.showPROsubsciptionView.toggle()
                    } label: {
                        CardGroupView(
                            cardTitle: "Insights",
                            cardDescript: "PRO subsciption enables historical data analysis that helps you undestand how new habits influence your heart",
                            buttonTitle: "Unlock CrossfitPR PRO",
                            iconSystemText: "chart.bar.fill"
                        )
                    }.sheet(isPresented: $showPROsubsciptionView) {
                        PurchaseView()
                    }
                    
                }.onAppear {
                    loadGraph()
                    loadPRInfos()
                }
            }
        } else {
            EmptyView(message: "Get started now\nby adding a new personal record.\n\nThe Powerful insights are generated from\nthe records you add. For better visualization, the minimum number of records\nto generate the graphs is ten.")
        }
        
    }
    
    private func build() -> [PR] {
        let prs: [PR] = Array(Set(prs.map { $0 }))
        return prs
    }
    
    private func loadGraph() {
        if store.measureTrackingMode == .pounds {
            let max: Int = prs.map { $0.recordPound }.max() ?? 0
            barPoints = prs.map { pr in
                if pr.recordPound == max {
                    self.limit = DataPoint(value: Double(max) , label: "\(pr.prName)", legend: store.biggestPr)
                }
                return DataPoint.init(value: Double(pr.recordPound), label: "", legend: validateCategoryInformationPounds(pr))
            }
        } else {
            let max: Int = prs.map { $0.recordKilo }.max() ?? 0
            barPoints = prs.map { pr in
                if pr.recordKilo == max {
                    self.limit = DataPoint(value: Double(max) , label: "\(pr.prName)", legend: store.biggestPr)
                }
                return DataPoint.init(value: Double(pr.recordKilo), label: "", legend: validateCategoryInformationKilos(pr))
            }
        }

    }
    
    private func loadPRInfos() {
        if store.measureTrackingMode == .pounds {
            let max: Int = prs.map { $0.recordPound }.max() ?? 0
            let min: Int = prs.map { $0.recordPound }.min() ?? 0
            let evolutionPRselected = prs.filter { pr in
                return pr.recordPound < max && pr.recordPound > min && pr.prName != biggestPRName
            }.sorted {
                $0.recordPound > $1.recordPound
            }.first
            
            evolutionPoint = DataPoint.init(
                value: Double(evolutionPRselected?.recordPound ?? 0),
                label: "\(evolutionPRselected?.recordPound ?? 0) lb",
                legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName ?? "")", order: 2)
            )
            
            for pr in prs {
                if pr.recordPound == max {
                    biggestPoint = DataPoint.init(value: Double(pr.recordPound), label: "\(pr.recordPound) lb", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
                    biggestPRName = pr.prName
                    biggestPR = pr
                } else if pr.recordPound == min {
                    lowPoint = DataPoint.init(value: Double(pr.recordPound), label: "\(pr.recordPound) lb", legend: Legend(color: .gray, label: "\(pr.prName)", order: 3))
                }
            }
        } else {
            let max: Int = prs.map { $0.recordKilo }.max() ?? 0
            let min: Int = prs.map { $0.recordKilo }.min() ?? 0
            let evolutionPRselected = prs.filter { pr in
                return pr.recordKilo < max && pr.recordKilo > min && pr.prName != biggestPRName
            }.sorted {
                $0.recordKilo > $1.recordKilo
            }.first
            
            evolutionPoint = DataPoint.init(value: Double(evolutionPRselected?.recordKilo ?? 0), label: "\(evolutionPRselected?.recordKilo ?? 0) lb", legend: Legend(color: .yellow, label: "\(evolutionPRselected?.prName ?? "")", order: 2))
            
            for pr in prs {
                if pr.recordKilo == max {
                    biggestPoint = DataPoint.init(value: Double(pr.recordKilo), label: "\(pr.recordKilo) kg", legend: Legend(color: .green, label: "\(pr.prName)", order: 1))
                    biggestPRName = pr.prName
                    biggestPR = pr
                } else if pr.recordKilo == min {
                    lowPoint = DataPoint.init(value: Double(pr.recordKilo), label: "\(pr.recordKilo) kg", legend: Legend(color: .gray, label: "\(pr.prName)", order: 3))
                }
            }
        }
    }
    
    private func validateCategoryInformationPounds(_ pr: PR) -> Legend {
        let max: Int = prs.map { $0.recordPound }.max() ?? 0
        let min: Int = prs.map { $0.recordPound }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        if pr.recordPound >= max {
            return biggestPr
        } else if pr.recordPound == min {
            return lowestRecord
        } else {
            return evolutionPr
        }
    }
    
    private func validateCategoryInformationKilos(_ pr: PR) -> Legend {
        let max: Int = prs.map { $0.recordKilo }.max() ?? 0
        let min: Int = prs.map { $0.recordKilo }.min() ?? 0
        let biggestPr = Legend(color: .green, label: "PR Biggest", order: 3)
        let evolutionPr = Legend(color: .yellow, label: "PR Evolution", order: 2)
        let lowestRecord = Legend(color: .gray, label: "PR Lowest", order: 1)
        if pr.recordKilo >= max {
            return biggestPr
        } else if pr.recordKilo == min {
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
