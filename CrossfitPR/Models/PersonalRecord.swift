//
//  Exercise.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import CoreData

struct Crossfit {
    
    static let histories: [History] = [
        History(prs: [
            PersonalRecord.init(activity: Exercise(name: .airSquat), date: .now, pounds: 150.0, goal: 36 * 1600),
            PersonalRecord.init(activity: Exercise(name: .airSquat), date: .now, pounds: 300.0, goal: 36 * 1900)
        ]),
        History(prs: [
            PersonalRecord.init(activity: Exercise(name: .barMuscleUp), date: .now, pounds: 250.0, goal: 36 * 1600),
            PersonalRecord.init(activity: Exercise(name: .barMuscleUp), date: .now, pounds: 300.0, goal: 36 * 1600)
        ]),
        History(prs: [
            PersonalRecord.init(activity: Exercise(name: .backSquat), date: .now, pounds: 105.0, goal: 36 * 1600),
            PersonalRecord.init(activity: Exercise(name: .backSquat), date: .now, pounds: 90.0, goal: 36 * 1600)
        ]),
        History(prs: [
            PersonalRecord.init(activity: Exercise(name: .benchPress), date: .now, pounds: 231.0, goal: 36 * 1600),
            PersonalRecord.init(activity: Exercise(name: .benchPress), date: .now, pounds: 90.0, goal: 36 * 1600)
        ])
    ]
    
    static let exercises: [Exercise] = [
        Exercise(name: .airSquat),
        Exercise(name: .backSquat),
        Exercise(name: .benchPress),
        Exercise(name: .boxJump),
        Exercise(name: .barMuscleUp),
        Exercise(name: .burpee),
        Exercise(name: .empty)
    ]
    
    static let barsMock: [Bar] = [
        Bar(id: UUID(), value: 100.3, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 100.3, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 100.3, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 100.3, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 100.3, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 150.0, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 150.0, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 150.0, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 150.0, label: "Air Squat", legend: Legend(color: .yellow, label: "Greater load")),
        Bar(id: UUID(), value: 120.0, label: "Power Snatch", legend: Legend(color: .blue, label: "Average load")),
        Bar(id: UUID(), value: 120.0, label: "Power Snatch", legend: Legend(color: .blue, label: "Average load")),
        Bar(id: UUID(), value: 120.0, label: "Power Snatch", legend: Legend(color: .blue, label: "Average load")),
        Bar(id: UUID(), value: 120.0, label: "Power Snatch", legend: Legend(color: .blue, label: "Average load")),
        Bar(id: UUID(), value: 120.0, label: "Power Snatch", legend: Legend(color: .blue, label: "Average load")),
        Bar(id: UUID(), value: 90.0, label: "T2B", legend: Legend(color: .green, label: "Lower load")),
        Bar(id: UUID(), value: 90.0, label: "T2B", legend: Legend(color: .green, label: "Lower load")),
        Bar(id: UUID(), value: 90.0, label: "T2B", legend: Legend(color: .green, label: "Lower load")),
        Bar(id: UUID(), value: 90.0, label: "T2B", legend: Legend(color: .green, label: "Lower load")),
        Bar(id: UUID(), value: 90.0, label: "T2B", legend: Legend(color: .green, label: "Lower load"))
    ]
}

struct History: Codable, Identifiable {
    public var id = UUID()
    public var prs: [PersonalRecord]
    
    enum CodingKeys: String, CodingKey {
        case prs
    }
}

struct Exercise: Codable {
    public var name: ActivitiesRecordKey
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct PersonalRecord: Codable {
    //var id = UUID()
    var activity: Exercise
    var date: Date
    var pounds: Double
    var goal: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case activity
        case date
        case pounds
        case goal
    }
    
}

enum PersonalRecordKeys: String {
    case type = "PersonalRecord"
    case activity
    case date
    case pounds
    case goal
}

enum ActivitiesRecordKey: String, Codable {
    case airSquat = "AIR SQUAT (AS)"
    case backSquat = "BACK SQUAT"
    case barMuscleUp = "BAR MUSCLE-UP"
    case benchPress = "BENCH PRESS"
    case boxJump = "BOX JUMP (BJ)"
    case burpee = "BURPEE"
    case empty = ""
}


extension PersonalRecord {
    var record: CKRecord {
        let record = CKRecord(recordType: PersonalRecordKeys.type.rawValue)
        record[PersonalRecordKeys.activity.rawValue] = activity.name.rawValue
        record[PersonalRecordKeys.date.rawValue] = date
        record[PersonalRecordKeys.pounds.rawValue] = pounds
        record[PersonalRecordKeys.goal.rawValue] = goal
        return record
    }
}

extension PersonalRecord {
    init?(from record: CKRecord) {
        guard
            let name = record[PersonalRecordKeys.activity.rawValue] as? String,
            let date = record[PersonalRecordKeys.date.rawValue] as? Date,
            let pounds = record[PersonalRecordKeys.pounds.rawValue] as? Double,
            let goal = record[PersonalRecordKeys.goal.rawValue] as? TimeInterval
        else { return nil }
        let activity = Exercise(name: ActivitiesRecordKey(rawValue: name)!)
        self = .init(activity: activity, date: date, pounds: pounds, goal: goal)
    }
}
