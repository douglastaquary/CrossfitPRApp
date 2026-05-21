//
//  CategoryView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 23/06/23.
//

import SwiftUI

struct CategoryView: View {
    let items: [String]
    @Binding var selectedCategory: Int
    let impact = UIImpactFeedbackGenerator(style: .light)


    var body: some View {
        VStack(alignment: .center) {
            Picker("What is your favorite color?", selection: $selectedCategory) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(LocalizedStringKey(self.items[index]))
                        .tag(index)
                        .foregroundColor(.green)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding([.bottom, .top], 14)
        .onChange(of: selectedCategory) { selectedCategory in
            impact.impactOccurred()
        }
    }
}


struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(items: ["barbell", "gymnastic"], selectedCategory: .constant(1))
    }
}
