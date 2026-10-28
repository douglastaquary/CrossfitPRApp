import XCTest

/// Captura automática de mídia para o README (`docs/screenshots`, gravação para GIF).
final class ReadmeScreenshotsUITests: XCTestCase {
    private var docsRoot: String {
        if let env = ProcessInfo.processInfo.environment["CROSSFITPR_DOCS_ROOT"],
           !env.isEmpty,
           env.hasPrefix("/") {
            return (env as NSString).standardizingPath
        }
        if let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"], !srcRoot.isEmpty {
            return (srcRoot as NSString).appendingPathComponent("docs")
        }
        // CrossfitPRUITests/ → raiz do repositório
        let repoRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        return repoRoot.appendingPathComponent("docs").path
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCaptureReadmeScreenshots() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR"]
        app.launchEnvironment["UITEST_SKIP_SPLASH"] = "1"
        app.launch()

        let onboardingCTA = app.buttons["onboarding.cta"]
        XCTAssertTrue(onboardingCTA.waitForExistence(timeout: 20), "Onboarding não apareceu")
        saveScreenshot(named: "onboarding")
        onboardingCTA.tap()

        let tabExercises = app.tabBars.buttons["Exercícios"]
        XCTAssertTrue(tabExercises.waitForExistence(timeout: 10))
        saveScreenshot(named: "categories")

        app.tabBars.buttons["Meus PRs"].tap()
        _ = app.navigationBars["Meus PRs"].waitForExistence(timeout: 5)
        saveScreenshot(named: "records-empty")

        app.tabBars.buttons["Evolução"].tap()
        _ = app.navigationBars["Evolução"].waitForExistence(timeout: 5)
        saveScreenshot(named: "insights-free")

        let proCTA = app.descendants(matching: .any).matching(identifier: "insights.teaser.pro.cta").firstMatch
        XCTAssertTrue(proCTA.waitForExistence(timeout: 8))
        proCTA.tap()

        let paywall = app.descendants(matching: .any).matching(identifier: "pro.upgrade.scroll").firstMatch
        XCTAssertTrue(paywall.waitForExistence(timeout: 12), "Paywall PRO/Elite")
        let headline = app.staticTexts["Treine como competidor"]
        _ = headline.waitForExistence(timeout: 5)
        saveScreenshot(named: "pro-upgrade")

        dismissPROSheet(app)

        app.tabBars.buttons["Ajustes"].tap()
        _ = app.navigationBars["Ajustes"].waitForExistence(timeout: 5)
        saveScreenshot(named: "settings")
    }

    func testCaptureInsightsProAndElite() throws {
        captureInsightsScreenshot(tier: "pro", fileName: "insights-pro")
        captureInsightsScreenshot(tier: "elite", fileName: "insights-elite")
    }

    func testCaptureWatchPOCScreens() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR"]
        app.launchEnvironment["UITEST_SKIP_SPLASH"] = "1"
        app.launchEnvironment["UITEST_WATCH_SCREENSHOT_GALLERY"] = "1"
        app.launchArguments += ["-UITEST_WATCH_SCREENSHOT_GALLERY", "1"]
        app.launch()

        let gallery = app.descendants(matching: .any).matching(identifier: "watch.poc.gallery").firstMatch
        XCTAssertTrue(gallery.waitForExistence(timeout: 12))

        XCTAssertTrue(element(app, identifier: "watch.poc.session").waitForExistence(timeout: 8))
        saveScreenshot(named: "watch-session")

        app.descendants(matching: .any).matching(identifier: "watch.poc.next").firstMatch.tap()
        XCTAssertTrue(element(app, identifier: "watch.poc.rest").waitForExistence(timeout: 8))
        saveScreenshot(named: "watch-rest")

        app.descendants(matching: .any).matching(identifier: "watch.poc.next").firstMatch.tap()
        XCTAssertTrue(element(app, identifier: "watch.poc.breath").waitForExistence(timeout: 8))
        saveScreenshot(named: "watch-breath")
    }

    /// Percorre as tabs lentamente — rode com `simctl recordVideo` em paralelo.
    func testDemoTabTour() throws {
        let app = XCUIApplication()
        app.launch()

        if app.buttons["Bora começar"].waitForExistence(timeout: 15) {
            app.buttons["Bora começar"].tap()
        }

        let tabs = ["Exercícios", "Meus PRs", "Evolução", "Ajustes"]
        for _ in 0 ..< 2 {
            for tab in tabs {
                app.tabBars.buttons[tab].tap()
                sleep(2)
            }
        }
    }

    // MARK: - Helpers

    private func saveScreenshot(named name: String) {
        let dir = URL(fileURLWithPath: docsRoot).appendingPathComponent("screenshots", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("\(name).png")
        let data = XCUIScreen.main.screenshot().pngRepresentation
        do {
            try data.write(to: url)
        } catch {
            XCTFail("Falha ao salvar \(url.path): \(error)")
        }
    }

    private func captureInsightsScreenshot(tier: String, fileName: String) {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR"]
        app.launchEnvironment["UITEST_SKIP_SPLASH"] = "1"
        app.launchEnvironment["UITEST_SKIP_ONBOARDING"] = "1"
        app.launchEnvironment["UITEST_SUBSCRIPTION_TIER"] = tier
        app.launchArguments += ["-UITEST_SUBSCRIPTION_TIER", tier]
        app.launch()

        let tab = app.tabBars.buttons["Evolução"]
        XCTAssertTrue(tab.waitForExistence(timeout: 15))
        tab.tap()
        XCTAssertTrue(app.navigationBars["Evolução"].waitForExistence(timeout: 8))

        let targetID = tier == "pro" ? "insights.coach.section" : "insights.elite.section"
        let target = element(app, identifier: targetID)
        for _ in 0 ..< 4 {
            if target.waitForExistence(timeout: 6) { break }
            app.swipeUp()
        }
        XCTAssertTrue(target.exists, targetID)

        saveScreenshot(named: fileName)
        app.terminate()
    }

    private func element(_ app: XCUIApplication, identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }

    private func dismissPROSheet(_ app: XCUIApplication) {
        let closeCandidates = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Fechar' OR label CONTAINS[c] 'Close'"))
        if closeCandidates.firstMatch.waitForExistence(timeout: 2) {
            closeCandidates.firstMatch.tap()
            return
        }
        let iconClose = app.descendants(matching: .any).matching(identifier: "pro.upgrade.close").firstMatch
        if iconClose.waitForExistence(timeout: 3) {
            iconClose.tap()
            return
        }
        app.swipeDown()
    }
}
