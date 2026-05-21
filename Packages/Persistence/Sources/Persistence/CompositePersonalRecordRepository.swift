import Foundation
import Domain

/// Repositório composto — persistência local + sync best-effort com CloudKit.
public actor CompositePersonalRecordRepository: PersonalRecordRepository {
    private let local: LocalPersonalRecordRepository
    private let remote: CloudKitPersonalRecordRepository

    public init(
        local: LocalPersonalRecordRepository,
        remote: CloudKitPersonalRecordRepository
    ) {
        self.local = local
        self.remote = remote
    }

    public func save(_ record: PersonalRecord) async throws -> PersonalRecord {
        let saved = try await local.save(record)
        do {
            _ = try await remote.save(saved)
        } catch {
            // Offline-first: falha de sync não impede persistência local.
        }
        return saved
    }

    public func fetchAll() async throws -> [PersonalRecord] {
        let localRecords = try await local.fetchAll()
        if !localRecords.isEmpty {
            return localRecords
        }

        do {
            let remoteRecords = try await remote.fetchAll()
            for record in remoteRecords {
                _ = try? await local.save(record)
            }
            return remoteRecords
        } catch {
            return localRecords
        }
    }

    public func delete(_ record: PersonalRecord) async throws {
        try await local.delete(record)
        try? await remote.delete(record)
    }
}

public enum PersistenceFactory {
    public static func makeRepository(inMemory: Bool = false) -> PersonalRecordRepository {
        let local: LocalPersonalRecordRepository
        if inMemory {
            local = LocalPersonalRecordRepository.inMemory()
        } else if let defaultLocal = try? LocalPersonalRecordRepository.makeDefault() {
            local = defaultLocal
        } else {
            local = LocalPersonalRecordRepository.inMemory()
        }

        return CompositePersonalRecordRepository(
            local: local,
            remote: CloudKitPersonalRecordRepository()
        )
    }
}
