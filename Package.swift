// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenWeatherClient",
    products: [
        .library(
            name: "OpenWeatherClient",
            targets: ["OpenWeatherClient"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "OpenWeatherClient",
            dependencies: []),
        .testTarget(
            name: "OpenWeatherClientTests",
            dependencies: ["OpenWeatherClient"]),
    ]
)
