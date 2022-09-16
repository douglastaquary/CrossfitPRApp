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
class StoreKitManager: NSObject, ObservableObject, SKProductsRequestDelegate {
    
    @Published var products = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    var storeKitState: LoadingState<[SKProduct]> = .idle
    
    var request: SKProductsRequest!
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        storeKitState = .loading
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
        self.products = response.products
        print("\n==== Products response ====\n\(self.products )")
        storeKitState = .loaded(self.products)
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
                        queue.finishTransaction(transaction)
                        transactionState = .failed
                        default:
                        queue.finishTransaction(transaction)
                }
            }
    }
    
    func purchaseProduct(product: SKProduct, completion: @escaping (Result<Bool, RequestError>) -> Void) {
        storeKitState = .loading
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            completion(.success(true))
            storeKitState = .loaded([])
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
    
}

//class StoreKitManager: NSObject {
//    static let shared = StoreKitManager()
//
//    let purchasePublisher = PassthroughSubject<(String, Bool), Never>()
//
//    private override init() {
//        super.init()
//    }
//
//    func returnProductIDs() -> [String] {
//        return ["com.taquarylab.crossfitprapp"]
//    }
//
//    func getProductsV5() {
//        let productIDs = Set(returnProductIDs())
//        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
//        request.delegate = self
//        request.start()
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("didFailWithError ",error)
//        purchasePublisher.send(("Purchase request failed ",true))
//    }
//
//
//    final class productsDB: ObservableObject, Identifiable {
//        static let shared = productsDB()
//        var items:[SKProduct] = [] {
//            willSet {
//                DispatchQueue.main.async {
//                    self.objectWillChange.send()
//                }
//            }
//        }
//    }
//}
//
//extension StoreKitManager: SKProductsRequestDelegate, SKRequestDelegate {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let badProducts = response.invalidProductIdentifiers
//        let goodProducts = response.products
//        if goodProducts.count > 0 {
//            productsDB.shared.items = response.products
//            print("bon ",productsDB.shared.items)
//        }
//        print("badProducts ",badProducts)
//    }
//}
