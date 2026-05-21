// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Subscription",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Subscription",
            targets: ["Subscription"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Subscription",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
            ]
        ),
        .testTarget(
            name: "SubscriptionTests",
            dependencies: ["Subscription"]
        ),
    ]
)
