import XCTest

/// QA automatizado — shell do app em pt-BR e en (preferência simulada via launch arguments).
final class AppLocalizationQATests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPortugueseMainTabsAndScreens() throws {
        let app = configuredApp(languageCode: "pt-BR")
        app.launch()

        waitForMainShell(app)
        assertTabBar(app, categories: "Exercícios", records: "Meus PRs", insights: "Evolução", settings: "Ajustes")
        assertRootIdentifiers(app)

        app.tabBars.buttons["Meus PRs"].tap()
        XCTAssertTrue(app.navigationBars["Meus PRs"].waitForExistence(timeout: 8))

        app.tabBars.buttons["Evolução"].tap()
        XCTAssertTrue(app.navigationBars["Evolução"].waitForExistence(timeout: 8))

        app.tabBars.buttons["Ajustes"].tap()
        XCTAssertTrue(app.navigationBars["Ajustes"].waitForExistence(timeout: 8))
    }

    func testEnglishMainTabsAndScreens() throws {
        let app = configuredApp(languageCode: "en")
        app.launch()

        waitForMainShell(app)
        assertTabBar(app, categories: "Exercises", records: "My PRs", insights: "Progress", settings: "Settings")
        assertRootIdentifiers(app)

        app.tabBars.buttons["My PRs"].tap()
        XCTAssertTrue(app.navigationBars["My PRs"].waitForExistence(timeout: 8))

        app.tabBars.buttons["Progress"].tap()
        XCTAssertTrue(app.navigationBars["Progress"].waitForExistence(timeout: 8))

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 8))
    }

    func testOnboardingCTAInEnglishAndPortuguese() throws {
        try assertOnboardingCTA(languageCode: "en", expectedLabel: "Let's go")
        try assertOnboardingCTA(languageCode: "pt-BR", expectedLabel: "Bora começar")
    }

    func testInsightsPROUpgradeSheetPortuguese() throws {
        let app = configuredApp(languageCode: "pt-BR")
        app.launch()

        waitForMainShell(app)
        app.tabBars.buttons["Evolução"].tap()
        XCTAssertTrue(app.navigationBars["Evolução"].waitForExistence(timeout: 8))

        let cta = element(app, identifier: "insights.teaser.pro.cta")
        XCTAssertTrue(cta.waitForExistence(timeout: 8))
        cta.tap()

        let close = element(app, identifier: "pro.upgrade.close")
        XCTAssertTrue(close.waitForExistence(timeout: 8))
        close.tap()
        XCTAssertTrue(app.navigationBars["Evolução"].waitForExistence(timeout: 5))
    }

    func testInsightsPROUpgradeSheetEnglish() throws {
        let app = configuredApp(languageCode: "en")
        app.launch()

        waitForMainShell(app)
        app.tabBars.buttons["Progress"].tap()
        XCTAssertTrue(app.navigationBars["Progress"].waitForExistence(timeout: 8))

        let cta = element(app, identifier: "insights.teaser.pro.cta")
        XCTAssertTrue(cta.waitForExistence(timeout: 8))
        cta.tap()

        let close = element(app, identifier: "pro.upgrade.close")
        XCTAssertTrue(close.waitForExistence(timeout: 8))
        close.tap()
    }

    func testProCoachSectionPortuguese() throws {
        let app = configuredApp(languageCode: "pt-BR")
        app.launchEnvironment["UITEST_SUBSCRIPTION_TIER"] = "pro"
        app.launch()

        waitForMainShell(app)
        app.tabBars.buttons["Evolução"].tap()
        XCTAssertTrue(app.navigationBars["Evolução"].waitForExistence(timeout: 8))
        XCTAssertTrue(element(app, identifier: "insights.coach.section").waitForExistence(timeout: 10))
    }

    func testSettingsTrackingSectionSmokePortuguese() throws {
        let app = configuredApp(languageCode: "pt-BR")
        app.launch()

        waitForMainShell(app)
        app.tabBars.buttons["Ajustes"].tap()
        XCTAssertTrue(app.navigationBars["Ajustes"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Unidade de peso"].waitForExistence(timeout: 5))
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

    private func waitForMainShell(_ app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let tabBar = app.tabBars.firstMatch
        let categoriesTab = element(app, identifier: "tab.categories")
        let appeared = tabBar.waitForExistence(timeout: 25) || categoriesTab.waitForExistence(timeout: 25)
        XCTAssertTrue(appeared, "Tab shell não apareceu (rede/offline ou onboarding bloqueando).", file: file, line: line)
    }

    private func assertOnboardingCTA(languageCode: String, expectedLabel: String) throws {
        let app = configuredApp(languageCode: languageCode, skipOnboarding: false)
        app.launch()

        let cta = element(app, identifier: "onboarding.cta")
        XCTAssertTrue(cta.waitForExistence(timeout: 25), "Onboarding CTA (\(languageCode))")
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
        XCTAssertTrue(tabBar.waitForExistence(timeout: 8))
        XCTAssertTrue(tabBar.buttons[categories].waitForExistence(timeout: 5))
        XCTAssertTrue(tabBar.buttons[records].exists)
        XCTAssertTrue(tabBar.buttons[insights].exists)
        XCTAssertTrue(tabBar.buttons[settings].exists)
    }

    private func assertRootIdentifiers(_ app: XCUIApplication) {
        XCTAssertTrue(element(app, identifier: "tab.categories").waitForExistence(timeout: 8))
        XCTAssertTrue(element(app, identifier: "tab.records").exists)
        XCTAssertTrue(element(app, identifier: "tab.insights").exists)
        XCTAssertTrue(element(app, identifier: "tab.settings").exists)
    }

    private func element(_ app: XCUIApplication, identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }
}
