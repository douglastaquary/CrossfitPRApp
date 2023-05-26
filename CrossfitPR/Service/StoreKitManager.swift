//
//  StoreKitManager.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 14/09/22.
//

import StoreKit
import Combine
import CloudKit
import OSLog

enum RequestError: Error {
    case badURL
    case userCantMakePayment
    case invalidProductIdentifiers
    case fail(message: String)
    case pending
    case paymentQueueError
    case cancelled
}

//https://blckbirds.com/post/how-to-use-in-app-purchases-in-swiftui-apps/
class StoreKitManager: NSObject, ObservableObject {
    private static let logger = Logger(subsystem: "com.douglast.mycrossfitpr", category: String(describing: StoreKitManager.self))

    
    @Published var products = [Product]()
    @Published var newProducts = [Product]()
    @Published var transactionState: SKPaymentTransactionState?
    @Published var uiState: UserPurchaseState = .loading
    @Published private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    
    @MainActor
    private let cloudKitService = CloudKitService()
    
    @MainActor
    func fetchProducts(ids: [String]) async throws -> [Product] {
        let storeProducts = try await Product.products(for: Set(ids))
        return storeProducts
    }
    
    func fetchAccountStatus() async {
        do {
            accountStatus = try await cloudKitService.checkAccountStatus()
        } catch {
            Self.logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    static func listenForStoreKitUpdates() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await transaction.finish()
                    if transaction.revocationDate == nil {
                        DispatchQueue.main.async {
                            UserDefaults.standard.setValue(true, forKey: transaction.productID)
                            UserDefaults.standard.setValue(true, forKey: SettingStoreKeys.pro)
                        }
                    }
                    // Update the user's purchases...
                case .unverified:
                    UserDefaults.standard.setValue(false, forKey: SettingStoreKeys.pro)
                    print("[LOG] 🔴")
                }
            }
        }
    }
    
    
    @MainActor
    func updatePurchases() async throws -> Task<Transaction, Error> {
        Task {
            self.uiState = .loading
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else {
                    self.uiState = .blockPro
                    throw RequestError.fail(message: "updatePurchases(), Fail when try to fetch a transaction verified!")
                }
                if transaction.revocationDate == nil {
                    // show to purchase screen
                    print("[LOG] 🏁\n\(transaction)\n")
                    performUser(to: .isPRO)
                    return transaction
                } else {
                    print("[LOG] 🔴")
                    performUser(to: .blockPro)
                    return transaction
                }
            }
            
            self.uiState = .blockPro
            throw RequestError.fail(message: "[LOG] Error when try to verify user purchase state request")
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
                performUser(to: .isPRO, transaction: transaction)
                return transaction
            case .unverified:
                performUser(to: .blockPro)
                UserDefaults.standard.setValue(false, forKey: SettingStoreKeys.pro)
                transactionState = .failed
                throw RequestError.fail(message: "[LOG] purchase(), case .unverified, Transaction not vefified!")
            }
        case .userCancelled:
            performUser(to: .blockPro)
            throw RequestError.cancelled
        @unknown default:
            performUser(to: .blockPro)
            assertionFailure("Unexpected result")
            throw RequestError.fail(message: "[LOG] purchase(), Unexpected result")
        }
    }
    
    func performUser(to status: UserPurchaseState, transaction: Transaction? = nil) {
        switch status {
        case .loading:
            self.uiState = .loading
        case .isPRO:
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(true, forKey: transaction?.productID ?? "")
                UserDefaults.standard.setValue(true, forKey: SettingStoreKeys.pro)
                self.transactionState = .purchased
                self.uiState = .isPRO
            }
        default:
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: transaction?.productID ?? "")
                self.transactionState = .failed
                self.uiState = .blockPro
            }
        }
    }
    
}
