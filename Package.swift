// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Katana",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_10)
  ],
  products: [
    .library(name: "Katana", targets: ["Katana"]),
  ],
  dependencies: [
    .package(url: "https://github.com/malcommac/Hydra.git", .upToNextMinor(from: "2.0.6")),
  ],
  targets: [
    .target(name: "Katana", dependencies: ["Hydra"], path: "Katana"),
    .testTarget(name: "KatanaTests", dependencies: ["Katana"], path: "KatanaTests")
  ]
)
