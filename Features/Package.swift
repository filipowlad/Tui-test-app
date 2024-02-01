// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Features",
            targets: ["Features"]),
    ],
    dependencies: [
        .package(path: "../API"),
        .package(path: "../Helpers"),
        .package(path: "../Components")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Features",
            dependencies: [
                .product(name: "API", package: "API"),
                .product(name: "Helpers", package: "Helpers"),
                .product(name: "Components", package: "Components")
            ]
        ),
        .testTarget(
            name: "FeaturesTests",
            dependencies: [
                "Features",
                .product(name: "API", package: "API"),
                .product(name: "Helpers", package: "Helpers"),
                .product(name: "Components", package: "Components")
            ])
    ]
)
