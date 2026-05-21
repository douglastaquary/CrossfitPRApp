import Foundation

/// Catálogo estático de exercícios disponíveis no bounded context de PRs.
public enum CrossfitCatalog {
    public static let selectableExercises: [Exercise] = ActivityKind.allCases
        .filter { $0 != .empty }
        .map { Exercise(kind: $0) }
}
