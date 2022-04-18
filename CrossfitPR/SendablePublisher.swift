//
//  SendablePublisher.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import Combine

public struct SendablePublisher<Output, Failure: Error>: Publisher {
    let upstream: AnyPublisher<Output, Failure>

    public init(
        fullFill: @Sendable @escaping () async throws -> Output
    ) where Failure == Error {
        var task: Task<Void, Never>?
        upstream = Deferred {
            Future { promise in
                task = Task {
                    do {
                        let result = try await fullFill()
                        try Task.checkCancellation()
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        upstream.subscribe(subscriber)
    }
}
