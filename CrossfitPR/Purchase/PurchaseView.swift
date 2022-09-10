//
//  PurchaseView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/05/22.
//

import SwiftUI

struct PurchaseView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Spacer()
                Text("CrossFitPR PRO")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.top)
                
                HViewImageAndText(image: "list.bullet", imageColor: .green, title: "purchase.manager.title", description: "purchase.manager.description")
                HViewImageAndText(image: "chart.bar", imageColor: .green, title: "purchase.insights.title", description: "purchase.insights.description")
                
                Text(LocalizedStringKey("purchase.tryfree.title"))
                    .fontWeight(.bold)
                    .font(.body)
                    .padding()
                VStack(spacing: 12) {
                    Button("R$ 4,90 / Mounth"){}
                    .buttonStyle(OutlineButton())
                    Button("R$ 50,90 / Year"){}
                    .buttonStyle(FilledButton())
                    
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

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}
