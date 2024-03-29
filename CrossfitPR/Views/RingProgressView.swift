//
//  ProgressView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI

struct RingProgressView: View {
    @State var progressValue: Float = 0.0
    
    var body: some View {
        ProgressBar(progress: self.$progressValue)
            .frame(width: 48.0, height: 48.0)
            .padding()
            //.padding(.leading, 36)
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RingProgressView(progressValue: 0.40)
    }
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: 12)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.footnote)
                            .bold()
        }
        //.background(.clear)
    }
}
