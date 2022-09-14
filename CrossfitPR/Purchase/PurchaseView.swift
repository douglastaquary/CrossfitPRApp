//
//  PurchaseView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/05/22.
//

import SwiftUI

struct PurchaseView: View {
    @Environment(\.presentationMode) var presentation
    
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
                                        .bold()
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
                        Button("R$ 4,90 / Mounth"){
                            
                        }.buttonStyle(OutlineButton())
                        
                        Button("R$ 50,90 / Year"){
                            
                        }.buttonStyle(FilledButton())
                        
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
    }
    
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}
