//
//  CategoryCollectionView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/12/22.
//

import SwiftUI

//figure.cross.training
//figure.strengthtraining.traditional

struct OpaqueActionButton: View {
    @State var imageName: String = ""
    @State var title: String = ""
    @State var completion: (() -> Void) = {  }
    
    var body: some View {
        VStack {
            Button {
                print("Button was tapped")
                self.completion()
            } label: {
                HStack {
                    Image(systemName: imageName)
                        .padding(.leading)
                        .foregroundColor(.green)
                    Text(title)
                        .padding([.bottom, .top, .trailing])
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                        .cornerRadius(12)
                }
                .padding([.trailing, .leading], 64)
                .background(Color.green.opacity(0.15))
                .cornerRadius(10)
            }

        }
    }
}

struct CategoryCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        OpaqueActionButton(imageName: "figure.strengthtraining.traditional", title: "Add new record")
    }
}
