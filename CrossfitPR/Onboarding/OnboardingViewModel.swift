//
//  OnboardingViewModel.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import CloudKit
import StoreKit
import os

@MainActor final class OnboardingViewModel: ObservableObject {
    
    enum State: Equatable {
        case isPro
        case purchase
        case failed(RequestError)
        case noNetwork
    }
    private static let logger = Logger(
        subsystem: "com.douglast.mycrossfitpr",
        category: String(describing: OnboardingViewModel.self)
    )

    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published var userIsPRO: Bool = false

    private let cloudKitService = CloudKitService()
    private let storeKitService: StoreKitManager = StoreKitManager()
    
    private var storeKitTaskHandle: Task<Void, Error>?
    
    init() {
        startStoreKitListener()
    }

    // Call this early in the app's lifecycle.
    private func startStoreKitListener() {
        storeKitTaskHandle = StoreKitManager.listenForStoreKitUpdates()
    }

    func fetchAccountStatus() async {
        do {
            accountStatus = try await cloudKitService.checkAccountStatus()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }

}

extension OnboardingViewModel {
    func subscriptions() async {
        // You can do your in-app transactions here
        Task {
            do {
                let products = try await storeKitService.fetchProducts(ids: CrossFitPRConstants.productIDs)
                print("\(products)")
                //productLoadingState = .loaded(products)
            } catch {
                print("\(error)")
                //productLoadingState = .failed(error)
            }
        }
        
    }
    
    func updatePurchases() {
        Task {
            do {
                let transaction = try await storeKitService.updatePurchases()
                print("\(transaction)")
                if try await transaction.value.ownershipType == .purchased {
                    userIsPRO = true
                }
            } catch {
                userIsPRO = false
                print("\(error)")
            }
        }
    }
}
