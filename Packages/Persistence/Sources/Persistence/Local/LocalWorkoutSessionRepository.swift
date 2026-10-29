import Foundation
import Domain

/// Persistência JSON local de sessões WOD — CPR-012.
public actor LocalWorkoutSessionRepository: WorkoutSessionRepository {
    private enum StorageMode: Sendable {
        case file(URL)
        case inMemory
    }

    private let storageMode: StorageMode
    private var sessions: [CrossFitWorkoutSession] = []
    private var isLoaded = false

    private init(storageMode: StorageMode) {
        self.storageMode = storageMode
    }

    public static func makeDefault() throws -> LocalWorkoutSessionRepository {
        let base = try applicationSupportDirectory()
        let fileURL = base.appendingPathComponent("workout_sessions.json")
        return LocalWorkoutSessionRepository(storageMode: .file(fileURL))
    }

    public static func inMemory() -> LocalWorkoutSessionRepository {
        LocalWorkoutSessionRepository(storageMode: .inMemory)
    }

    public func save(_ session: CrossFitWorkoutSession) async throws -> CrossFitWorkoutSession {
        try await ensureLoaded()
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        sessions.sort { $0.date > $1.date }
        try persistIfNeeded()
        return session
    }

    public func fetchAll() async throws -> [CrossFitWorkoutSession] {
        try await ensureLoaded()
        return sessions
    }

    public func delete(_ session: CrossFitWorkoutSession) async throws {
        try await ensureLoaded()
        sessions.removeAll { $0.id == session.id }
        try persistIfNeeded()
    }

    private func ensureLoaded() async throws {
        guard !isLoaded else { return }
        defer { isLoaded = true }
        guard case .file(let fileURL) = storageMode else { return }
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        let data = try Data(contentsOf: fileURL)
        sessions = try JSONDecoder().decode([CrossFitWorkoutSession].self, from: data)
        sessions.sort { $0.date > $1.date }
    }

    private func persistIfNeeded() throws {
        guard case .file(let fileURL) = storageMode else { return }
        let directory = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(sessions)
        try data.write(to: fileURL, options: .atomic)
    }

    private static func applicationSupportDirectory() throws -> URL {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw LocalPersistenceError.applicationSupportUnavailable
        }
        return base.appendingPathComponent("CrossfitPR", isDirectory: true)
    }
}
