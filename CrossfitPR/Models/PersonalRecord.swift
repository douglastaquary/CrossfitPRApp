//
//  Exercise.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import CoreData
import SwiftUI

struct RecordPoint: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var date: String
    var legend: String
    var value: Double
}

extension RecordPoint: Comparable {
    static func < (lhs: RecordPoint, rhs: RecordPoint) -> Bool {
        return lhs.id == rhs.id && lhs.name.lowercased() == rhs.name.lowercased()
    }
}

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
    var recordDate: Date
    var prName: String
    var percentage: Float
    var crossfitLevel: CrossfitLevel?
    var recordMode: RecordMode?
    var group: RecordGroup?
    var maxReps: Int
    var minTime: Int
    var comments: String
    var legend: Color = .green
    var evolutionPercentage: Int = 0
    
    init(id: UUID = UUID(), kiloValue: Int32 = 0, poundValue: Int32 = 0, distance: Int32 = 0, recordDate: Date = Date(), prName: String = "", percentage: Float = 10.0, crossfitLevel: CrossfitLevel? = nil, recordMode: RecordMode? = nil, group: RecordGroup? = nil, maxReps: Int32 = 0, minTime: Int32 = 0, comments: String = "") {
        self.id = id
        self.kiloValue = Int(kiloValue)
        self.poundValue = Int(poundValue)
        self.distance = Int(distance)
        self.recordDate = recordDate
        self.prName = prName
        self.percentage = percentage
        self.crossfitLevel = crossfitLevel
        self.recordMode = recordMode
        self.group = group
        self.maxReps = Int(maxReps)
        self.minTime = Int(minTime)
        self.comments = comments
    }
    
    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: recordDate)
    }
    
    var marketTexts: (value: (pound: String, kilos: String, another: String), measure: String) {
        if let group = group {
            switch group {
            case .barbell:
                return (value: (pound: "\(poundValue.description)lbs", kilos: "\(kiloValue.description)kg", another: ""), measure: "\(percentage)%")
            case .gymnastic:
                return (value: (pound: "", kilos: "", another: ""), measure: "\(maxReps.description)reps")
            case .endurance:
                return (value: (pound: "", kilos: "", another: minTime.description), measure: "\(distance)m")
            }
        }
        return (value: (pound: "", kilos: "", another: ""), measure: "")
    }
    
    static let recordMock: PersonalRecord = PersonalRecord(
        kiloValue: 38,
        poundValue: 90,
        prName: "Air Squat",
        percentage: 80,
        recordMode: .maxWeight,
        group: .barbell
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
    
    static func == (lhs: PersonalRecord, rhs: PersonalRecord) -> Bool {
        return lhs.id == rhs.id && lhs.prName.lowercased() == rhs.prName.lowercased()
    }
    
    static func < (lhs: PersonalRecord, rhs: PersonalRecord) -> Bool {
        return lhs.recordDate < rhs.recordDate
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
