// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "NYDecodable",
    products: [
        .library(name: "NYDecodable", targets: ["NYDecodable"]),
    ],
    targets: [
        .target(name: "NYDecodable"),
        .testTarget(name: "NYDecodableTests",
                    dependencies: ["NYDecodable"]
        ),
    ]
)
