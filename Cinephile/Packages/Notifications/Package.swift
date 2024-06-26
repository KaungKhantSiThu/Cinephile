// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Notifications",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Notifications",
            targets: ["Notifications"]),
    ],
    dependencies: [
      .package(name: "Networking", path: "../Networking"),
      .package(name: "Models", path: "../Models"),
      .package(name: "Environment", path: "../Environment"),
      .package(name: "Status", path: "../Status"),
      .package(name: "CinephileUI", path: "../CinephileUI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Notifications",
            dependencies: [
                .product(name: "Networking", package: "Networking"),
                .product(name: "Models", package: "Models"),
                .product(name: "Environment", package: "Environment"),
                .product(name: "Status", package: "Status"),
                .product(name: "CinephileUI", package: "CinephileUI"),
              ]
        )
    ]
)
