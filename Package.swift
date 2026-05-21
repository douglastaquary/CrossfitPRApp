// swift-tools-version: 5.7

import PackageDescription

/// Pacote monolítico na raiz — necessário para compatibilidade com Xcode 14 (sem dependências locais aninhadas).
let package = Package(
    name: "CrossfitPRPackages",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Localization", targets: ["Localization"]),
        .library(name: "Persistence", targets: ["Persistence"]),
        .library(name: "Subscription", targets: ["Subscription"]),
        .library(name: "WorkoutEngine", targets: ["WorkoutEngine"]),
        .library(name: "Application", targets: ["Application"]),
        .library(name: "PRHistory", targets: ["PRHistory"]),
        .library(name: "PROUpgrade", targets: ["PROUpgrade"]),
        .library(name: "Onboarding", targets: ["Onboarding"]),
        .library(name: "Insights", targets: ["Insights"]),
    ],
    targets: [
        .target(
            name: "Domain",
            path: "Packages/Domain/Sources/Domain"
        ),
        .target(
            name: "Localization",
            dependencies: ["Domain"],
            path: "Packages/Localization/Sources/Localization",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "Persistence",
            dependencies: ["Domain"],
            path: "Packages/Persistence/Sources/Persistence"
        ),
        .target(
            name: "Subscription",
            dependencies: ["Domain"],
            path: "Packages/Subscription/Sources/Subscription"
        ),
        .target(
            name: "WorkoutEngine",
            dependencies: ["Domain", "Localization"],
            path: "Packages/WorkoutEngine/Sources/WorkoutEngine"
        ),
        .target(
            name: "Application",
            dependencies: [
                "Domain",
                "Localization",
                "Persistence",
                "Subscription",
                "WorkoutEngine",
            ],
            path: "Packages/Application/Sources/Application"
        ),
        .target(
            name: "PRHistory",
            dependencies: ["Domain", "Application", "Localization"],
            path: "Packages/PRHistory/Sources/PRHistory"
        ),
        .target(
            name: "PROUpgrade",
            dependencies: ["Domain", "Subscription", "Localization"],
            path: "Packages/PROUpgrade/Sources/PROUpgrade"
        ),
        .target(
            name: "Onboarding",
            dependencies: ["Localization"],
            path: "Packages/Onboarding/Sources/Onboarding"
        ),
        .target(
            name: "Insights",
            dependencies: [
                "Domain",
                "Application",
                "Subscription",
                "PROUpgrade",
                "Localization",
            ],
            path: "Packages/Insights/Sources/Insights"
        ),
    ]
)
