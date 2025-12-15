// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "extract-info",
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj.git", from: "9.7.2")
    ],
    targets: [
        .executableTarget(
            name: "extract-info",
            dependencies: [
                .product(name: "XcodeProj", package: "XcodeProj")
            ]
        )
    ]
)