import XCTest

/// UI — fluxo de pagamento PRO/Elite no simulador (MockSubscriptionStore).
/// Cenários: compra OK, cancel (sem sheet Apple), restore sem compra, fail.
/// Ver `docs/STOREKIT-PAYMENTS.md` e `scripts/test-payments.sh`.
final class PaymentFlowUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPurchaseProMonthlySucceedsPortuguese() throws {
        let app = paymentApp(languageCode: "pt-BR", purchaseBehavior: "succeed")
        app.launch()

        openUpgradeSheet(app)
        selectProduct(app, key: "proMonthly")
        tapContinuePayment(app)

        XCTAssertTrue(
            waitForPurchaseOutcome(app, success: true, timeout: 15),
            "Esperava sucesso (overlay) ou dismiss após compra mock"
        )
    }

    func testPurchaseCancelReturnsToSheetPortuguese() throws {
        let app = paymentApp(languageCode: "pt-BR", purchaseBehavior: "cancel")
        app.launch()

        openUpgradeSheet(app)
        selectProduct(app, key: "proMonthly")
        tapContinuePayment(app)

        // Cancel mock → idle silencioso (overlay pode ser <250ms; succeed/fail cobrem o tap).
        RunLoop.current.run(until: Date().addingTimeInterval(0.8))

        let close = element(app, identifier: "pro.upgrade.close")
        XCTAssertTrue(close.waitForExistence(timeout: 10), "Cancel deve voltar ao paywall")

        XCTAssertFalse(
            element(app, identifier: "pro.upgrade.error.title").exists,
            "Cancelamento não deve mostrar erro vermelho"
        )
        XCTAssertFalse(
            element(app, identifier: "pro.upgrade.success.title").exists,
            "Cancelamento não deve mostrar sucesso"
        )

        close.tap()
        let insightsTab = app.tabBars.buttons["Percepções"]
        XCTAssertTrue(
            insightsTab.waitForExistence(timeout: 5) || app.tabBars.buttons["Insights"].waitForExistence(timeout: 2),
            "Deve voltar ao Insights após fechar o paywall"
        )
    }

    func testRestoreWithoutPurchaseShowsClearErrorPortuguese() throws {
        let app = paymentApp(languageCode: "pt-BR", purchaseBehavior: "succeed")
        app.launch()

        openUpgradeSheet(app)
        scrollPaywallUntilHittable(app, identifier: "pro.upgrade.restore")

        let restore = element(app, identifier: "pro.upgrade.restore")
        XCTAssertTrue(restore.waitForExistence(timeout: 8), "Botão Restaurar")
        restore.tap()

        let errorTitle = element(app, identifier: "pro.upgrade.error.title")
        let retry = element(app, identifier: "pro.upgrade.error.retry")
        XCTAssertTrue(
            errorTitle.waitForExistence(timeout: 12) || retry.waitForExistence(timeout: 2),
            "Restore vazio deve mostrar erro claro"
        )

        if retry.exists {
            retry.tap()
        } else if element(app, identifier: "pro.upgrade.error.retry").waitForExistence(timeout: 3) {
            element(app, identifier: "pro.upgrade.error.retry").tap()
        }

        XCTAssertTrue(element(app, identifier: "pro.upgrade.close").waitForExistence(timeout: 5))
    }

    func testPurchaseFailShowsActionableErrorEnglish() throws {
        let app = paymentApp(languageCode: "en", purchaseBehavior: "fail")
        app.launch()

        openUpgradeSheet(app)
        selectProduct(app, key: "proMonthly")
        tapContinuePayment(app)

        XCTAssertTrue(
            waitForPurchaseOutcome(app, success: false, timeout: 15),
            "Falha de compra deve mostrar erro acionável"
        )
        XCTAssertTrue(
            element(app, identifier: "pro.upgrade.error.retry").waitForExistence(timeout: 3),
            "Botão Tentar de novo"
        )
    }

    /// success=true → success id ou dismiss; success=false → error id / retry.
    private func waitForPurchaseOutcome(
        _ app: XCUIApplication,
        success: Bool,
        timeout: TimeInterval
    ) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if success {
                if element(app, identifier: "pro.upgrade.success.title").exists { return true }
                let sheetGone = !element(app, identifier: "pro.upgrade.close").exists
                let onInsights = app.tabBars.buttons["Percepções"].exists || app.tabBars.buttons["Insights"].exists
                if sheetGone && onInsights { return true }
            } else if element(app, identifier: "pro.upgrade.error.title").exists
                        || element(app, identifier: "pro.upgrade.error.retry").exists {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.35))
        }
        return false
    }

    // MARK: - Helpers

    private func paymentApp(languageCode: String, purchaseBehavior: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(\(languageCode))"]
        let locale = languageCode == "en" ? "en_US" : "pt_BR"
        app.launchArguments += ["-AppleLocale", locale]
        app.launchArguments += ["-UITEST_SKIP_SPLASH", "1", "-UITEST_SKIP_ONBOARDING", "1"]
        app.launchEnvironment["UITEST_SKIP_SPLASH"] = "1"
        app.launchEnvironment["UITEST_SKIP_ONBOARDING"] = "1"
        app.launchEnvironment["UITEST_SUBSCRIPTION_TIER"] = "free"
        app.launchEnvironment["UITEST_PURCHASE_BEHAVIOR"] = purchaseBehavior
        return app
    }

    private func openUpgradeSheet(_ app: XCUIApplication) {
        waitForMainShell(app)

        // Só a tab selecionada expõe accessibilityIdentifier; usar label localizado do TabBar.
        let pt = app.tabBars.buttons["Percepções"]
        let en = app.tabBars.buttons["Insights"]
        if pt.waitForExistence(timeout: 8) {
            pt.tap()
        } else {
            XCTAssertTrue(en.waitForExistence(timeout: 4), "Tab Insights (Evolução/Progress)")
            en.tap()
        }

        let cta = element(app, identifier: "insights.teaser.pro.cta")
        XCTAssertTrue(cta.waitForExistence(timeout: 12), "CTA teaser PRO")
        cta.tap()

        XCTAssertTrue(
            element(app, identifier: "pro.upgrade.close").waitForExistence(timeout: 10),
            "Sheet PRO deve abrir"
        )
    }

    private func selectProduct(_ app: XCUIApplication, key: String) {
        let id = "pro.upgrade.product.\(key)"
        scrollPaywallUntilHittable(app, identifier: id)
        let product = element(app, identifier: id)
        XCTAssertTrue(product.waitForExistence(timeout: 8), "Produto \(key)")
        product.tap()
    }

    private func tapContinuePayment(_ app: XCUIApplication) {
        scrollPaywallUntilHittable(app, identifier: "pro.upgrade.continue.payment")
        let byId = element(app, identifier: "pro.upgrade.continue.payment")
        XCTAssertTrue(byId.waitForExistence(timeout: 8))

        // Preferir query de Button + label (hit-test mais confiável no sheet).
        let pt = app.buttons["Continuar para o pagamento"]
        let en = app.buttons["Continue to payment"]
        if pt.exists && pt.isHittable {
            pt.tap()
        } else if en.exists && en.isHittable {
            en.tap()
        } else {
            byId.tap()
        }
    }

    private func scrollPaywallUntilHittable(
        _ app: XCUIApplication,
        identifier: String,
        maxSwipes: Int = 16
    ) {
        let target = element(app, identifier: identifier)
        let paywallScroll = element(app, identifier: "pro.upgrade.scroll")
        let screenHeight = app.frame.height
        for _ in 0..<maxSwipes {
            if target.exists {
                let midY = target.frame.midY
                // Evita botão “hittable” colado na home indicator (tap no-op).
                if target.isHittable && midY > 140 && midY < screenHeight - 120 {
                    return
                }
            }
            if paywallScroll.exists {
                paywallScroll.swipeUp()
            } else if app.scrollViews.firstMatch.exists {
                app.scrollViews.firstMatch.swipeUp()
            } else {
                app.swipeUp()
            }
        }
    }

    private func waitForMainShell(_ app: XCUIApplication) {
        let tabBar = app.tabBars.firstMatch
        let categoriesTab = element(app, identifier: "tab.categories")
        let appeared = tabBar.waitForExistence(timeout: 30) || categoriesTab.waitForExistence(timeout: 30)
        XCTAssertTrue(appeared, "Tab shell não apareceu")
    }

    /// Query por identifier com NSPredicate — evita path parsing de "." no XCTest.
    private func element(_ app: XCUIApplication, identifier: String) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "identifier == %@", identifier))
            .firstMatch
    }
}
