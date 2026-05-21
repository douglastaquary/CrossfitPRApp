import CloudKit
import Domain
import os

/// Adaptador CloudKit — sincronização com iCloud (Infrastructure Layer).
public actor CloudKitPersonalRecordRepository: PersonalRecordRepository {
    private static let logger = Logger(
        subsystem: "com.douglast.CrossfitPR",
        category: "CloudKitPersonalRecordRepository"
    )

    private let container: CKContainer
    private let database: CKDatabase

    public init(container: CKContainer = .default()) {
        self.container = container
        self.database = container.privateCloudDatabase
    }

    public func checkAccountStatus() async throws -> CKAccountStatus {
        try await container.accountStatus()
    }

    public func save(_ record: PersonalRecord) async throws -> PersonalRecord {
        let ckRecord = record.makeCloudKitRecord(existingRecordName: nil)
        _ = try await database.save(ckRecord)
        return record
    }

    public func fetchAll() async throws -> [PersonalRecord] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(
            recordType: PersonalRecordField.recordType.rawValue,
            predicate: predicate
        )
        query.sortDescriptors = [
            NSSortDescriptor(key: PersonalRecordField.date.rawValue, ascending: false),
        ]

        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.compactMap(PersonalRecord.init(cloudKitRecord:))
    }

    public func delete(_ record: PersonalRecord) async throws {
        let ckRecordID = CKRecord.ID(recordName: record.id.uuidString)
        _ = try await database.deleteRecord(withID: ckRecordID)
    }
}

public extension PersonalRecord {
    func makeCloudKitRecord(existingRecordName: String?) -> CKRecord {
        let recordID = CKRecord.ID(recordName: existingRecordName ?? id.uuidString)
        let ckRecord = CKRecord(
            recordType: PersonalRecordField.recordType.rawValue,
            recordID: recordID
        )
        ckRecord[PersonalRecordField.activity.rawValue] = prName.isEmpty ? exercise.kind.rawValue : prName
        ckRecord[PersonalRecordField.date.rawValue] = recordDate
        ckRecord[PersonalRecordField.pounds.rawValue] = pounds
        ckRecord[PersonalRecordField.goalDuration.rawValue] = goalDuration
        return ckRecord
    }

    init?(cloudKitRecord record: CKRecord) {
        guard
            let activityRaw = record[PersonalRecordField.activity.rawValue] as? String,
            let date = record[PersonalRecordField.date.rawValue] as? Date,
            let pounds = record[PersonalRecordField.pounds.rawValue] as? Double,
            let goalDuration = record[PersonalRecordField.goalDuration.rawValue] as? TimeInterval
        else {
            return nil
        }

        let id = UUID(uuidString: record.recordID.recordName) ?? UUID()
        self.init(
            id: id,
            prName: activityRaw,
            recordDate: date,
            kiloValue: Int(pounds * 0.453592),
            poundValue: Int(pounds),
            recordMode: .maxWeight,
            group: .barbell,
            minTime: Int(goalDuration)
        )
    }
}
