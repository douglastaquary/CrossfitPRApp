// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Coaching",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Coaching", targets: ["Coaching"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Coaching",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
            ],
            path: "Sources/Coaching"
        ),
        .testTarget(
            name: "CoachingTests",
            dependencies: ["Coaching"],
            path: "Tests/CoachingTests"
        ),
    ]
)
