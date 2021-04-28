// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Katana",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_15),
  ],
  products: [
    .library(name: "Katana", targets: ["Katana"]),
  ],
  dependencies: [
    .package(url: "https://github.com/malcommac/Hydra.git", .upToNextMinor(from: "2.0.5")),
    .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.2.0")),
    .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.0")),
  ],
  targets: [
    .target(name: "Katana", dependencies: ["Hydra"], path: "Katana"),
    .testTarget(name: "KatanaTests", dependencies: ["Katana", "Quick", "Nimble"], path: "KatanaTests"),
  ]
)
