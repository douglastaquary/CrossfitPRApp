//
//  Order+CoreDataProperties.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/04/22.
//

import Foundation
import CoreData

enum CrossfitPrescribed: String, CaseIterable {
    case rx = "RX"
    case scale = "Scale"
    case fitness = "Fitness"
}

extension PR {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PR> {
        return NSFetchRequest<PR>(entityName: "PR")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var recordValue: Int32
    @NSManaged public var recordDate: Date?
    @NSManaged public var prName: String
    @NSManaged public var percentage: Float
    @NSManaged public var category: String?
    
    var prValue : Int {
        get { return Int(recordValue) }
        set { recordValue = Int32(newValue) }
    }
    
    var recordType: PRType {
        set {
            prName = newValue.rawValue
        }
        get {
            PRType(rawValue: prName) ?? .empty
        }
    }
    
    var categoryType: CrossfitPrescribed {
        get { CrossfitPrescribed(rawValue: category ?? CrossfitPrescribed.rx.rawValue) ?? .rx }
        set { category = newValue.rawValue }
    }
    
    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: recordDate ?? .now)
    }
    
}

extension PR : Identifiable {}

enum PRType: String {
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
    
}

