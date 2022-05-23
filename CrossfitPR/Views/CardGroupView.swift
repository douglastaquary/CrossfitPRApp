//
//  CardGroupView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 18/05/22.
//

import SwiftUI

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

struct CardGroupView: View {
    var touched: (() -> Void)?
    var cardTitle: String = ""
    var cardDescript: String = ""
    var buttonTitle: String = ""
    var iconSystemText: String = ""
    var body: some View {
        
        VStack {
            GroupBox(
                label: Label(cardTitle, systemImage: iconSystemText)
                    .foregroundColor(.green)
            ) {
                VStack {
                    HStack {
                        Text(cardDescript)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 2)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    HStack {
                        if !buttonTitle.isEmpty {
                            Button(buttonTitle) {
                                touched?()
                            }
                            .foregroundColor(.green)
                            Spacer()
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
    }
}

struct CardGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CardGroupView(cardTitle: "evolution", cardDescript: "PRO subsciption enables historical data analysis that helps you undestand how new habits influence your heart", buttonTitle: "Unlock CrossfitPR PRO", iconSystemText: "chart.bar.fill") //.colorScheme(.dark)
    }
}

struct CardTitleImageView: View {
    var cardTitle: String = ""
    var iconSystemText: String = ""
    var body: some View {
        HStack {
            Image(systemName: iconSystemText).foregroundColor(.green)
            Text(cardTitle).fontWeight(.semibold).foregroundColor(.green)
            Spacer()
        }
    }
}


struct CardTitleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CardTitleImageView(cardTitle: "evolution", iconSystemText: "chart.bar.fill") //.colorScheme(.dark)
    }
}

