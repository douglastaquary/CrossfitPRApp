import Foundation

/// Catálogo de produtos StoreKit (REASONS E).
public enum SubscriptionCatalog {
    /// Produto legado (StoreKit config local).
    public static let proProductID = "com.douglast.CrossfitPR.pro"

    /// IDs beta — mensal e anual.
    public static let proMonthlyProductID = "com.taquarylab.crossfitprapp.subscription.monthly"
    public static let proAnnualProductID = "com.taquarylab.crossfitprapp.subscription.annual"

    /// Todos os IDs que concedem tier PRO.
    public static let proProductIDs: [String] = [
        proProductID,
        proMonthlyProductID,
        proAnnualProductID,
    ]
}
