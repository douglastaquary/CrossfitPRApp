//
//  MaxRecordItem.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/02/23.
//

import SwiftUI

struct MaxRecordItem: View {
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "bolt.batteryblock.fill")
                Text("weight")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .lineLimit(0)
            }
            Spacer()
            Text("1")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1))
        
        
        
    }
        
}

struct MaxRecordItem_Previews: PreviewProvider {
    static var previews: some View {
        MaxRecordItem()
    }
}
