// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SharedUI",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SharedUI", targets: ["SharedUI"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Localization"),
    ],
    targets: [
        .target(
            name: "SharedUI",
            dependencies: ["Domain", "Localization"]
        ),
    ]
)
