// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Persistence",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Persistence",
            targets: ["Persistence"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Persistence",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
            ]
        ),
        .testTarget(
            name: "PersistenceTests",
            dependencies: ["Persistence"]
        ),
    ]
)
