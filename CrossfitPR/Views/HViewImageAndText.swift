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
                    .font(.system(size: 36))
                    .frame(width: 36)
                    .foregroundColor(imageColor)
                    .padding()

                VStack(alignment: .leading) {
                    Text(title).bold()
                
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.frame(width: 340, height: 100)
        }
    }
}

struct HViewImageAndText_Previews: PreviewProvider {
    static var previews: some View {
        HViewImageAndText(image: "heart.fill", imageColor: .pink, title: "More Personalized", description: "Top Stories picked for you and recommendations from siri.")
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
