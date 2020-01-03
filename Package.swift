// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Katana",
  platforms: [
    .iOS(.v9),
    .macOS(.v10_10)
  ],
  products: [
    .library(name: "Katana", targets: ["Katana"]),
  ],
  dependencies: [
    .package(url: "https://github.com/malcommac/Hydra.git", from: "1.2.1"),
    .package(url: "https://github.com/Quick/Quick.git", from: "1.3.4"),
    .package(url: "https://github.com/Quick/Nimble.git", from: "7.3.4")
  ],
  targets: [
    .target(name: "Katana", dependencies: ["Hydra"], path: "Katana"),
    .testTarget(name: "KatanaTests", dependencies: ["Katana", "Quick", "Nimble"], path: "KatanaTests")
  ]
)
