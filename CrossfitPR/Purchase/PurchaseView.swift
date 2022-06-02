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
                Text("CrossfitPR PRO")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                HViewImageAndText(image: "list.bullet", imageColor: .green, title: "Todos os prs de forma fácil e prática", description: "Gerencie suas categorias, prs e organize seus records")
                HViewImageAndText(image: "chart.bar", imageColor: .green, title: "The powerful insights", description: "The powerful insights elevator allows you to understand your biggest records and the evolution of others")
                HViewImageAndText(image: "info.circle.fill", imageColor: .green, title: "The powerful insights", description: "Dashboard para acompanhar a evolução dos records e melhorar a performance")
                Text("Try FREE for 7 Days")
                    .fontWeight(.bold)
                    .font(.body)
                    .padding()
                VStack(spacing: 12) {
                    Button("R$ 4,90 / Mounth"){}
                    .buttonStyle(OutlineButton())
                    Button("R$ 57,90 / Year"){}
                    .buttonStyle(FilledButton())
                    
                }
                .padding()
                Text("No commitment. Cancel Anytime.\nAfter 7 day free trial, this subscription automatically\n renews depending on witch pan you choose unless\nauto-renew is turned off.")
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
