// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Localization",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Localization",
            targets: ["Localization"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Localization",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "LocalizationTests",
            dependencies: ["Localization"]
        ),
    ]
)
