// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Account",
    defaultLocalization: "en",
    platforms: [
      .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Account",
            targets: ["Account"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Environment", path: "../Environment"),
        .package(name: "Networking", path: "../Networking"),
        .package(name: "CinephileUI", path: "../CinephileUI"),
        .package(name: "Status", path: "../Status"),
        .package(url: "https://github.com/Dean151/ButtonKit", from: "0.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Account",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Environment", package: "Environment"),
                .product(name: "Networking", package: "Networking"),
                .product(name: "CinephileUI", package: "CinephileUI"),
                .product(name: "Status", package: "Status"),
                .product(name: "ButtonKit", package: "ButtonKit"),
            ]
        )
    ]
)
