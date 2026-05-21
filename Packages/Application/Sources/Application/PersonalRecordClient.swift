import Foundation
import Combine
import Domain

/// Cliente de aplicação — orquestra CRUD de PRs (camada Application, não infra).
@MainActor
public final class PersonalRecordClient: ObservableObject {
    private let repository: any PersonalRecordRepository

    @Published public private(set) var records: [PersonalRecord] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var lastError: String?

    public init(repository: any PersonalRecordRepository) {
        self.repository = repository
    }

    public func fetchRecords() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            records = try await repository.fetchAll()
        } catch {
            lastError = PersonalRecordClientMessages.message(for: error, operation: .fetch)
        }
    }

    public func save(_ record: PersonalRecord) async -> Bool {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            let saved = try await repository.save(record)
            if let index = records.firstIndex(where: { $0.id == saved.id }) {
                records[index] = saved
            } else {
                records.insert(saved, at: 0)
            }
            records.sort { $0.date > $1.date }
            return true
        } catch {
            lastError = PersonalRecordClientMessages.message(for: error, operation: .save)
            return false
        }
    }

    public func delete(_ record: PersonalRecord) async {
        do {
            try await repository.delete(record)
            records.removeAll { $0.id == record.id }
        } catch {
            lastError = PersonalRecordClientMessages.message(for: error, operation: .delete)
        }
    }
}
