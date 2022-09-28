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
    case paymentQueueError
}

//https://blckbirds.com/post/how-to-use-in-app-purchases-in-swiftui-apps/
class StoreKitManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var products = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    @Published var storeKitState: LoadingState = .idle
    
    var request: SKProductsRequest!
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.storeKitState = .loading
        }
        print("Start productsRequest..")
        
        if !response.invalidProductIdentifiers.isEmpty {
            for invalidIdentifier in response.invalidProductIdentifiers {
                print("Invalid identifiers found: \(invalidIdentifier)")
            }
            return
        }
        guard !response.products.isEmpty else {
            storeKitState = .loaded([])
            return
        }
        print("Did receive response..")
        DispatchQueue.main.async {
            self.products = response.products
            print("\n==== Products response ====\n\(self.products )")
            self.storeKitState = .loaded(self.products)
        }
    }

    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        print("\(productIDs)")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    // Purchase products using the SKPaymentTransactionObserver protocol
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
                switch transaction.transactionState {
                case .purchasing:
                    transactionState = .purchasing
                case .purchased:
                    UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                    UserDefaults.standard.setValue(true, forKey: SettingStoreKeys.pro)
                    queue.finishTransaction(transaction)
                    transactionState = .purchased
                case .restored:
                    UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                    UserDefaults.standard.setValue(true, forKey: SettingStoreKeys.pro)
                    queue.finishTransaction(transaction)
                    transactionState = .restored
                case .failed, .deferred:
                    print("Payment Queue Error: \(String(describing: transaction.error))")
                    UserDefaults.standard.setValue(false, forKey: SettingStoreKeys.pro)
                    queue.finishTransaction(transaction)
                    transactionState = .failed
                    default:
                    queue.finishTransaction(transaction)
                }
            }
    }

    func purchaseProduct(product: SKProduct, completion: @escaping (Result<Bool, RequestError>) -> Void) {
        startObserving()
        storeKitState = .loading
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            //storeKitState = .loaded([])
            //completion(.success(true))
        } else {
            print("User can't make payment.")
            completion(.failure(.userCantMakePayment))
            storeKitState = .failed(RequestError.userCantMakePayment)
        }
    }
    
    //Restore products already purchased
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func startObserving() {
      SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
      SKPaymentQueue.default().remove(self)
    }

    func cancel() {
        
    }
}
