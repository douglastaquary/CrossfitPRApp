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
    @NSManaged public var kiloValue: Int32
    @NSManaged public var poundValue: Int32
    @NSManaged public var distance: Int32
    @NSManaged public var recordDate: Date?
    @NSManaged public var prName: String
    @NSManaged public var percentage: Float
    @NSManaged public var category: String?
    @NSManaged public var recordMode: String?
    @NSManaged public var maxReps: Int32
    @NSManaged public var minTime: Int32
    @NSManaged public var comments: String
    
    var recordPound: Int {
        get { return Int(poundValue) }
        set { poundValue = Int32(newValue) }
    }
    
    var recordKilo : Int {
        get { return Int(kiloValue) }
        set { kiloValue = Int32(newValue) }
    }
    
    var maxRepetition : Int {
        get { return Int(maxReps) }
        set { maxReps = Int32(newValue) }
    }
    
    var minimumTime : Int {
        get { return Int(minTime) }
        set { minTime = Int32(newValue) }
    }
    
    var recordDistance : Int {
        get { return Int(distance) }
        set { distance = Int32(newValue) }
    }
    
    var recordType: PRType {
        set {
            prName = newValue.rawValue
        }
        get {
            PRType(rawValue: prName) ?? .empty
        }
    }
    
    var recordModeType: RecordMode {
        set {
            recordMode = newValue.rawValue
        }
        get {
            RecordMode(rawValue: recordMode ?? "") ?? .maxWeight
        }
    }
    
    var categoryType: CrossfitLevel {
        get { CrossfitLevel(rawValue: category ?? CrossfitLevel.rx.rawValue) ?? .rx }
        set { category = newValue.rawValue }
    }
    
    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: recordDate ?? .now)
    }
    
}

extension PR : Identifiable {}

