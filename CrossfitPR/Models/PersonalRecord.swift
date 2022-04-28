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

enum ActivitiesRecordKey: String, Codable {
    case airSquat = "AIR SQUAT (AS)"
    case backSquat = "BACK SQUAT"
    case barMuscleUp = "BAR MUSCLE-UP"
    case benchPress = "BENCH PRESS"
    case boxJump = "BOX JUMP (BJ)"
    case burpee = "BURPEE"
    case bob = "BURPEE OVER THE BAR"
    case butterfly = "BUTTERFLY"
    case c2b = "CHEST TO BAR (CTB/C2B)"
    case clean = "CLEAN"
    case cleanJerk = "CLEAN & JERK"
    case cluester = "CLUSTER"
    case deadlift = "DEADLIFT"
    case du = "DOUBLE UNDERS (DU)"
    case frontSquat = "FRONT SQUAT"
    case gto = "GROUND TO OVERHEAD (GTO)"
    case hspu = "HANDSTAND PUSH-UP (HSPU)"
    case handstandWalk = "HANDSTAND WALK"
    case hangSnatchClean = "HANG (SNATCH/CLEAN)"
    case jerk = "JERK"
    case kbs = "KETTLEBELL SWING (KBS)"
    case kipping = "KIPPING"
    case k2e = "KNEES TO ELBOWS (K2E)"
    case lounges = "LUNGES"
    case mobility = "MOBILITY"
    case muscleUp = "MUSCLE-UP (MU)"
    case ohs = "OVER HEAD SQUAT (OHS)"
    case pistolSquat = "PISTOL SQUAT"
    case powerSnatchClean = "POWER (SNATCH/CLEAN)"
    case pullUp = "PULL-UP"
    case pushJerk = "PUSH JERK"
    case pushPress = "PUSH-PRESS"
    case pushUp = "PUSH-UP"
    case rackPosition = "RACK POSITION"
    case ringDips = "RING DIPS"
    case ringRows = "RING ROWS"
    case ropeClimb = "ROPE CLIMB"
    case russianLunge = "RUSSIAN LUNGE"
    case shoulderPress = "SHOULDER PRESS"
    case sitUp = "SIT-UP"
    case snatch = "SNATCH"
    case strictPullUp = "STRICT PULL-UP"
    case squat = "SQUAT = AIR SQUAT (AS)"
    case sumoDeadLift = "SUMO DEADLIFT"
    case sumoDeadLiftHightPull = "SUMO DEADLIFT HIGH PULL (SDHP)"
    case thruster = "THRUSTER"
    case t2b = "TOES TO BAR (T2B)"
    case tgu = "TURKISH GET UP (TGU)"
    case walkingLunges = "WALKING LUNGES"
    case vSitUp = "V-SIT-UP"
    case wallBall = "WALL BALL (WB)"
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
