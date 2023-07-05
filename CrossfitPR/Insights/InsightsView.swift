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
        .foregroundStyle(.secondary)
    }
}

struct InsightsView: View {
    @State var showPROsubsciptionView = false
    @EnvironmentObject var store: InsightsViewModel
    @StateObject var storeKitManager = StoreKitManager()
    
    var body: some View {
        switch store.uiState {
        case .loading:
            InsightsViewPRO(isShimmering: true)
                .environmentObject(store)
        case .isPRO:
            InsightsViewPRO(isShimmering: false)
                .environmentObject(store)
//                .onAppear {
//                    store.loadAllRecords()
//                    store.setupMeasureForBarbellRecords()
//                    store.configureRecordsRacking()
//                }
        default:
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
//                    Task {
//                        await store.updatePurchases()
//                    }
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
