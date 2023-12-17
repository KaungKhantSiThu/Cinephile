// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AppAccount",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "AppAccount",
      targets: ["AppAccount"]
    ),
  ],
  dependencies: [
    .package(name: "Networking", path: "../Networking"),
    .package(name: "Models", path: "../Models"),
    .package(name: "Environment", path: "../Environment"),
    .package(name: "CinephileUI", path: "../CinephileUI"),
  ],
  targets: [
    .target(
      name: "AppAccount",
      dependencies: [
        .product(name: "Networking", package: "Networking"),
        .product(name: "Models", package: "Models"),
        .product(name: "Environment", package: "Environment"),
        .product(name: "CinephileUI", package: "CinephileUI"),
      ]
    ),
  ]
)
