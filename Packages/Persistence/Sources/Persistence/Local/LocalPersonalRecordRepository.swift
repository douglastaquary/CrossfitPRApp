import Foundation
import Domain

/// Repositório local via JSON — fonte de verdade offline (compatível com iOS 16+).
public actor LocalPersonalRecordRepository: PersonalRecordRepository {
    private enum StorageMode: Sendable {
        case file(URL)
        case inMemory
    }

    private let storageMode: StorageMode
    private var records: [PersonalRecord] = []
    private var isLoaded = false

    private init(storageMode: StorageMode) {
        self.storageMode = storageMode
    }

    public init(fileURL: URL) {
        self.storageMode = .file(fileURL)
    }

    public static func makeDefault() throws -> LocalPersonalRecordRepository {
        let base = try applicationSupportDirectory()
        let fileURL = base.appendingPathComponent("personal_records.json")
        return LocalPersonalRecordRepository(storageMode: .file(fileURL))
    }

    public static func inMemory() -> LocalPersonalRecordRepository {
        LocalPersonalRecordRepository(storageMode: .inMemory)
    }

    public func save(_ record: PersonalRecord) async throws -> PersonalRecord {
        try await ensureLoaded()
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
        } else {
            records.append(record)
        }
        records.sort { $0.date > $1.date }
        try persistIfNeeded()
        return record
    }

    public func fetchAll() async throws -> [PersonalRecord] {
        try await ensureLoaded()
        return records
    }

    public func delete(_ record: PersonalRecord) async throws {
        try await ensureLoaded()
        records.removeAll { $0.id == record.id }
        try persistIfNeeded()
    }

    private func ensureLoaded() async throws {
        guard !isLoaded else { return }
        defer { isLoaded = true }

        guard case .file(let fileURL) = storageMode else { return }

        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        let data = try Data(contentsOf: fileURL)
        records = try JSONDecoder().decode([PersonalRecord].self, from: data)
        records.sort { $0.date > $1.date }
    }

    private func persistIfNeeded() throws {
        guard case .file(let fileURL) = storageMode else { return }

        let directory = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(records)
        try data.write(to: fileURL, options: .atomic)
    }

    private static func applicationSupportDirectory() throws -> URL {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw LocalPersistenceError.applicationSupportUnavailable
        }
        return base.appendingPathComponent("CrossfitPR", isDirectory: true)
    }
}

public enum LocalPersistenceError: Error, Sendable {
    case applicationSupportUnavailable
}
