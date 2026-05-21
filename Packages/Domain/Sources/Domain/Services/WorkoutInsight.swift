import Foundation

/// Insight gerado a partir dos dados de treino (REASONS E — Entities).
public struct WorkoutInsight: Identifiable, Hashable, Sendable {
    public enum Category: String, Sendable {
        case summary
        case trend
        case workoutEngine
        case recommendation
        case proTeaser
    }

    public var id: UUID
    public var title: String
    public var message: String
    public var category: Category
    public var requiresPro: Bool
    public var relatedExercise: ActivityKind?

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        category: Category,
        requiresPro: Bool = false,
        relatedExercise: ActivityKind? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.category = category
        self.requiresPro = requiresPro
        self.relatedExercise = relatedExercise
    }
}
