// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Murmur",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "Murmur",
            targets: ["Murmur"])
    ],
    targets: [
        .executableTarget(
            name: "Murmur",
            dependencies: [],
            path: "Sources",
            exclude: ["Info.plist"])
    ]
)
