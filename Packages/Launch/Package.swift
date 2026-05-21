// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Launch",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Launch", targets: ["Launch"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Application"),
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
        .package(path: "../Onboarding"),
    ],
    targets: [
        .target(
            name: "Launch",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "Onboarding",
            ]
        ),
    ]
)
