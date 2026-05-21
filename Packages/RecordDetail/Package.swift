// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "RecordDetail",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "RecordDetail", targets: ["RecordDetail"]),
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
            name: "RecordDetail",
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
