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
        .library(name: "BCFileHelper", targets: ["BCFileHelper"]),
        .library(name: "BCURLSessionHelper", targets: ["BCURLSessionHelper"]),
    ],
    targets: [
        .target(name: "BetterCodable"),
        .target(name: "BCFileHelper", dependencies: ["BetterCodable"]),
        .target(name: "BCURLSessionHelper", dependencies: ["BetterCodable"]),
        .testTarget(name: "BetterCodableTests", dependencies: ["BetterCodable", "BCFileHelper", "BCURLSessionHelper"]),
    ]
)
