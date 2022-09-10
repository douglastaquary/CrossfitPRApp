//
//  HViewImageAndText.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/05/22.
//

import SwiftUI

struct HViewImageAndText: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(imageColor)
                    .padding()

                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey(title))
                    Text(LocalizedStringKey(description))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.frame(width: 348, height: 100)
        }
    }
}

struct HViewImageAndText_Previews: PreviewProvider {
    static var previews: some View {
        HViewImageAndText(image: "heart.fill", imageColor: .pink, title: "More Personalized that you see and think to break", description: "Top Stories picked for you and recommendations from siri.")

    }
}
