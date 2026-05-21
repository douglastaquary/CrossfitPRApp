// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Categories",
    defaultLocalization: "pt-BR",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Categories", targets: ["Categories"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Application"),
        .package(path: "../Localization"),
        .package(path: "../SharedUI"),
        .package(path: "../PRHistory"),
    ],
    targets: [
        .target(
            name: "Categories",
            dependencies: ["Domain", "Application", "Localization", "SharedUI", "PRHistory"]
        ),
    ]
)
