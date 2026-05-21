// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "WorkoutEngine",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "WorkoutEngine",
            targets: ["WorkoutEngine"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Localization", path: "../Localization"),
    ],
    targets: [
        .target(
            name: "WorkoutEngine",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Localization", package: "Localization"),
            ]
        ),
        .testTarget(
            name: "WorkoutEngineTests",
            dependencies: ["WorkoutEngine"]
        ),
    ]
)
