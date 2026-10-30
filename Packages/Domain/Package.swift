// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Domain",
    defaultLocalization: "pt-BR",
    // macOS: necessário para `swift test` no CI (host).
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
    ],
    targets: [
        .target(
            name: "Domain"
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]
        ),
    ]
)
