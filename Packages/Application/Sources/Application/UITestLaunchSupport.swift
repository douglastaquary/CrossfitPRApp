import Foundation

/// Flags para UI tests (`XCUIApplication.launchEnvironment`).
public enum UITestLaunchSupport {
    public static let skipSplashKey = "UITEST_SKIP_SPLASH"
    public static let skipOnboardingKey = "UITEST_SKIP_ONBOARDING"
    public static let forceOnboardingKey = "UITEST_FORCE_ONBOARDING"

    public static var shouldSkipSplash: Bool {
        ProcessInfo.processInfo.environment[skipSplashKey] == "1"
    }

    public static var shouldSkipOnboarding: Bool {
        ProcessInfo.processInfo.environment[skipOnboardingKey] == "1"
    }

    public static var shouldForceOnboarding: Bool {
        ProcessInfo.processInfo.environment[forceOnboardingKey] == "1"
    }
}
