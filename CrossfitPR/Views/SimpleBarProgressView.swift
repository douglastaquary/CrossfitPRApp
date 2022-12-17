//
//  SimpleBarProgressView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/12/22.
//

import SwiftUI

struct SimpleBarProgressView: View {
    let progress: CGFloat
    
    private let bgColor = Color.green.opacity(0.2)
    private let fillColor = Color.green
    
    var body: some View {
        VStack {
            GeometryReader { bounds in
                Capsule(style: .circular)
                    .fill(bgColor)
                    .overlay {
                        HStack {
                            Capsule(style: .circular)
                                .fill(fillColor)
                                .frame(width: bounds.size.width * progress)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .clipShape(Capsule(style: .circular))
            }
            .frame(height: 15)
        }
    }
}


struct SimpleBarProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleBarProgressView(progress: 0.3)
    }
    
}

struct RankingView: View {
    @State var record: PersonalRecord
    @State var measure: MeasureTrackingMode
//    let title: String
//    let progress: CGFloat
    @State var legendText: String = ""
    
    private let bgColor = Color.green.opacity(0.2)
    private let fillColor = Color.green
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(record.prName).font(.headline)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(record.marketTexts.result).font(.headline)
                    HStack {
                        Image(systemName: "arrow.up.forward").foregroundColor(.green)
                        Text(record.marketTexts.measure)
                    }
                }
            }
            
            GeometryReader { bounds in
                Capsule(style: .circular)
                    .fill(bgColor)
                    .overlay {
                        HStack {
                            Capsule(style: .circular)
                                .fill(fillColor)
                                .frame(width: bounds.size.width * 4.5/100)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .clipShape(Capsule(style: .circular))
            }
            .frame(height: 15)
            
            HStack {
                Text(legendText)
                    .font(.caption)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
            }
        }
        
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(
            record: PersonalRecord.recordMock,
            measure: .pounds,
            legendText: "lkjshagflJKLSKADJHLAkjsdhlsakjDHLaskjdhlasKJDHSALkdjhsalKDJAHSLDKJSAhdlksajDHLAKSJDHl"
        )
    }
}

