// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnomalyDetection",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AnomalyDetection",
            targets: ["AnomalyDetection"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/ambeckley/Normal-and-Student-T-distributions-Swift", branch: "main"),
        .package(url: "https://github.com/ambeckley/Seasonal-Trends-Decomposition-STL-Swift", branch: "main"),
        ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AnomalyDetection",
            dependencies: [
                .product(name: "Distrs", package: "Normal-and-Student-T-distributions-Swift"),
                .product(name: "SeasonalTrendsDecomp", package: "Seasonal-Trends-Decomposition-STL-Swift"),
        ]),
        
        .testTarget(
            name: "AnomalyDetectionTests",
            dependencies: ["AnomalyDetection"]),
    ]
)
