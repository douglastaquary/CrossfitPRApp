//
//  CategoryStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 28/04/22.
//

import Foundation
import SwiftUI
import Combine
import os

@MainActor final class CategoryStore: ObservableObject {
    private enum Keys {
        static let pro = "pro"
        static let enabledMoveRecord = "enabled_move_record"
    }
    
    private let defaults: UserDefaults = .standard

    var isPro: Bool {
        get { defaults.bool(forKey: Keys.pro) }
    }

    private static let logger = Logger(
        subsystem: "com.dabtlab.crossfitprapp",
        category: String(describing: CategoryStore.self)
    )
    
    @Published var searchText: String = ""
    
    private var categories: [Category] {
        PRType.allCases.map {
            Category(title: $0.rawValue)
        }.filter { !$0.title.isEmpty }.sorted()
    }
    
    var filteredCategories: [Category] {
        categories.filter {
            searchText.isEmpty ? true : $0.title.contains(searchText)
        }.sorted()
    }
    
}
