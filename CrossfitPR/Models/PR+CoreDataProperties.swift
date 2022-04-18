//
//  Order+CoreDataProperties.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/04/22.
//

import Foundation
import CoreData

extension PR {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PR> {
        return NSFetchRequest<PR>(entityName: "PR")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var recordValue: Double
    @NSManaged public var recordDate: Date
    @NSManaged public var prName: String
    
    var recordType: PRType {
        set {
            prName = newValue.rawValue
        }
        get {
            PRType(rawValue: prName) ?? .empty
        }
    }
}

extension PR : Identifiable {}

enum PRType: String {
    case airSquat = "AIR SQUAT (AS)"
    case backSquat = "BACK SQUAT"
    case barMuscleUp = "BAR MUSCLE-UP"
    case benchPress = "BENCH PRESS"
    case boxJump = "BOX JUMP (BJ)"
    case burpee = "BURPEE"
    case empty = ""
}

