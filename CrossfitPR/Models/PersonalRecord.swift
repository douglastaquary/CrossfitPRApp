//
//  Exercise.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import CoreData

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
    var prName: PRType
    var percentage: Float
    var category: CrossfitLevel?
    var recordMode: RecordMode?
    var maxReps: Int
    var minTime: Int
    var comments: String
    
    init(id: UUID = UUID(), kiloValue: Int32 = 0, poundValue: Int32 = 0, distance: Int32 = 0, recordDate: Date? = nil, prName: PRType = .empty, percentage: Float = 10.0, category: CrossfitLevel? = nil, recordMode: RecordMode? = nil, maxReps: Int32 = 0, minTime: Int32 = 0, comments: String = "") {
        self.id = id
        self.kiloValue = Int(kiloValue)
        self.poundValue = Int(poundValue)
        self.distance = Int(distance)
        self.recordDate = recordDate
        self.prName = prName
        self.percentage = percentage
        self.category = category
        self.recordMode = recordMode
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
        prName: .airSquat,
        percentage: 80
    )
    
    static let recordListMock: [PersonalRecord] = [
        PersonalRecord(
            kiloValue: 38,
            poundValue: 90,
            recordDate: .now,
            prName: .airSquat,
            percentage: 80
        ),
        PersonalRecord(
            kiloValue: 60,
            poundValue: 120,
            recordDate: .now + 3,
            prName: .airSquat,
            percentage: 40
        ),
        PersonalRecord(
            kiloValue: 120,
            poundValue: 240,
            recordDate: .now + 6,
            prName: .airSquat,
            percentage: 80
        )
    ]
}

extension PersonalRecord: Comparable {
    static func < (lhs: PersonalRecord, rhs: PersonalRecord) -> Bool {
        return lhs.id == rhs.id && lhs.prName.rawValue.lowercased() == rhs.prName.rawValue.lowercased()
    }
}


//extension PersonalRecord {
//    var record: CKRecord {
//        let record = CKRecord(recordType: PersonalRecordKeys.type.rawValue)
//        record[PersonalRecordKeys.activity.rawValue] = activity.name.rawValue
//        record[PersonalRecordKeys.date.rawValue] = date
//        record[PersonalRecordKeys.pounds.rawValue] = pounds
//        record[PersonalRecordKeys.goal.rawValue] = goal
//        return record
//    }
//}
//
//extension PersonalRecord {
//    init?(from record: CKRecord) {
//        guard
//            let name = record[PersonalRecordKeys.activity.rawValue] as? String,
//            let date = record[PersonalRecordKeys.date.rawValue] as? Date,
//            let pounds = record[PersonalRecordKeys.pounds.rawValue] as? Double,
//            let goal = record[PersonalRecordKeys.goal.rawValue] as? TimeInterval
//        else { return nil }
//        let activity = Exercise(name: ActivitiesRecordKey(rawValue: name)!)
//        self = .init(activity: activity, date: date, pounds: pounds, goal: goal)
//    }
//}
