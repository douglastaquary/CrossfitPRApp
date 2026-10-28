import Foundation
import Domain

/// Flags para UI tests (`XCUIApplication.launchEnvironment`).
public enum UITestLaunchSupport {
    public static let skipSplashKey = "UITEST_SKIP_SPLASH"
    public static let skipOnboardingKey = "UITEST_SKIP_ONBOARDING"
    public static let forceOnboardingKey = "UITEST_FORCE_ONBOARDING"
    /// Valores: `free` | `pro` — injeta `MockSubscriptionStore` no simulador (UI tests).
    public static let subscriptionTierKey = "UITEST_SUBSCRIPTION_TIER"

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

    public static var subscriptionTierOverride: SubscriptionTier? {
        guard let raw = ProcessInfo.processInfo.environment[subscriptionTierKey]?.lowercased() else {
            return nil
        }
        switch raw {
        case "pro": return .pro
        case "free": return .free
        default: return nil
        }
    }
}
