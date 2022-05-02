//
//  PRView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI

struct PRView: View {
    var record: PR
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.prName.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            HStack {
                Text("\(record.prValue) lb")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(record.dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
            }
            Divider()
        }
        .padding(.leading, 16)
    }
}
