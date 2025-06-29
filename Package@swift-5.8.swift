// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "BetterCodable",
    products: [
        .library(name: "BetterCodable", targets: ["BetterCodable"]),
    ],
    targets: [
        .target(name: "BetterCodable"),
        .testTarget(name: "BetterCodableTests", dependencies: ["BetterCodable"]),
    ]
)
