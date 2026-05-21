// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PRHistory",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "PRHistory", targets: ["PRHistory"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Application"),
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
        .package(path: "../RecordDetail"),
    ],
    targets: [
        .target(
            name: "PRHistory",
            dependencies: [
                "Domain",
                "Application",
                "Localization",
                "SharedUI",
                "RecordDetail",
            ]
        ),
    ]
)
