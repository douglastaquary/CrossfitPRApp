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
    @State var showPROsubsciptionView = false
    @EnvironmentObject var store: InsightsStore

    var body: some View {
        if store.records.count > 3 {
            VStack {
                Form {
                    Section("Records ranking") {
                        HorizontalBarChartView(dataPoints: [store.biggestPoint, store.evolutionPoint, store.lowPoint])
                    }
                    Section("Graph Details") {
                        if store.barPoints.isEmpty {
                            Text("There is no data to display chart...")
                        } else {
                            BarChartView(dataPoints: store.barPoints, limit: store.limit)
                        }
                    }
                    Section("PR informations") {
                        if store.measureTrackingMode == .pounds {
                            HSubtitleView(title: "the biggest pr is " + "\(store.biggestPR?.prName.rawValue ?? "")".lowercased(), subtitle: "\(store.biggestPR?.poundValue ?? 0) lb")
                        } else {
                            HSubtitleView(title: "the biggest pr is " + "\(store.biggestPR?.prName.rawValue ?? "")".lowercased(), subtitle: "\(store.biggestPR?.kiloValue ?? 0) kg")
                        }
                        HSubtitleView(title: "with intensity of", subtitle: "\(store.biggestPR?.percentage.clean ?? "") %")
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
                    }.onAppear {
                        UINavigationBar.appearance().tintColor = .green
                    }
                }
            }
        } else {
            EmptyView(message: "Get started now\nby adding a new personal record.\n\nThe Powerful insights are generated from\nthe records you add. For better visualization, the minimum\nnumber of records\nto generate the graphs is ten.")
        }
        
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView().preferredColorScheme(.dark)
    }
}
