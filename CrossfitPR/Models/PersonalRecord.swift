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


struct Teste: Codable {
    var id: UUID = UUID()
    var text: String?
}

public struct PersonalRecord: Identifiable, Hashable {
    public var id: UUID
    public var kiloValue: Int
    public var poundValue: Int
    public var distance: Int
    public var recordDate: Date?
    public var prName: String
    public var percentage: Float
    public var category: CrossfitLevel?
    public var recordMode: RecordMode?
    public var group: RecordGroup?
    public var maxReps: Int
    public var minTime: Int
    public var comments: String
    
//    enum CodingKeys: String, CodingKey {
//        case kiloValue
//        case poundValue
//        case distance
//        case recordDate
//        case prName
//        case percentage
//        case category
//        case recordMode
//        case group
//        case maxReps
//        case minTime
//        case comments
//
//    }
//
    init(id: UUID = UUID(), kiloValue: Int32 = 0, poundValue: Int32 = 0, distance: Int32 = 0, recordDate: Date? = nil, prName: String = "", percentage: Float = 0.0, category: CrossfitLevel? = nil, recordMode: RecordMode? = nil, group: RecordGroup? = nil, maxReps: Int32 = 0, minTime: Int32 = 0, comments: String = "") {
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
    public static func < (lhs: PersonalRecord, rhs: PersonalRecord) -> Bool {
        return lhs.id == rhs.id && lhs.prName.lowercased() == rhs.prName.lowercased()
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
