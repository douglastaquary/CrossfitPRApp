// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PROUpgrade",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "PROUpgrade", targets: ["PROUpgrade"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Subscription"),
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
    ],
    targets: [
        .target(
            name: "PROUpgrade",
            dependencies: ["Domain", "Subscription", "Localization", "SharedUI"]
        ),
    ]
)
