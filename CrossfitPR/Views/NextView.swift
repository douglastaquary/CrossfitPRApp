//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-24
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI

enum NextView: String, Identifiable {
    case promo, renew
    var id: String {
        self.rawValue
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .promo:
            Text("Promotional Offer")
                .font(.largeTitle)
        case .renew:
            VStack {
                Text("Renew Subscription")
                    .font(.largeTitle)
               Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 128))
            }
        }
    }
}

