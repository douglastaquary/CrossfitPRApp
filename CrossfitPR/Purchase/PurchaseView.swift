//
//  PurchaseView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/05/22.
//

import SwiftUI

struct PurchaseView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("CrossfitPR PRO")
                .font(.title)
                .foregroundColor(.green)
            
            VStack(alignment: .leading) {
                HViewImageAndText(image: "chart.bar", imageColor: .green, title: "Anote seus PRs sem complicações", description: "Todas as informações sobre os seus PRs em um só lugar")
                HViewImageAndText(image: "paperclip", imageColor: .blue, title: "Organizing your PRs", description: "Organizing your personal records makes the evolution of your exercises more practical")
                HViewImageAndText(image: "info.circle.fill", imageColor: .green, title: "The powerful insights", description: "The powerful insights elevator allows you to understand your biggest records and the evolution of others")
            }
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

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}
