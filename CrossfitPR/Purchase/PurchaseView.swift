//
//  PurchaseView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/05/22.
//

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var store: PurchaseStore
    @StateObject var storeKitManager: StoreKitManager
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Button(
                                action:{
                                    self.store.stopObserving()
                                    self.presentation.wrappedValue.dismiss()
                                }, label: {
                                    Text("newRecord.screen.cancel.button.title")
                                        .foregroundColor(.green)
                                })
                        }
                    }
                    .padding([.top, .trailing], 24)
                    
                    Spacer()
                    Text("CrossFitPR PRO")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                        .padding(.top)
                    
                    HViewImageAndText(image: "gearshape", imageColor: .green, title: "purchase.item1.title", description: "purchase.item1.description")
                    
                    HViewImageAndText(image: "chart.xyaxis.line", imageColor: .green, title: "purchase.item2.title", description: "purchase.item2.description")
                    
                    HViewImageAndText(image: "trophy", imageColor: .green, title: "purchase.item3.title", description: "purchase.item3.description")
                    
                    Text(LocalizedStringKey("purchase.tryfree.title"))
                        .fontWeight(.bold)
                        .font(.body)
                        .padding()
                    VStack(spacing: 12) {
                        if store.subscriptions.isEmpty {
                            Button {
                                ""
                            } label: {
                                ProgressView()
                            }
                            .buttonStyle(OutlineButton())
                            .frame(width: 160)
                            Button {
                                ""
                            } label: {
                                ProgressView()
                            }.buttonStyle(FilledButton())
                            .frame(width: 160)
                        }  else {
                            Button("\(store.priceLocale(to: store.subscriptions[1]) ?? "") / Mounth"){
                                store.performPROMonthly(product: store.subscriptions[1])
                            }.buttonStyle(OutlineButton())
                            
                            Button("\(store.priceLocale(to: store.subscriptions[0]) ?? "") / Year"){
                                store.performPROAnnual(product: store.subscriptions[0])
                            }.buttonStyle(FilledButton())
                        }
                        
                    }
                    .padding()
                    Text(LocalizedStringKey("purchase.commitment.title"))
                        .font(Font.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .onChange(of: store.state) { newValue in
            if store.state == .unlockPro {
                store.unlockPro()
                self.store.stopObserving()
                self.presentation.wrappedValue.dismiss()
            }
        }
    }
    
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(storeKitManager: StoreKitManager())
    }
}
