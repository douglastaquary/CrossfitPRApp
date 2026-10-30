// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Subscription",
    defaultLocalization: "pt-BR",
    // iOS = produto (iPhone/iPad; Watch via app).
    // macOS = só para `swift test` no host do CI — NÃO há app Mac (ver project.yml).
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
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
