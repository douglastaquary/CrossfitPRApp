//
//  UserPurchaseState.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 03/12/22.
//

import Foundation

enum UserPurchaseState: Equatable {
    static func == (lhs: UserPurchaseState, rhs: UserPurchaseState) -> Bool {
        switch (lhs, rhs) {
        case (.isPRO, .success):
            return true
        default:
            return false
        }
    }
    
    case unlockPro
    case isPRO
    case marketing
    case loading
    case blockPro
    case failed(RequestError)
    case success
}
