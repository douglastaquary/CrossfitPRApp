// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PRHistory",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "PRHistory",
            targets: ["PRHistory"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Application", path: "../Application"),
        .package(name: "Localization", path: "../Localization"),
    ],
    targets: [
        .target(
            name: "PRHistory",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Application", package: "Application"),
                .product(name: "Localization", package: "Localization"),
            ]
        ),
    ]
)
