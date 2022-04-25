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
    @NSManaged public var recordValue: Int32
    @NSManaged public var recordDate: Date?
    @NSManaged public var prName: String
    @NSManaged public var percentage: Float
    
    
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
    
    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: recordDate ?? .now)
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

