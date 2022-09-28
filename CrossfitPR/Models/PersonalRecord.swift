//
//  Exercise.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import CoreData

enum UserSessionRecordKeys: String {
    case type = "UserSessionRecord"
    case name
    case isPro
}

struct UserSession: Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var isPro: Bool
}

enum PersonalRecordKeys: String {
    case type = "PersonalRecord"
    case activity
    case date
    case pounds
    case goal
}

struct PersonalRecord: Identifiable, Hashable {
    var id: UUID
    var kiloValue: Int
    var poundValue: Int
    var distance: Int
    var recordDate: Date?
    var prName: String
    var percentage: Float
    var category: CrossfitLevel?
    var recordMode: RecordMode?
    var group: RecordGroup?
    var maxReps: Int
    var minTime: Int
    var comments: String
    
    init(id: UUID = UUID(), kiloValue: Int32 = 0, poundValue: Int32 = 0, distance: Int32 = 0, recordDate: Date? = nil, prName: String = "", percentage: Float = 10.0, category: CrossfitLevel? = nil, recordMode: RecordMode? = nil, group: RecordGroup? = nil, maxReps: Int32 = 0, minTime: Int32 = 0, comments: String = "") {
        self.id = id
        self.kiloValue = Int(kiloValue)
        self.poundValue = Int(poundValue)
        self.distance = Int(distance)
        self.recordDate = recordDate
        self.prName = prName
        self.percentage = percentage
        self.category = category
        self.recordMode = recordMode
        self.group = group
        self.maxReps = Int(maxReps)
        self.minTime = Int(minTime)
        self.comments = comments
    }

    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: recordDate ?? .now)
    }
    
    
    static let recordMock: PersonalRecord = PersonalRecord(
        kiloValue: 38,
        poundValue: 90,
        prName: "Air Squat",
        percentage: 80
    )
    
    static let recordListMock: [PersonalRecord] = [
        PersonalRecord(
            kiloValue: 38,
            poundValue: 90,
            recordDate: .now,
            prName: "Air Squat",
            percentage: 80
        ),
        PersonalRecord(
            kiloValue: 60,
            poundValue: 120,
            recordDate: .now + 3,
            prName: "Air Squat",
            percentage: 40
        ),
        PersonalRecord(
            kiloValue: 120,
            poundValue: 240,
            recordDate: .now + 6,
            prName: "Air Squat",
            percentage: 80
        )
    ]
}

extension PersonalRecord: Comparable {
    static func < (lhs: PersonalRecord, rhs: PersonalRecord) -> Bool {
        return lhs.id == rhs.id && lhs.prName.lowercased() == rhs.prName.lowercased()
    }
}

// UserRecord extensions

extension UserSession: Comparable {
    static func < (lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.id == rhs.id
    }
}


extension UserSession {
    var record: CKRecord {
        let record = CKRecord(recordType: UserSessionRecordKeys.type.rawValue)
        record[UserSessionRecordKeys.name.rawValue] = name
        record[UserSessionRecordKeys.isPro.rawValue] = isPro
        return record
    }
}

extension UserSession {
    init?(from record: CKRecord) {
        guard let isPro = record[UserSessionRecordKeys.isPro.rawValue] as? Bool,
        let name = record[UserSessionRecordKeys.isPro.rawValue] as? String else {
            return nil
        }
        self = .init(name: name, isPro: isPro)
    }
}
