import Foundation

/// Entidade principal — registro de PR (Personal Record) de um exercício (REASONS E).
public struct PersonalRecord: Identifiable, Hashable, Sendable, Codable {
    public var id: UUID
    public var exercise: Exercise
    public var date: Date
    /// Peso levantado em libras (lb).
    public var pounds: Double
    /// Meta de tempo associada ao PR, em segundos.
    public var goalDuration: TimeInterval

    public init(
        id: UUID = UUID(),
        exercise: Exercise,
        date: Date,
        pounds: Double,
        goalDuration: TimeInterval
    ) {
        self.id = id
        self.exercise = exercise
        self.date = date
        self.pounds = pounds
        self.goalDuration = goalDuration
    }
}

public extension PersonalRecord {
    /// PR mais recente para o mesmo exercício?
    func isImprovement(over previousBest: PersonalRecord?) -> Bool {
        guard let previousBest else { return true }
        guard exercise.kind == previousBest.exercise.kind else { return false }
        return pounds > previousBest.pounds
    }
}
