import XCTest

/// QA automatizado — shell do app em pt-BR e en (preferência simulada via launch arguments).
final class AppLocalizationQATests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPortugueseMainTabsAndScreens() throws {
        let app = configuredApp(languageCode: "pt-BR")
        app.launch()

        assertTabBar(app, categories: "Exercícios", records: "Meus PRs", insights: "Evolução", settings: "Ajustes")
        assertRootIdentifiers(app)

        app.tabBars.buttons["Meus PRs"].tap()
        XCTAssertTrue(app.navigationBars["Meus PRs"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Evolução"].tap()
        XCTAssertTrue(app.navigationBars["Evolução"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Ajustes"].tap()
        XCTAssertTrue(app.navigationBars["Ajustes"].waitForExistence(timeout: 5))
    }

    func testEnglishMainTabsAndScreens() throws {
        let app = configuredApp(languageCode: "en")
        app.launch()

        assertTabBar(app, categories: "Exercises", records: "My PRs", insights: "Progress", settings: "Settings")
        assertRootIdentifiers(app)

        app.tabBars.buttons["My PRs"].tap()
        XCTAssertTrue(app.navigationBars["My PRs"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Progress"].tap()
        XCTAssertTrue(app.navigationBars["Progress"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    func testOnboardingCTAInEnglishAndPortuguese() throws {
        try assertOnboardingCTA(languageCode: "en", expectedLabel: "Let's go")
        try assertOnboardingCTA(languageCode: "pt-BR", expectedLabel: "Bora começar")
    }

    // MARK: - Helpers

    private func configuredApp(languageCode: String, skipOnboarding: Bool = true) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(\(languageCode))"]
        let locale = languageCode == "en" ? "en_US" : "pt_BR"
        app.launchArguments += ["-AppleLocale", locale]
        app.launchEnvironment["UITEST_SKIP_SPLASH"] = "1"
        if skipOnboarding {
            app.launchEnvironment["UITEST_SKIP_ONBOARDING"] = "1"
        } else {
            app.launchEnvironment["UITEST_FORCE_ONBOARDING"] = "1"
        }
        return app
    }

    private func assertOnboardingCTA(languageCode: String, expectedLabel: String) throws {
        let app = configuredApp(languageCode: languageCode, skipOnboarding: false)
        app.launch()

        let cta = app.buttons["onboarding.cta"]
        XCTAssertTrue(cta.waitForExistence(timeout: 20), "Onboarding CTA (\(languageCode))")
        XCTAssertEqual(cta.label, expectedLabel)
    }

    private func assertTabBar(
        _ app: XCUIApplication,
        categories: String,
        records: String,
        insights: String,
        settings: String
    ) {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 15))
        XCTAssertTrue(tabBar.buttons[categories].exists)
        XCTAssertTrue(tabBar.buttons[records].exists)
        XCTAssertTrue(tabBar.buttons[insights].exists)
        XCTAssertTrue(tabBar.buttons[settings].exists)
    }

    private func assertRootIdentifiers(_ app: XCUIApplication) {
        XCTAssertTrue(app.otherElements["tab.categories"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.otherElements["tab.records"].exists)
        XCTAssertTrue(app.otherElements["tab.insights"].exists)
        XCTAssertTrue(app.otherElements["tab.settings"].exists)
    }
}
