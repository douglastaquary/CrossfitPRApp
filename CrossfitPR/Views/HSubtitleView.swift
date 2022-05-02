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
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(subtitle)
                .bold()
        }
    }
}

struct EmptyView: View {
    @State var message: String
    var body: some View {
        VStack {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
}


struct HSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        HSubtitleView(title: "teste", subtitle: "teste")
    }
}
