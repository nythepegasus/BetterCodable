// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "NYDecodable",
    products: [
        .library(name: "NYDecodable", targets: ["NYDecodable"]),
        .library(name: "NYDecodableErrorLoggers", targets: ["NYDecodable", "NYDecodableErrorLoggers"]),
    ],
    targets: [
        .target(name: "NYDecodable"),
        .target(name: "NYDecodableErrorLoggers", dependencies: ["NYDecodable"]),
        .testTarget(name: "NYDecodableTests",
                    dependencies: ["NYDecodable", "NYDecodableErrorLoggers"]
        ),
    ]
)
