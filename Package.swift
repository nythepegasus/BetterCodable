// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "BetterCodable",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
    ],
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
