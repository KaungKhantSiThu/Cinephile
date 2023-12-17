// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Environment",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Environment",
            targets: ["Environment"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Networking", path: "../Networking"),
        .package(url: "https://github.com/adamayoung/TMDb", exact: "10.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Environment",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Networking", package: "Networking"),
                .product(name: "TMDb", package: "TMDb")
            ]),
        .testTarget(
            name: "EnvironmentTests",
            dependencies: ["Environment"]),
    ]
)
