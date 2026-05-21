import Foundation
import Domain
import Localization

enum PersonalRecordClientMessages {
    static func message(for error: Error, operation: Operation) -> String {
        if let repositoryError = error as? PersonalRecordRepositoryError {
            return repositoryError.localizedMessage
        }

        let nsError = error as NSError
        if nsError.domain == NSCocoaErrorDomain || nsError.domain == "NSPersistentStoreErrorDomain" {
            return operation.persistenceFailureMessage
        }

        return operation.genericFailureMessage
    }

    enum Operation {
        case fetch
        case save
        case delete

        var genericFailureMessage: String {
            switch self {
            case .fetch: return Strings.ErrorCopy.ClientOperation.fetch.generic
            case .save: return Strings.ErrorCopy.ClientOperation.save.generic
            case .delete: return Strings.ErrorCopy.ClientOperation.delete.generic
            }
        }

        var persistenceFailureMessage: String {
            switch self {
            case .fetch: return Strings.ErrorCopy.ClientOperation.fetch.persistence
            case .save: return Strings.ErrorCopy.ClientOperation.save.persistence
            case .delete: return Strings.ErrorCopy.ClientOperation.delete.persistence
            }
        }
    }
}
