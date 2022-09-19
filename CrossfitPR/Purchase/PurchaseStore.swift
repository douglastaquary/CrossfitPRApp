//
//  PurchaseStore.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 14/09/22.
//

import SwiftUI
import Combine
import StoreKit

@MainActor
final class PurchaseStore: ObservableObject {
    enum State: Equatable {
        case unlockPro
        case loading
        case failed(RequestError)
        case success
    }
    private let crossFitPRProductIDs = [
        "com.taquarylab.crossfitprapp.subscription.monthly",
        "com.taquarylab.crossfitprapp.subscription.annual"
    ]
    
    @Published var storeKitManager: StoreKitManager
    @Published var subscriptions: [SKProduct] = []
    var monthlySubscription: SKProduct = SKProduct()
    @Published var monthlySubscriptionPrice: String = ""
    var annualSubscription: SKProduct = SKProduct()
    @Published var annualSubscriptionPrice: String = ""
    
    @Published private(set) var state = State.loading
    private let defaults: UserDefaults
    private let cancellable: Cancellable
    let objectWillChange = PassthroughSubject<Void, Never>()

    init(storeKitManager: StoreKitManager, defaults: UserDefaults = .standard) {
        self.storeKitManager = storeKitManager
        self.defaults = defaults
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
        
        self.performProducts()
        self.subscriptions = storeKitManager.products
    }
    
    var isPro: Bool {
        set { defaults.set(newValue, forKey: SettingStoreKeys.pro) }
        get { defaults.bool(forKey: SettingStoreKeys.pro) }
    }

    func performProducts() {
        self.storeKitManager.getProducts(productIDs: crossFitPRProductIDs)
    }

    func performPROMonthly(product: SKProduct) {
        self.storeKitManager.purchaseProduct(product: product) { result in
            self.state = .loading
            switch result {
            case .success:
                if self.storeKitManager.transactionState == .purchased {
                    self.state = .success
                    print("Payment Annual Success!")
                }
            case .failure(let error):
                self.state = .failed(error)
                
                print(error.localizedDescription)
            }
        }
    }
    
    func performPROAnnual(product: SKProduct) {
        self.storeKitManager.purchaseProduct(product: product) { result in
            switch result {
            case .success:
                if self.storeKitManager.transactionState == .purchased {
                    self.state = .success
                    print("Payment Annual Success!")
                }
            case .failure(let error):
                self.state = .failed(error)
                self.blockPro()
                print(error.localizedDescription)
            }
        }
    }
    
    func priceLocale(to product: SKProduct) -> String? {
        return getPriceFormatted(for: product) ?? ""
    }

    private func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}



extension PurchaseStore {
    func unlockPro() {
        // You can do your in-app transactions here
        isPro = true
    }

    func restorePurchase() {
        // You can do you in-app purchase restore here
        isPro = false
    }
    
    func blockPro() {
        // You can do your in-app transactions here
        isPro = true
    }
}

