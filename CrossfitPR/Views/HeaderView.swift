//
//  HeaderView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) var scheme
    
    var name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name.capitalized)
                    .foregroundColor(.secondary)
                    .font(Font.subheadline)
                    .padding(.leading)
                    .padding(.top, 8)
                Spacer()
            }
            .padding(.bottom, 4)
        }
        .background(scheme == ColorScheme.light ? Color(UIColor.secondarySystemBackground) : .black)
        
    }
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(name: "Sticky header").preferredColorScheme(.dark)
    }
}

