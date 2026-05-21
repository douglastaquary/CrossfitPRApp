import Foundation

/// Informações de produto para exibição na UI (REASONS E).
public struct SubscriptionProductInfo: Sendable, Equatable {
    public var id: String
    public var displayName: String
    public var displayPrice: String

    public init(id: String, displayName: String, displayPrice: String) {
        self.id = id
        self.displayName = displayName
        self.displayPrice = displayPrice
    }
}
