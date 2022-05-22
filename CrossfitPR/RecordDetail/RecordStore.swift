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
        subsystem: "com.dabtlab.crossfitprapp",
        category: String(describing: RecordStore.self)
    )

    private var records: FetchedResults<PR>
    private var recordType: String = ""
    init(records: FetchedResults<PR>, recordType: String = "") {
        self.records = records
        self.recordType = recordType
        
    }
    
    var record: PR {
        getMaxRecord(prs: filteredPrs)
    }
    
    var filteredPrs: [PR] {
        records.filter { $0.prName.contains(recordType) }.sorted()
    }
    
    private func getMaxRecord(prs: [PR]) -> PR {
        let max: Int = prs.map { $0.prValue }.max() ?? 0
        let biggestPr = prs.filter { $0.prValue == max }.first ?? PersistenceController.emptyRecord
        return biggestPr
    }
}
