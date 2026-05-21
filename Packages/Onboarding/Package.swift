// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Onboarding",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Onboarding", targets: ["Onboarding"]),
    ],
    dependencies: [
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
    ],
    targets: [
        .target(
            name: "Onboarding",
            dependencies: ["Localization", "SharedUI"]
        ),
    ]
)
