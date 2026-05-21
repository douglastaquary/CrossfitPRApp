// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Settings",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Settings", targets: ["Settings"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Application"),
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
        .package(path: "../Subscription"),
        .package(path: "../PROUpgrade"),
    ],
    targets: [
        .target(
            name: "Settings",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "Subscription",
                "PROUpgrade",
            ]
        ),
    ]
)
