//
//  AppDependencies.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation

struct AppDependencies {
    let save: @Sendable (PersonalRecord) async throws -> PersonalRecord
    let fetchHistories: @Sendable ([PersonalRecord]) async throws -> [PersonalRecord]
}
