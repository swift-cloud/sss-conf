// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "sss-conf",
    dependencies: [
        .package(url: "https://github.com/AndrewBarba/Compute", branch: "main"),
        .package(url: "https://github.com/TokamakUI/Tokamak.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "sss-conf", 
            dependencies: ["Compute", .product(name: "TokamakStaticHTML", package: "Tokamak")]
        )
    ]
)
