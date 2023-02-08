//
//  LoadingState.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 15/09/22.
//

import Foundation
import SwiftUI
import StoreKit

enum LoadingState: Equatable {
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loaded, .loaded):
            return true
        default:
            return false
        }
    }
    
    case idle
    case loading
    case failed(Error)
    case loaded([SKProduct])
}
