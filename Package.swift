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
        .library(name: "SharedUI", targets: ["SharedUI"]),
        .library(name: "Persistence", targets: ["Persistence"]),
        .library(name: "Subscription", targets: ["Subscription"]),
        .library(name: "WorkoutEngine", targets: ["WorkoutEngine"]),
        .library(name: "Application", targets: ["Application"]),
        .library(name: "RecordDetail", targets: ["RecordDetail"]),
        .library(name: "PRHistory", targets: ["PRHistory"]),
        .library(name: "Categories", targets: ["Categories"]),
        .library(name: "Settings", targets: ["Settings"]),
        .library(name: "PROUpgrade", targets: ["PROUpgrade"]),
        .library(name: "Onboarding", targets: ["Onboarding"]),
        .library(name: "Launch", targets: ["Launch"]),
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
            name: "SharedUI",
            dependencies: ["Domain", "Localization"],
            path: "Packages/SharedUI/Sources/SharedUI"
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
            name: "RecordDetail",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "Subscription",
                "PROUpgrade",
            ],
            path: "Packages/RecordDetail/Sources/RecordDetail"
        ),
        .target(
            name: "PRHistory",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "RecordDetail",
            ],
            path: "Packages/PRHistory/Sources/PRHistory"
        ),
        .target(
            name: "Categories",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "PRHistory",
            ],
            path: "Packages/Categories/Sources/Categories"
        ),
        .target(
            name: "Settings",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "Subscription",
                "PROUpgrade",
            ],
            path: "Packages/Settings/Sources/Settings"
        ),
        .target(
            name: "PROUpgrade",
            dependencies: ["Domain", "Subscription", "Localization", "SharedUI"],
            path: "Packages/PROUpgrade/Sources/PROUpgrade"
        ),
        .target(
            name: "Launch",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "Onboarding",
            ],
            path: "Packages/Launch/Sources/Launch"
        ),
        .target(
            name: "Onboarding",
            dependencies: ["Localization", "SharedUI"],
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
                "SharedUI",
            ],
            path: "Packages/Insights/Sources/Insights"
        ),
    ]
)
