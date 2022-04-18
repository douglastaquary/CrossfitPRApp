//
//  CloudKitService.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import CloudKit
import os

final class CloudKitService {
    private static let logger = Logger(
        subsystem: "com.douglast.crossfitPR",
        category: String(describing: CloudKitService.self)
    )

    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
}

extension CloudKitService {
    func save(_ record: CKRecord) async throws {
        do {
            try await CKContainer.default().privateCloudDatabase.save(record)
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    func fetchFastingRecords() async throws -> [PersonalRecord] {
//        let predicate = NSPredicate(
//            value: true
//        )
//
//        let query = CKQuery(
//            recordType: PersonalRecordKeys.type.rawValue,
//            predicate: predicate
//        )
//
//        query.sortDescriptors = [.init(key: PersonalRecordKeys.date.rawValue, ascending: true)]
//
//        let result = try await CKContainer.default().privateCloudDatabase.records(matching: query)
//        let records = result.matchResults.compactMap { try? $0.1.get() }
        return []//records.compactMap(PersonalRecord.init)
    }
}
