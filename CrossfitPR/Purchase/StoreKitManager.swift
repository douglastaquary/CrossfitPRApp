//
//  StoreKitManager.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 14/09/22.
//

import StoreKit
import Combine

enum RequestError: Error {
    case badURL
    case userCantMakePayment
    case invalidProductIdentifiers
    case fail
    case pending
    case paymentQueueError
    case cancelled
}

//https://blckbirds.com/post/how-to-use-in-app-purchases-in-swiftui-apps/
class StoreKitManager: NSObject, ObservableObject {
    
    @Published var products = [Product]()
    @Published var newProducts = [Product]()
    @Published var transactionState: SKPaymentTransactionState?
    @Published var storeKitState: LoadingState = .idle
    
    @MainActor
    func fetchProducts(ids: [String]) async throws -> [Product] {
        let storeProducts = try await Product.products(for: Set(ids))
        return storeProducts
    }
    
    static func listenForStoreKitUpdates() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    print("Transaction verified in listener")
                    
                    await transaction.finish()
                    
                    // Update the user's purchases...
                case .unverified:
                    print("Transaction unverified")
                }
            }
        }
    }
    
    @MainActor
    func updatePurchases() async throws -> Task<Transaction, Error> {
        Task {
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else {
                    throw RequestError.fail
                }

                if transaction.revocationDate == nil {
                    // show to purchase screen
                    print("\(transaction)")
                    return transaction
                } else {
                    print("\(transaction)")
                    return transaction
                }
            }
            
            throw RequestError.fail
        }
    }

    func purchase(_ product: Product) async throws -> Transaction {
        let result = try await product.purchase()
        
        switch result {
        case .pending:
            throw RequestError.pending
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(true, forKey: transaction.productID)
                    UserDefaults.standard.setValue(true, forKey: SettingStoreKeys.pro)
                    self.transactionState = .purchased
                }
                                
                return transaction
            case .unverified:
                UserDefaults.standard.setValue(false, forKey: SettingStoreKeys.pro)
                transactionState = .failed
                throw RequestError.fail
            }
        case .userCancelled:
            throw RequestError.cancelled
        @unknown default:
            assertionFailure("Unexpected result")
            throw RequestError.fail
        }
    }
}
