// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "sss-conf",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", from: "2.7.0"),
        .package(url: "https://github.com/swift-cloud/ComputeUI", from: "1.0.0"),
        .package(url: "https://github.com/swift-cloud/PlanetScale", from: "1.3.0")
    ],
    targets: [
        .executableTarget(name: "Hello", dependencies: ["Compute"]),
        .executableTarget(name: "Database", dependencies: ["Compute", "PlanetScale"]),
        .executableTarget(name: "Website", dependencies: ["ComputeUI", "PlanetScale"])
    ]
)

