// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Status",
    defaultLocalization: "en",
    platforms: [
      .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Status",
            targets: ["Status"]),
    ],
    dependencies: [
      .package(name: "AppAccount", path: "../AppAccount"),
      .package(name: "Models", path: "../Models"),
      .package(name: "Networking", path: "../Networking"),
      .package(name: "Environment", path: "../Environment"),
      .package(name: "CinephileUI", path: "../CinephileUI"),
      .package(url: "https://github.com/nicklockwood/LRUCache.git", from: "1.0.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Status",
            dependencies: [
              .product(name: "AppAccount", package: "AppAccount"),
              .product(name: "Models", package: "Models"),
              .product(name: "Networking", package: "Networking"),
              .product(name: "Environment", package: "Environment"),
              .product(name: "LRUCache", package: "lrucache"),
              .product(name: "CinephileUI", package: "CinephileUI"),
            ]
        ),
        .testTarget(
            name: "StatusTests",
            dependencies: ["Status"]),
    ]
)
