import Foundation
import Testing
@testable import Persistence
import Domain

@Suite("Local Personal Record Repository")
struct LocalPersonalRecordRepositoryTests {
    @Test("Persiste e busca PRs em memória")
    func inMemoryCRUD() async throws {
        let repository = LocalPersonalRecordRepository.inMemory()

        let record = PersonalRecord(
            exercise: Exercise(kind: .deadlift),
            date: .now,
            pounds: 225,
            goalDuration: 0
        )

        _ = try await repository.save(record)
        let fetched = try await repository.fetchAll()

        #expect(fetched.count == 1)
        #expect(fetched.first?.exercise.kind == .deadlift)
    }

    @Test("Round-trip JSON em arquivo temporário")
    func filePersistenceRoundTrip() async throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let fileURL = directory.appendingPathComponent("personal_records.json")
        let repository = LocalPersonalRecordRepository(fileURL: fileURL)

        let record = PersonalRecord(
            exercise: Exercise(kind: .backSquat),
            date: Date(timeIntervalSince1970: 1_700_000_000),
            pounds: 140,
            goalDuration: 3_600
        )

        _ = try await repository.save(record)

        let reloadedRepository = LocalPersonalRecordRepository(fileURL: fileURL)
        let fetched = try await reloadedRepository.fetchAll()

        #expect(fetched.count == 1)
        #expect(fetched.first?.id == record.id)
        #expect(fetched.first?.pounds == 140)
    }
}

@Suite("CloudKit Record Mapping")
struct CloudKitMappingTests {
    @Test("Mapeia PersonalRecord para campos CloudKit")
    func cloudKitRecordFields() {
        let record = PersonalRecord(
            exercise: Exercise(kind: .benchPress),
            date: .now,
            pounds: 185,
            goalDuration: 1_800
        )

        let ckRecord = record.makeCloudKitRecord(existingRecordName: nil)
        let restored = PersonalRecord(cloudKitRecord: ckRecord)

        #expect(restored?.exercise.kind == .benchPress)
        #expect(restored?.pounds == 185)
    }
}
