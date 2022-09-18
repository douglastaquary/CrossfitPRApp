//
//  LoadingState.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/09/22.
//

import Foundation
import SwiftUI

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}

enum LoadingState<T> {
    case idle
    case loading
    case failed(Error)
    case loaded(T)
}
