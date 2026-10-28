import Foundation
import Domain
import Subscription

/// Flags para UI tests (`XCUIApplication.launchEnvironment`).
public enum UITestLaunchSupport {
    public static let skipSplashKey = "UITEST_SKIP_SPLASH"
    public static let skipOnboardingKey = "UITEST_SKIP_ONBOARDING"
    public static let forceOnboardingKey = "UITEST_FORCE_ONBOARDING"
    /// Valores: `free` | `pro` | `elite` — injeta `MockSubscriptionStore` no simulador (UI tests).
    public static let subscriptionTierKey = "UITEST_SUBSCRIPTION_TIER"
    /// Simula resultado da próxima compra: `succeed` | `cancel` | `fail` | `pending`.
    public static let purchaseBehaviorKey = "UITEST_PURCHASE_BEHAVIOR"
    /// `1` = força `StoreKitSubscriptionStore` (Products.storekit / sandbox). Default simulador = mock.
    public static let useStoreKitKey = "UITEST_USE_STOREKIT"

    public static var shouldSkipSplash: Bool {
        ProcessInfo.processInfo.environment[skipSplashKey] == "1"
    }

    public static var shouldSkipOnboarding: Bool {
        ProcessInfo.processInfo.environment[skipOnboardingKey] == "1"
    }

    public static var shouldForceOnboarding: Bool {
        ProcessInfo.processInfo.environment[forceOnboardingKey] == "1"
    }

    /// App lançado pelos UI tests (`UITEST_SKIP_SPLASH=1` em `AppLocalizationQATests`).
    public static var isUITestMode: Bool {
        shouldSkipSplash
    }

    public static var prefersStoreKitConfiguration: Bool {
        ProcessInfo.processInfo.environment[useStoreKitKey] == "1"
    }

    public static var subscriptionTierOverride: SubscriptionTier? {
        let raw = ProcessInfo.processInfo.environment[subscriptionTierKey]
            ?? launchFlagValue("-UITEST_SUBSCRIPTION_TIER")
        guard let raw = raw?.lowercased() else { return nil }
        switch raw {
        case "pro": return .pro
        case "elite": return .elite
        case "free": return .free
        default: return nil
        }
    }

    private static func launchFlagValue(_ flag: String) -> String? {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: flag), index + 1 < args.count else { return nil }
        return args[index + 1]
    }

    public static var simulatedPurchaseOutcome: MockSubscriptionStore.SimulatedPurchaseOutcome {
        let raw = ProcessInfo.processInfo.environment[purchaseBehaviorKey]?.lowercased() ?? "succeed"
        return MockSubscriptionStore.SimulatedPurchaseOutcome(rawValue: raw) ?? .succeed
    }
}
