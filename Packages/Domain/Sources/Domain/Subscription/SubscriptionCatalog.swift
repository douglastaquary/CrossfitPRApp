import Foundation

/// Catálogo de produtos StoreKit (REASONS E — CPR-002 / CPR-008).
public enum SubscriptionCatalog {
    /// Produto legado (StoreKit config local).
    public static let proProductID = "com.douglast.CrossfitPR.pro"

    /// IDs PRO — mensal e anual.
    public static let proMonthlyProductID = "com.taquarylab.crossfitprapp.subscription.monthly"
    public static let proAnnualProductID = "com.taquarylab.crossfitprapp.subscription.annual"

    /// IDs Elite — mensal e anual (CPR-008).
    public static let eliteMonthlyProductID = "com.taquarylab.crossfitprapp.subscription.elite.monthly"
    public static let eliteAnnualProductID = "com.taquarylab.crossfitprapp.subscription.elite.annual"
    public static let eliteProductID = "com.douglast.CrossfitPR.elite"

    /// Todos os IDs que concedem tier PRO (não Elite).
    public static let proProductIDs: [String] = [
        proProductID,
        proMonthlyProductID,
        proAnnualProductID,
    ]

    /// Todos os IDs que concedem tier Elite.
    public static let eliteProductIDs: [String] = [
        eliteProductID,
        eliteMonthlyProductID,
        eliteAnnualProductID,
    ]

    /// Catálogo completo para fetch StoreKit.
    public static var allProductIDs: [String] {
        proProductIDs + eliteProductIDs
    }

    /// Resolve o tier a partir do product ID.
    public static func tier(forProductID id: String) -> SubscriptionTier? {
        if eliteProductIDs.contains(id) { return .elite }
        if proProductIDs.contains(id) { return .pro }
        return nil
    }
}
