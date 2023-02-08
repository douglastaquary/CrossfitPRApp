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

@MainActor final class CrossfitPRViewModel: ObservableObject {
    private static let logger = Logger(subsystem: "com.douglast.mycrossfitpr", category: String(describing: CrossfitPRViewModel.self))
    
    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published var userIsPRO: Bool = false

    private let cloudKitService = CloudKitService()
    private let storeKitService: StoreKitManager
    
    private var storeKitTaskHandle: Task<Void, Error>?
    
    init(storeKitService: StoreKitManager) {
        self.storeKitService = storeKitService
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

extension CrossfitPRViewModel {
    func subscriptions() async {
        // You can do your in-app transactions here
        Task {
            do {
                let products = try await storeKitService.fetchProducts(ids: CrossFitPRConstants.productIDs)
                print("[LOG] ✅ OnboardingViewModel.subscriptions(), Products:\n\(products)\n\n")
            } catch {
                print("[LOG] 🔴 OnboardingViewModel.subscriptions(), Error:\n\(error)\n\n")
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
                print("[LOG] OnboardingViewModel, subscriptions(),  Error: \(error)\n")
            }
        }
    }
}
