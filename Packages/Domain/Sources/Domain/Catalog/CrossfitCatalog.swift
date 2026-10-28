import Foundation

/// Catálogo estático de exercícios CrossFit (baseline beta — fix-for-beta-version).
public enum CrossfitCatalog {
    public static let allCategories: [WorkoutCategory] = [
        WorkoutCategory(titleKey: "workout.airSquat", title: "Air squat (AS)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.backSquat", title: "Back squat", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.singleUnders", title: "Single Unders", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.clean", title: "Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.jerk", title: "Jerk", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.cluster", title: "Cluster", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.deadlift", title: "Deadlift", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.frontSquat", title: "Front squat", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.toesToBar", title: "Toes to bar (T2B)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.barMuscleUp", title: "Bar Muscle-Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.benchPress", title: "Bench press", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.boxJump", title: "Box jump", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.burpeeOverTheBar", title: "Burpee over the bar", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.butterfly", title: "Butterfly", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.doubleUnders", title: "Double Unders", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.hspu", title: "Handstand push up (HSPU)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.handstandWalk", title: "Handstand walk", type: .maxDistance, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.hangPowerSnatch", title: "Hang Power Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.hangPowerClean", title: "Hang Power Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.kbs", title: "Kettlebell swing (KBS)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.ohs", title: "Overhead Squat (OHS)", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.pistol", title: "Pistol", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.pistolSquat", title: "Pistol Squat", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.powerSnatch", title: "Power Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.powerClean", title: "Power Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.pullUp", title: "Pull Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.pullUpChestToBar", title: "Pull Up (Chest To Bar)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.pullUpStrict", title: "Pull Up (Strict)", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.pushJerk", title: "Push Jerk", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.pushPress", title: "Push Press", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.pushUp", title: "Push Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.ringMuscleUps", title: "Ring Muscle-Ups", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.ringDips", title: "Ring dips", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.ringRow", title: "Ring Row", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.snatch", title: "Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.squatClean", title: "Squat Clean", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.squatSnatch", title: "Squat Snatch", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.shoulderPress", title: "Shoulder Press", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.sitUp", title: "Sit Up", type: .maxRepetition, group: .gymnastic),
        WorkoutCategory(titleKey: "workout.run", title: "Run", type: .maxDistance, group: .endurance),
        WorkoutCategory(titleKey: "workout.row", title: "Row", type: .maxDistance, group: .endurance),
        WorkoutCategory(titleKey: "workout.bike", title: "Bike", type: .maxDistance, group: .endurance),
        WorkoutCategory(titleKey: "workout.sumoDeadlift", title: "Sumo Deadlift", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.sdhp", title: "Sumo Deadlift High Pull (SDHP)", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.thruster", title: "Thruster", type: .maxWeight, group: .barbell),
        WorkoutCategory(titleKey: "workout.wallBall", title: "Wall Ball", type: .maxRepetition, group: .gymnastic),
    ]

    /// Lookup por nome canônico salvo em PRs (persistência).
    public static func category(forStoredTitle title: String) -> WorkoutCategory? {
        allCategories.first { $0.title == title }
    }

    /// Exercícios selecionáveis no picker legado (ActivityKind).
    public static let selectableExercises: [Exercise] = ActivityKind.allCases
        .filter { $0 != .empty }
        .map { Exercise(kind: $0) }
}
