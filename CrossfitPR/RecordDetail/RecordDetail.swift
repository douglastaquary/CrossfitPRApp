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
                    Section("Record information") {
                        HSubtitleView(title: "Personal record", subtitle: "\(record.recordValue) lb")
                        HSubtitleView(title: "Date", subtitle: "\(record.dateFormatter)")
                    }
                }
                Section("Record evolution") {
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
