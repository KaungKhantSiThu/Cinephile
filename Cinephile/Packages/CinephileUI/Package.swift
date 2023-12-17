// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CinephileUI",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CinephileUI",
            targets: ["CinephileUI"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Environment", path: "../Environment"),
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CinephileUI",
            dependencies: [
              .product(name: "Models", package: "Models"),
              .product(name: "Environment", package: "Environment"),
              .product(name: "NukeUI", package: "Nuke"),
              .product(name: "Nuke", package: "Nuke"),
            ]
        ),
        .testTarget(
            name: "CinephileUITests",
            dependencies: ["CinephileUI"]),
    ]
)

