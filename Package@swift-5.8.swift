// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "BetterCodable",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(name: "BetterCodable", targets: ["BetterCodable"]),
    ],
    targets: [
        .target(name: "BetterCodable"),
        .testTarget(name: "BetterCodableTests", dependencies: ["BetterCodable"]),
    ]
)
