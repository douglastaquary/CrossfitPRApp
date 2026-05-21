// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PROUpgrade",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "PROUpgrade",
            targets: ["PROUpgrade"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Subscription", path: "../Subscription"),
        .package(name: "Localization", path: "../Localization"),
    ],
    targets: [
        .target(
            name: "PROUpgrade",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Subscription", package: "Subscription"),
                .product(name: "Localization", package: "Localization"),
            ]
        ),
    ]
)
