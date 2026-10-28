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
        XCTAssertTrue(proCTA.waitForExistence(timeout: 5))
        proCTA.tap()

        let proTitle = app.staticTexts["Evolua mais rápido"]
        XCTAssertTrue(proTitle.waitForExistence(timeout: 8))
        saveScreenshot(named: "pro-upgrade")

        dismissPROSheet(app)

        app.tabBars.buttons["Ajustes"].tap()
        _ = app.navigationBars["Ajustes"].waitForExistence(timeout: 5)
        saveScreenshot(named: "settings")
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

    private func dismissPROSheet(_ app: XCUIApplication) {
        let closeCandidates = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Fechar' OR label CONTAINS[c] 'Close'"))
        if closeCandidates.firstMatch.waitForExistence(timeout: 2) {
            closeCandidates.firstMatch.tap()
            return
        }
        let iconClose = app.buttons.element(matching: NSPredicate(format: "identifier == 'pro.upgrade.close'"))
        if iconClose.waitForExistence(timeout: 2) {
            iconClose.tap()
            return
        }
        app.swipeDown()
    }
}
