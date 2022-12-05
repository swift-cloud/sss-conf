// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "sss-conf",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", from: "2.5.0"),
        .package(url: "https://github.com/swift-cloud/ComputeUI", from: "1.0.0"),
        .package(url: "https://github.com/swift-cloud/Planetscale", from: "1.1.0")
    ],
    targets: [
        .executableTarget(name: "Hello", dependencies: ["Compute"]),
        .executableTarget(name: "Database", dependencies: ["Compute", "Planetscale"]),
        .executableTarget(name: "Website", dependencies: ["ComputeUI", "Planetscale"])
    ]
)

