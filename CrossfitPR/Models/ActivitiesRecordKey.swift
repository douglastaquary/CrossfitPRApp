//
//  ActivitiesRecordKey.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 30/07/22.
//

import Foundation

enum ActivitiesRecordKey: String, Codable, CaseIterable, Comparable {
    case airSquat = "Air squat (AS)"
    case backSquat = "Back squat"
    case barMuscleUp = "Bar muscle-up"
    case benchPress = "Bench press"
    case boxJump = "Box jump (BJ)"
    case burpee = "Burpee"
    case bob = "Burpee over the bar"
    case butterfly = "Butterfly"
    case c2b = "Chest to bar (C2B)"
    case clean = "Clean"
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
    
    static func < (lhs: ActivitiesRecordKey, rhs: ActivitiesRecordKey) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
