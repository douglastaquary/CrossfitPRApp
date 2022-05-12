//
//  RecordDetail.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 19/04/22.
//

import SwiftUI

struct RecordDetail: View {
    @EnvironmentObject var store: RecordStore
    var record: PR
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Form {
                Group {
                    Section("Record percentage") {
                        ProgressView(progressValue: record.percentage/100)
                    }
                }
                Group {
                    Section("Personal record information") {
                        HSubtitleView(title: "Weight", subtitle: "\(record.recordValue) lb")
                        HSubtitleView(title: "Date", subtitle: "\(record.dateFormatter)")
                    }
                }
                Section(header: Text("\(record.prName) evolution"), footer: Text("This analysis is based on the PR list of \(record.prName) registered in the app. The most recent are the ones in the green band (on the right), the oldest gray and the evolution in yellow")) {
                    LineViewGraph()
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
