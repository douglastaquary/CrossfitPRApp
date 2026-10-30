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
        app.launchEnvironment["UITEST_FORCE_ONBOARDING"] = "1"
        app.launchEnvironment["UITEST_SEED_SCENARIO"] = "empty"
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

        app.tabBars.buttons["Percepções"].tap()
        _ = app.navigationBars["Percepções"].waitForExistence(timeout: 5)
        saveScreenshot(named: "insights-free-empty")

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
        app.terminate()

        captureInsightsScreenshot(tier: "free", seed: "freeTeaser", fileName: "insights-free")
    }

    func testCaptureInsightsProAndElite() throws {
        captureInsightsScreenshot(tier: "pro", seed: "proRich", fileName: "insights-pro")
        captureInsightsScreenshot(tier: "elite", seed: "eliteRich", fileName: "insights-elite")
        captureInsightsScreenshot(tier: "pro", seed: "empty", fileName: "insights-pro-empty")
        captureInsightsScreenshot(tier: "elite", seed: "empty", fileName: "insights-elite-empty")
    }

    /// Galeria Free/PRO/Elite com dados — todas as tabs (+ Insights scroll) para review visual.
    func testCaptureTierScreenGallery() throws {
        let plans: [(tier: String, seed: String)] = [
            ("free", "freeTeaser"),
            ("pro", "proRich"),
            ("elite", "eliteRich"),
        ]
        for plan in plans {
            captureTierTabs(tier: plan.tier, seed: plan.seed)
        }
    }

    /// Lista/detalhe Meus PRs (CPR-013). Use `UITEST_APPEARANCE=light|dark` no host.
    func testCapturePRFitnessAppearance() throws {
        let style = ProcessInfo.processInfo.environment["UITEST_APPEARANCE"] ?? "light"
        capturePRFitnessAppearance(style: style)
    }

    /// Percorre as tabs lentamente — rode com `simctl recordVideo` em paralelo.
    func testDemoTabTour() throws {
        let app = XCUIApplication()
        app.launch()

        if app.buttons["Bora começar"].waitForExistence(timeout: 15) {
            app.buttons["Bora começar"].tap()
        }

        let tabs = ["Exercícios", "Meus PRs", "Percepções", "Ajustes"]
        for _ in 0 ..< 2 {
            for tab in tabs {
                app.tabBars.buttons[tab].tap()
                sleep(2)
            }
        }
    }

    // MARK: - Helpers

    private func captureInsightsScreenshot(tier: String, seed: String, fileName: String) {
        let app = launchSeededApp(tier: tier, seed: seed)
        openTab(app, "Percepções", nav: "Percepções")
        scrollInsightsTowardContent(app, tier: tier, seed: seed)
        saveScreenshot(named: fileName)
        app.terminate()
    }

    private func captureTierTabs(tier: String, seed: String) {
        let prefix = "review/\(tier)"
        let app = launchSeededApp(tier: tier, seed: seed)

        openTab(app, "Exercícios", nav: nil)
        saveScreenshot(named: "\(prefix)/categories")

        openTab(app, "Meus PRs", nav: "Meus PRs")
        saveScreenshot(named: "\(prefix)/records")
        openFirstPRDetail(app)
        saveScreenshot(named: "\(prefix)/record-detail")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        _ = app.navigationBars["Meus PRs"].waitForExistence(timeout: 5)

        openTab(app, "Percepções", nav: "Percepções")
        saveScreenshot(named: "\(prefix)/insights-top")
        scrollInsightsTowardContent(app, tier: tier, seed: seed)
        saveScreenshot(named: "\(prefix)/insights-mid")
        app.swipeUp()
        sleep(1)
        saveScreenshot(named: "\(prefix)/insights-bottom")

        openTab(app, "Ajustes", nav: "Ajustes")
        saveScreenshot(named: "\(prefix)/settings")

        app.terminate()
    }

    private func launchSeededApp(tier: String, seed: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR"]
        app.launchEnvironment["UITEST_SKIP_SPLASH"] = "1"
        app.launchEnvironment["UITEST_SKIP_ONBOARDING"] = "1"
        app.launchEnvironment["UITEST_SUBSCRIPTION_TIER"] = tier
        app.launchEnvironment["UITEST_SEED_SCENARIO"] = seed
        app.launchArguments += ["-UITEST_SUBSCRIPTION_TIER", tier]
        app.launchArguments += ["-UITEST_SEED_SCENARIO", seed]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Exercícios"].waitForExistence(timeout: 15), "Tabs não apareceram (\(tier))")
        return app
    }

    private func openTab(_ app: XCUIApplication, _ tab: String, nav: String?) {
        app.tabBars.buttons[tab].tap()
        if let nav {
            _ = app.navigationBars[nav].waitForExistence(timeout: 5)
        } else {
            sleep(1)
        }
    }

    private func openFirstPRDetail(_ app: XCUIApplication) {
        let link = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS[c] 'Squat' OR label CONTAINS[c] 'Deadlift' OR label CONTAINS[c] 'Clean'")).firstMatch
        if link.waitForExistence(timeout: 6) {
            link.tap()
        } else {
            app.cells.firstMatch.tap()
        }
        sleep(2)
    }

    private func capturePRFitnessAppearance(style: String) {
        let app = launchSeededApp(tier: "pro", seed: "proRich")
        // Appearance via SpringBoard is flaky in UITest; we still capture both folders
        // after host `simctl ui` when running the capture script.
        openTab(app, "Meus PRs", nav: "Meus PRs")
        sleep(1)
        saveScreenshot(named: "review/pr-fitness/\(style)/list")
        openFirstPRDetail(app)
        sleep(1)
        saveScreenshot(named: "review/pr-fitness/\(style)/detail-top")
        app.swipeUp()
        sleep(1)
        saveScreenshot(named: "review/pr-fitness/\(style)/detail-mid")
        app.swipeUp()
        sleep(1)
        saveScreenshot(named: "review/pr-fitness/\(style)/detail-bottom")
        app.terminate()
    }

    private func scrollInsightsTowardContent(_ app: XCUIApplication, tier: String, seed: String) {
        guard seed != "empty" else { return }
        let targetID: String
        switch tier {
        case "elite":
            targetID = "insights.elite.section"
        case "pro":
            targetID = "insights.coach.section"
        default:
            targetID = "insights.teaser.pro.cta"
        }
        let target = element(app, identifier: targetID)
        for _ in 0 ..< 5 {
            if target.waitForExistence(timeout: 4) { break }
            app.swipeUp()
        }
    }

    private func saveScreenshot(named name: String) {
        let dir = URL(fileURLWithPath: docsRoot).appendingPathComponent("screenshots", isDirectory: true)
        let url = dir.appendingPathComponent("\(name).png")
        let parent = url.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)
        let data = XCUIScreen.main.screenshot().pngRepresentation
        do {
            try data.write(to: url)
        } catch {
            XCTFail("Falha ao salvar \(url.path): \(error)")
        }
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
