//
//  HSubtitleView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI


struct HSubtitleView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .foregroundColor(.secondary)
            Spacer()
            Text(LocalizedStringKey(subtitle))
                .bold()
        }
    }
}

struct HSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        HSubtitleView(title: "teste", subtitle: "teste")
    }
}


struct EmptyView: View {
    @State var message: String
    var body: some View {
        VStack(alignment: .center) {
            Text(LocalizedStringKey(message))
                .multilineTextAlignment(.center)
                .lineLimit(8)
                .foregroundColor(.secondary)
        }
    }
}


struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(message: "Get started\nnow by adding a new\npersonal record")
    }
}

