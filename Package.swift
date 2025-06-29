// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "BetterCodable",
    products: [
        .library(name: "BetterCodable", targets: ["BetterCodable"]),
    ],
    traits: [
        "BCFileHelper",
        .default(enabledTraits: ["BCFileHelper"]),
    ],
    targets: [
        .target(name: "BetterCodable"),
        .testTarget(name: "BetterCodableTests", dependencies: ["BetterCodable"]),
    ]
)
