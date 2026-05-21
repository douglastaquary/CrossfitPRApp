// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Insights",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Insights",
            targets: ["Insights"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Application", path: "../Application"),
        .package(name: "Subscription", path: "../Subscription"),
        .package(name: "PROUpgrade", path: "../PROUpgrade"),
        .package(name: "Localization", path: "../Localization"),
    ],
    targets: [
        .target(
            name: "Insights",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Application", package: "Application"),
                .product(name: "Subscription", package: "Subscription"),
                .product(name: "PROUpgrade", package: "PROUpgrade"),
                .product(name: "Localization", package: "Localization"),
            ]
        ),
    ]
)
