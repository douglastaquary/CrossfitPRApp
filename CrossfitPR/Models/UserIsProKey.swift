//
//  UserIsProKey.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 12/10/22.
//

import SwiftUI

struct UserIsProKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct StoreKitManagerKey: EnvironmentKey {
    static let defaultValue: StoreKitManager = StoreKitManager()
}
