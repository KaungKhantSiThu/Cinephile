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
        .library(
            name: "TrackerUI",
            targets: ["TrackerUI"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Environment", path: "../Environment"),
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0"),
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "10.0.0"),
        .package(url: "https://github.com/divadretlaw/EmojiText", from: "3.2.1"),
        .package(url: "https://github.com/SvenTiigi/YouTubePlayerKit.git", from: "1.6.0"),
        .package(name: "MediaClient", path: "../MediaClient"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CinephileUI",
            dependencies: [
              "Models",
              "Environment",
              .product(name: "NukeUI", package: "Nuke"),
              .product(name: "EmojiText", package: "EmojiText")
            ]
        ),
        .target(
            name: "TrackerUI",
            dependencies: [
                "CinephileUI",
                "TMDb",
                "Environment",
                .product(name: "NukeUI", package: "Nuke"),
                "YouTubePlayerKit",
                .product(name: "MediaClient", package: "MediaClient")
            ]
        ),
        .testTarget(
            name: "CinephileUITests",
            dependencies: ["CinephileUI"]),
    ]
)

