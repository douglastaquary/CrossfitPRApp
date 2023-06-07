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
    @Published var state = UserPurchaseState.loading
    
    private let cancellable: Cancellable
    let objectWillChange = PassthroughSubject<Void, Never>()

    init(storeKitManager: StoreKitManager) {
        self.storeKitManager = storeKitManager
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
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
                self.state = .processing
                print("\(transaction)")
                if transaction.ownershipType == .purchased {
                    self.state = .success
                    unlockPro()
                }
            } catch {
                self.state = .failed(RequestError.fail(message: "[LOG] Error when try to confirm purchase request!\n:\(error)"))
                blockPro()

            }
        }
    }
    
    func updatePurchases() async {
        Task {
            do {
                let transaction = try await storeKitManager.updatePurchases()
                print("\(transaction)")
                if try await transaction.value.ownershipType == .purchased {
                    unlockPro()
                } else {
                    self.blockPro()
                }
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
            let formattedValue = formatter.string(from: number) ?? ""
            return formattedValue
        }
        return "\(0.0)"
    }
}

extension PurchaseStore {
    func processing() {
        DispatchQueue.main.async {
            self.state = .processing
        }
    }
    
    func unlockPro() {
        // You can do your in-app transactions here
        DispatchQueue.main.async {
            self.state = .unlockPro
        }
    }

    func blockPro() {
        // You can do you in-app purchase restore here
        DispatchQueue.main.async {
            self.state = .blockPro
        }
    }
}

