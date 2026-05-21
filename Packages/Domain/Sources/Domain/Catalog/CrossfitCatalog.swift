import Foundation

/// Catálogo estático de exercícios CrossFit (baseline beta — fix-for-beta-version).
public enum CrossfitCatalog {
    public static let allCategories: [WorkoutCategory] = [
        WorkoutCategory(title: "Air squat (AS)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Back squat", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Single Unders", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Jerk", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Cluster", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Deadlift", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Front squat", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Toes to bar (T2B)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Bar Muscle-Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Bench press", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Box jump", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Burpee over the bar", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Butterfly", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Double Unders", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Handstand push up (HSPU)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Handstand walk", type: .maxDistance, group: .gymnastic),
        WorkoutCategory(title: "Hang Power Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Hang Power Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Kettlebell swing (KBS)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Overhead Squat (OHS)", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Pistol", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Pistol Squat", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Power Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Power Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Pull Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Pull Up (Chest To Bar)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Pull Up (Strict)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Push Jerk", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Push Press", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Push Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Ring Muscle-Ups", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Ring dips", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Ring Row", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Squat Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Squat Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Shoulder Press", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Sit Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(title: "Run", type: .maxDistance, group: .endurance),
        WorkoutCategory(title: "Row", type: .maxDistance, group: .endurance),
        WorkoutCategory(title: "Bike", type: .maxDistance, group: .endurance),
        WorkoutCategory(title: "Sumo Deadlift", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Sumo Deadlift High Pull (SDHP)", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Thruster", type: .maxWeight, group: .barbell),
        WorkoutCategory(title: "Wall Ball", type: .maxRepetition, group: .gymnastic),
    ]

    /// Exercícios selecionáveis no picker legado (ActivityKind).
    public static let selectableExercises: [Exercise] = ActivityKind.allCases
        .filter { $0 != .empty }
        .map { Exercise(kind: $0) }
}
