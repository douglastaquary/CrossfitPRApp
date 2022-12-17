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

    @Published var storeKitManager: StoreKitManager
    @Published var subscriptions: [Product] = []
    @Published var products: [Product] = []
    @Published private(set) var state = UserPurchaseState.loading
    
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
    }
    
    @Published var isPro: Bool = false

    func fetchProducs() async throws -> Task<[Product], Error> {
        Task {
            do {
                self.products = try await self.storeKitManager.fetchProducts(ids: CrossFitPRConstants.productIDs)
                return self.products
            } catch {
                throw RequestError.fail(message: "fetchProducs(), Error: \(error)")
            }
        }
    }
    
    func purchase(product: Product) async {
        self.state = .loading
        Task {
            do {
                let transaction = try await self.storeKitManager.purchase(product)
                print("\(transaction)")
                if transaction.ownershipType == .purchased {
                    self.state = .unlockPro
                    isPro = true
                }
            } catch {
                self.state = .failed(RequestError.fail(message: "[LOG] Error when try to confirm purchase request!\n:\(error)"))
                self.blockPro()
                //userIsPRO = false
                print("\(error)")
            }
        }
    }
    
    func updatePurchases() async {
        Task {
            do {
                let transaction = try await storeKitManager.updatePurchases()
                print("\(transaction)")
                if try await transaction.value.ownershipType == .purchased {
                    isPro = true
                    self.state = .unlockPro
                    //userIsPRO = true
                } else {
                    isPro = false
                    self.blockPro()
                }
                //return transaction
            } catch {
                debugPrint("\(error)")
                throw RequestError.fail(message: "[LOG] updatePurchases(), Error: \(error)")
            }
        }
    }

    func priceLocale(to product: Product) -> String? {
        return getPriceFormatted(for: product) ?? ""
    }

    private func getPriceFormatted(for product: Product) -> String? {
        let formatter = NumberFormatter()
        //formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        if let stringNumber = Double(product.price.description) {
            let number = NSNumber(value: stringNumber)
            let formattedValue = formatter.string(from: number)!
            return formattedValue
        }
        return ""
    }
}

extension Decimal {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        if let stringNumber = Double(self.description) {
            let number = NSNumber(value: stringNumber)
            let formattedValue = formatter.string(from: number)!
            return formattedValue
        }
        return "\(0.0)"
    }
}

extension PurchaseStore {
    func unlockPro() {
        // You can do your in-app transactions here
        isPro = true
    }

    func restorePurchase() {
        // You can do you in-app purchase restore here
        isPro = true
    }
    
    func blockPro() {
        // You can do you in-app purchase restore here
        isPro = false
    }
}

