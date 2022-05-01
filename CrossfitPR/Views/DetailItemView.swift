//
//  DetailItemView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI

struct DetailItemView: View {
    @State var sectionName: String
    @State var descript: String
    @State var imageName: String
    
    var body: some View {
        VStack {
            HStack {
                Text(sectionName)
                Spacer()
            }
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.secondary)
                Text(descript)
                Spacer()
            }
        }
        
    }
}

struct DetailItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemView(sectionName: "SQUAT", descript: "Air squat", imageName: "")
    }
}
