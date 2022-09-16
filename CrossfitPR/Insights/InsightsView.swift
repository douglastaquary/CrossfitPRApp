//
//  PRDetailView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/04/22.
//

import SwiftUI
import SwiftUICharts
import CoreData
import Charts

struct AnnotationView: View {
    let recordValue: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(recordValue)
        }
        .font(.caption)
        .foregroundStyle(.black)
    }
}

struct InsightsView: View {
    @State var showPROsubsciptionView = false
    @EnvironmentObject var store: InsightsStore
    @StateObject var storeKitManager = StoreKitManager()
    
    var body: some View {
        if store.isPro {
            InsightsViewPRO()
                .environmentObject(store)
        } else {
            VStack {
                Button {
                    self.showPROsubsciptionView.toggle()
                } label: {
                    CardGroupView(
                        cardTitle: "insight.view.card.pro.title",
                        cardDescript: "insight.view.card.pro.description",
                        buttonTitle: "insight.view.card.unlockprobutton.title",
                        iconSystemText: "chart.bar.fill"
                    )
                }.sheet(isPresented: $showPROsubsciptionView) {
                    PurchaseView(storeKitManager: storeKitManager)
                        .environmentObject(PurchaseStore(storeKitManager: storeKitManager))
                    
                }.onAppear {
                    UINavigationBar.appearance().tintColor = .green
                }
                Spacer()
            }
            .padding(22)
        }
    }
}


struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView().preferredColorScheme(.dark)
    }
}
