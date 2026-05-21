import Foundation

/// Repository port — persistência de PRs (implementado em Persistence).
public protocol PersonalRecordRepository: Sendable {
    func save(_ record: PersonalRecord) async throws -> PersonalRecord
    func fetchAll() async throws -> [PersonalRecord]
    func delete(_ record: PersonalRecord) async throws
}

public enum PersonalRecordRepositoryError: Error, Sendable, Equatable {
    case notFound
    case syncFailed(String)
    case invalidData
}
