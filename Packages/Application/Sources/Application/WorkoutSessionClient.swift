import Foundation
import Combine
import Domain

/// Client MV — sessões WOD (CPR-012).
@MainActor
public final class WorkoutSessionClient: ObservableObject {
    private let repository: any WorkoutSessionRepository

    @Published public private(set) var sessions: [CrossFitWorkoutSession] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var lastError: String?

    public init(repository: any WorkoutSessionRepository) {
        self.repository = repository
    }

    public var latestSession: CrossFitWorkoutSession? {
        sessions.first
    }

    public func fetchSessions() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            sessions = try await repository.fetchAll()
        } catch {
            lastError = error.localizedDescription
        }
    }

    public func save(_ session: CrossFitWorkoutSession) async -> Bool {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            let saved = try await repository.save(session)
            if let index = sessions.firstIndex(where: { $0.id == saved.id }) {
                sessions[index] = saved
            } else {
                sessions.insert(saved, at: 0)
            }
            sessions.sort { $0.date > $1.date }
            return true
        } catch {
            lastError = error.localizedDescription
            return false
        }
    }

    public func replaceAll(with newSessions: [CrossFitWorkoutSession]) async {
        sessions = []
        for session in newSessions {
            _ = await save(session)
        }
    }
}
