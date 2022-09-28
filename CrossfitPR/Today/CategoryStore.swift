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
    
    var filteredCategories: [Category] {
        categories.filter {
            searchText.isEmpty ? true : $0.title.contains(searchText)
        }.sorted()
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
