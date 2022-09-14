//
//  Category.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 22/05/22.
//

import Foundation

enum RecordGroup: String {
    case barbell = "Barbell"
    case gymnastic = "Gymnastic"
    case endurance = "Endurance"
}

struct Category: Identifiable, Comparable, Hashable {
    let id = UUID()
    var title: String
    var type: RecordMode
    var group: RecordGroup = .barbell
    
    static let list: [Category] = [
        Category(title: "Air squat (AS)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Back squat", type: .maxWeight, group: .barbell),
        Category(title: "Single Unders", type: .maxRepetition, group: .gymnastic),
        Category(title: "Clean", type: .maxWeight, group: .barbell),
        Category(title: "Clean & Jerk", type: .maxWeight, group: .barbell),
        Category(title: "Cluster", type: .maxWeight, group: .barbell),
        Category(title: "Deadlift", type: .maxWeight, group: .barbell),
        Category(title: "Front squat", type: .maxWeight, group: .barbell),
        Category(title: "Toes to bar (T2B)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Bar Muscle-Up", type: .maxRepetition, group: .gymnastic),
        Category(title: "Bench press", type: .maxWeight, group: .barbell),
        Category(title: "Box jump", type: .maxRepetition, group: .gymnastic),
        Category(title: "Burpee over the bar", type: .maxRepetition, group: .gymnastic),
        Category(title: "Butterfly", type: .maxRepetition, group: .gymnastic),
        Category(title: "Double Unders", type: .maxRepetition, group: .gymnastic),
        Category(title: "Handstand push up (HSPU)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Handstand walk", type: .maxDistance, group: .gymnastic),
        Category(title: "Hang Power Snatch", type: .maxWeight, group: .barbell),
        Category(title: "Hang Power Clean", type: .maxWeight, group: .barbell),
        Category(title: "Kettlebell swing (KBS)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Bar Muscle up (BMU)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Overhead Squat (OHS)", type: .maxWeight, group: .barbell),
        Category(title: "Pistol", type: .maxRepetition, group: .gymnastic),
        Category(title: "Pistol Squat", type: .maxRepetition, group: .gymnastic),
        Category(title: "Power Snatch", type: .maxWeight, group: .barbell),
        Category(title: "Power Clean", type: .maxWeight, group: .barbell),
        Category(title: "Pull Up", type: .maxRepetition, group: .gymnastic),
        Category(title: "Pull Up (Chest To Bar)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Pull Up (Strict)", type: .maxRepetition, group: .gymnastic),
        Category(title: "Push Jerk", type: .maxWeight, group: .barbell),
        Category(title: "Push Press", type: .maxWeight, group: .barbell),
        Category(title: "Push Up", type: .maxRepetition, group: .gymnastic),
        Category(title: "Ring Muscle-Ups", type: .maxRepetition, group: .gymnastic),
        Category(title: "Ring dips", type: .maxRepetition, group: .gymnastic),
        Category(title: "Ring Row", type: .maxRepetition, group: .gymnastic),
        Category(title: "Snatch", type: .maxWeight, group: .barbell),
        Category(title: "Squat Clean", type: .maxWeight, group: .barbell),
        Category(title: "Squat Snatch", type: .maxWeight, group: .barbell),
        Category(title: "Shoulder Press", type: .maxWeight, group: .barbell),
        Category(title: "Sit Up", type: .maxRepetition, group: .gymnastic),
        Category(title: "Run", type: .maxRepetition, group: .endurance),
        Category(title: "Row", type: .maxDistance, group: .endurance),
        Category(title: "Bike", type: .maxDistance, group: .endurance),
        Category(title: "Sumo Deadlift", type: .maxWeight, group: .barbell),
        Category(title: "Sumo Deadlift High Pull (SDHP)", type: .maxWeight, group: .barbell),
        Category(title: "Thruster", type: .maxWeight, group: .barbell),
        Category(title: "Wall Ball", type: .maxRepetition, group: .gymnastic),
    ]
}

extension Category {
    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.title < rhs.title
    }
}
