//
//  Exercise.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit

struct PersonalRecord: Hashable {
    var name: String
    var date: Date
    var personalRecord: Double
    var goal: TimeInterval
}

enum ExerciseRecordKeys: String {
    case type = "Exercise"
    case name
    case date
    case personalRecord
    case goal
}


extension PersonalRecord {
    var record: CKRecord {
        let record = CKRecord(recordType: ExerciseRecordKeys.type.rawValue)
        record[ExerciseRecordKeys.name.rawValue] = name
        record[ExerciseRecordKeys.date.rawValue] = date
        record[ExerciseRecordKeys.personalRecord.rawValue] = personalRecord
        record[ExerciseRecordKeys.goal.rawValue] = goal
        return record
    }
}
