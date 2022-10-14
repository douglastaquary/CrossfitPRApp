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
    @Environment(\.isPro) var isPro
    @State var products: [Product] = []
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
                        if self.products.isEmpty {
                            Button(action: {}, label: { ProgressView() })
                                .buttonStyle(OutlineButton())
                                .frame(width: 160)
                            Button(action: {}, label: { ProgressView() })
                                .buttonStyle(FilledButton())
                                .frame(width: 160)
                        }  else {
                            Button("\(products[1].price.formatted()) / Mounth"){
                                let product = products[1]
                                Task {
                                    await store.purchase(product: product)
                                }
                            }.buttonStyle(OutlineButton())
                            
                            Button("\(products[0].price.formatted()) / Year"){
                                let product = products[0]
                                Task {
                                    await store.purchase(product: product)
                                }
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
                self.presentation.wrappedValue.dismiss()
            }
        }
        .onAppear {
            Task {
                do {
                    let currentProducts = try await store.fetchProducs()
                    self.products = try await currentProducts.value
                } catch {
                    print("\(error)")
                }
            }
        }
        .user(store.isPro)
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(storeKitManager: StoreKitManager())
    }
}
