//
//  RecordDetail.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 19/04/22.
//

import SwiftUI

struct RecordDetail: View {
    var record: PR
    
    var body: some View {
        VStack {
            ProgressView(progressValue: record.percentage/100)
            Spacer()
            Form {
                Group {
                    Section("Record information") {
                        HSubtitleView(title: "Personal record", subtitle: "\(record.recordValue) lb")
                        HSubtitleView(title: "Date", subtitle: "\(record.dateFormatter)")
                    }
                }
            }
        }
        .navigationBarTitle(Text(record.prName))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecordDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetail(record: PersistenceController.prMock)
    }
}

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


struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: 12)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                            .font(.largeTitle)
                            .bold()
        }
    }
}


struct ProgressView: View {
    @State var progressValue: Float = 0.0
    
    var body: some View {
        VStack {
            ProgressBar(progress: self.$progressValue)
                .frame(width: 250, height: 250.0)
                .padding(40.0)
            Spacer()
        }
        .padding(.top, 36)
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(progressValue: 0.40)
    }
}
