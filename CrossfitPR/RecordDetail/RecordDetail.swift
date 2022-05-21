//
//  RecordDetail.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 19/04/22.
//

import SwiftUI

struct RecordDetail: View {
    @EnvironmentObject var store: RecordStore
    var recordType: String = ""
    var prName: String = ""

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Form {
                Group {
                    Section("Personal records") {
                        ForEach(store.filteredPrs, id: \.id) { pr in
                            PRView(record: pr)
                        }
                    }
                }
//                Group {
//                    Section("Personal record information") {
//                        HSubtitleView(title: "Weight", subtitle: "\(String(describing: record?.recordValue)) lb")
//                        HSubtitleView(title: "Date", subtitle: "\(String(describing: record?.dateFormatter))")
//                    }
//                }
                Section(header: Text("\(recordType) evolution"), footer: Text("This analysis is based on the PR list of \(recordType) registered in the app. The most recent are the ones in the green band (on the right), the oldest gray and the evolution in yellow")) {
                    LineViewGraph()
                }
            }
        }
        .navigationBarTitle(Text(recordType))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UINavigationBar.appearance().tintColor = .green
        }
        .accentColor(.green)
    }
}

struct RecordDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetail(recordType: "DEADLIFT")
    }
}
