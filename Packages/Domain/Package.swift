// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Domain",
    defaultLocalization: "pt-BR",
    // iOS = produto (iPhone/iPad; Watch via app).
    // macOS = só para `swift test` no host do CI — NÃO há app Mac (ver project.yml).
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
