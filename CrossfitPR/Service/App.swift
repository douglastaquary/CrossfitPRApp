//
//  App.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import Combine

// For more information check "How To Control The World" - Stephen Celis
// https://vimeo.com/291588126
struct World {
    var service = CloudKitService(unsafeNonisolated: true)
}

enum AppAction {
    case save(activity: PersonalRecord)
    case setHistoriesResult(prs: [PersonalRecord])
    case fetchHistories(prs: [PersonalRecord])
}

struct AppState {
    var historiesResult: [PersonalRecord] = []
}

func appReducer(
    state: inout AppState,
    action: AppAction,
    dependencies: AppDependencies
) -> AnyPublisher<AppAction, Never>? {
    switch action {
    case let .save(activity):
        return SendablePublisher {
            try await dependencies.save(activity)
        }
        .replaceError(with: PersonalRecord())
        .map(AppAction.save)
        .eraseToAnyPublisher()
    case let .setHistoriesResult(prs):
        state.historiesResult = prs
    case let .fetchHistories(prs):
        return SendablePublisher {
            try await dependencies.fetchHistories(prs)
        }
        .replaceError(with: [])
        .map(AppAction.setHistoriesResult)
        .eraseToAnyPublisher()
    }
    return nil
    
}

typealias Reducer<State, Action, Dependencies> =
    (inout State, Action, Dependencies) -> AnyPublisher<Action, Never>?

@MainActor final class Store<State, Action, Dependencies>: ObservableObject {
    @Published private(set) var state: State

    private let dependencies: Dependencies
    private let reducer: Reducer<State, Action, Dependencies>

    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Dependencies>,
        dependencies: Dependencies
    ) {
        self.state = initialState
        self.reducer = reducer
        self.dependencies = dependencies
    }

    func send(_ action: Action) async {
        guard let effect = reducer(&state, action, dependencies) else {
            return
        }

        for await action in effect.values {
            await send(action)
        }
    }
}
