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


//struct AsyncContentView<Source: LoadableObject, Content: View>: View {
//    @ObservedObject var source: Source
//    var content: (Source.Output) -> Content
//
//    var body: some View {
//        switch source.state {
//        case .idle:
//            Color.clear.onAppear(perform: source.load)
//        case .loading:
//            Text("Loading..")
//        case .failed(let error):
//            ErrorView(error: error, retryHandler: source.load)
//        case .loaded(let output):
//            content(output)
//        }
//    }
//}

//
//struct ErrorView: View {
//    @State var error: Error
//
//    var body: some View {
//        VStack {
//            Text("Error! Try again!")
//            Button("Try again") {
//                <#code#>
//            }
//        }
//
//    }
//}
