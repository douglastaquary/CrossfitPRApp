//
//  CategoryStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 28/04/22.
//

import Foundation
import SwiftUI
import Combine
import CloudKit
import os

@MainActor final class CategoryStore: ObservableObject {
    private static let logger = Logger(
        subsystem: "com.dabtlab.crossfitprapp",
        category: String(describing: CategoryStore.self)
    )
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var searchText: String = ""
    @Published var selectedCategoryItem: Int = 0
    @Published private(set) var session: [UserSession] = []
    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    private let cloudKitService = CloudKitService()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    private var categories: [Category] {
        Category.list
    }
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: SettingStoreKeys.pro) }
        get { defaults.bool(forKey: SettingStoreKeys.pro) }
    }
    
    @Published var filteredCategories: [Category] = []
//
    var categoriesPerGroup: [Category] {
        categories.filter {
            $0.group.rawValue.contains(categories[selectedCategoryItem].group.rawValue)
        }.sorted()
    }
    
    func fetchCategoryPerGroup(recordGroup: RecordGroup = .barbell) -> [Category] {
        filteredCategories = categories.filter {
            $0.group.rawValue.contains(recordGroup.rawValue)
        }.sorted()
        
        return filteredCategories
    }
    
    func searchExercise(for text: String) -> [Category] {
        if text.isEmpty {
            filteredCategories = categories
            return filteredCategories
        } else {
            return filteredCategories.filter {
                $0.title.contains(text)
            }.sorted()
        }
    }
    
    var searchResults: [Category] {
        if searchText.isEmpty {
            return filteredCategories
        } else {
            return filteredCategories.filter { $0.title.contains(searchText) }
        }
    }
    
    
    func fetchUserSession() async {
        do {
            session = try await cloudKitService.fetchUserSession()
            validateIfUserIsPRO()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    func validateIfUserIsPRO() {
        guard let session = session.first else {
            isPro = false
            return
        }
        guard session.isPro else {
            isPro = false
            return
        }
        isPro = true
        
    }
    
}
