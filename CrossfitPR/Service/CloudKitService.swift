//
//  CloudKitService.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import CloudKit
import Combine
import os


@MainActor
class CloudKitService {
    private let cancellable: Cancellable
    private var defaults: UserDefaults = .standard
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    
    //TODO: Search about this issues
    private var unsafeNonisolated: Bool = false
    private static let logger = Logger(
        subsystem: "com.douglast.crossfitPR",
        category: String(describing: CloudKitService.self)
    )
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    // https://forums.swift.org/t/using-mainactor-values-in-initializer-default-arguments/52694/2
    nonisolated init(unsafeNonisolated: Bool) {
        self.unsafeNonisolated = unsafeNonisolated
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

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
    
    func fetchUserSession() async throws -> [UserSession] {
        let predicate = NSPredicate(
            value: true
        )

        let query = CKQuery(
            recordType: UserSessionRecordKeys.type.rawValue,
            predicate: predicate
        )

        //query.sortDescriptors = [.init(key: UserSessionRecordKeys.isPro.rawValue, ascending: true)]

        let result = try await CKContainer.default().privateCloudDatabase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(UserSession.init)
    }
}
