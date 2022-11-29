// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "sss-conf",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", from: "2.4.0"),
        .package(url: "https://github.com/swift-cloud/ComputeUI", branch: "main"),
        .package(url: "https://github.com/swift-cloud/Planetscale", branch: "ab/cache-policy")
    ],
    targets: [
        .executableTarget(name: "Hello", dependencies: ["Compute"]),
        .executableTarget(name: "Database", dependencies: ["Compute", "Planetscale"]),
        .executableTarget(name: "Website", dependencies: ["ComputeUI", "Planetscale"])
    ]
)

