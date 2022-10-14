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

extension EnvironmentValues {
    var isPro: Bool {
        get { self[UserIsProKey.self] }
        set { self[UserIsProKey.self] = newValue }
    }
}
