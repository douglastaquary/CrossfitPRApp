// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Application",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Application",
            targets: ["Application"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Localization", path: "../Localization"),
        .package(name: "Persistence", path: "../Persistence"),
        .package(name: "Subscription", path: "../Subscription"),
        .package(name: "WorkoutEngine", path: "../WorkoutEngine"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Localization", package: "Localization"),
                .product(name: "Persistence", package: "Persistence"),
                .product(name: "Subscription", package: "Subscription"),
                .product(name: "WorkoutEngine", package: "WorkoutEngine"),
            ]
        ),
        .testTarget(
            name: "ApplicationTests",
            dependencies: [
                "Application",
                .product(name: "Subscription", package: "Subscription"),
            ]
        ),
    ]
)
