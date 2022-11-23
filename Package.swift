
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "sss-conf",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/AndrewBarba/Compute", branch: "main")
    ],
    targets: [
        .executableTarget(name: "Hello", dependencies: ["Compute"]),
        .executableTarget(name: "Planetscale", dependencies: ["Compute"])
    ]
)

