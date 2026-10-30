import Foundation

/// Port — persistência de sessões WOD (CPR-012).
public protocol WorkoutSessionRepository: Sendable {
    func save(_ session: CrossFitWorkoutSession) async throws -> CrossFitWorkoutSession
    func fetchAll() async throws -> [CrossFitWorkoutSession]
    func delete(_ session: CrossFitWorkoutSession) async throws
}

public enum WorkoutSessionRepositoryError: Error, Sendable, Equatable {
    case notFound
    case invalidData
}
