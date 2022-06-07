//
//  Exercise.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import CoreData
import SwiftUICharts

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

enum ActivitiesRecordKey: String, Codable, CaseIterable, Comparable {
    static func < (lhs: ActivitiesRecordKey, rhs: ActivitiesRecordKey) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case airSquat = "Air squat (AS)"
    case backSquat = "Back squat"
    case barMuscleUp = "Bar muscle-up"
    case benchPress = "Bench press"
    case boxJump = "Box jump (BJ)"
    case burpee = "Burpee"
    case bob = "Burpee over the bar"
    case butterfly = "Butterfly"
    case c2b = "Chest to bar (C2B)"
    case clean = "CLEAN"
    case cleanJerk = "Clean & Jerk"
    case cluester = "Cluster"
    case deadlift = "Deadlift"
    case du = "Double unders (DU)"
    case frontSquat = "Front squat"
    case gto = "Ground to overhead (GTO)"
    case hspu = "Handstand push-up (HSPU)"
    case handstandWalk = "Handstand walk"
    case hangSnatchClean = "Hang (SNATCH/CLEAN)"
    case jerk = "Jerk"
    case kbs = "Kettlebell swing (KBS)"
    case kipping = "Kipping"
    case k2e = "Knees to elbows (K2E)"
    case lounges = "Lunges"
    case mobility = "Mobility"
    case muscleUp = "Muscle-up (MU)"
    case ohs = "Over head squat (OHS)"
    case pistolSquat = "Pistol squat"
    case powerSnatchClean = "Power (SNATCH/CLEAN)"
    case pullUp = "Pull-up"
    case pushJerk = "Push jerk"
    case pushPress = "Push-press"
    case pushUp = "Push-up"
    case rackPosition = "Rack position"
    case ringDips = "Ring dips"
    case ringRows = "Ring rows"
    case ropeClimb = "Rope climb"
    case russianLunge = "Russian lunge"
    case shoulderPress = "Shoulder press"
    case sitUp = "Sit-up"
    case snatch = "Snatch"
    case strictPullUp = "Strict pull-up"
    case sumoDeadLift = "Sumo deadlift"
    case sumoDeadLiftHightPull = "Sumo deadlift high pull (SDHP)"
    case thruster = "Thruster"
    case t2b = "Toes to bar (T2B)"
    case tgu = "Turkish get up (TGU)"
    case walkingLunges = "Walking lunges"
    case vSitUp = "V-sit-up"
    case wallBall = "Wall ball (WB)"
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
