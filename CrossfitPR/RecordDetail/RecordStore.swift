//
//  RecordStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 11/05/22.
//

import Foundation
import SwiftUI
import os

@MainActor final class RecordStore: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.aaplab.crossfitprapp",
        category: String(describing: RecordStore.self)
    )

    private var records: FetchedResults<PR>
    private var recordType: String = ""
    init(records: FetchedResults<PR>, recordType: String = "") {
        self.records = records
        self.recordType = recordType
        
    }
    
    var filteredPrs: [PR] {
        records.filter { $0.prName.contains(recordType) }.sorted()
    }
}
