// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Insights",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Insights", targets: ["Insights"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Application"),
        .package(path: "../Subscription"),
        .package(path: "../PROUpgrade"),
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
    ],
    targets: [
        .target(
            name: "Insights",
            dependencies: [
                "Domain",
                "Application",
                "Subscription",
                "PROUpgrade",
                "Localization",
                "SharedUI",
            ]
        ),
    ]
)
