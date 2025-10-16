// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PWhisper",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "PWhisper",
            targets: ["PWhisper"])
    ],
    targets: [
        .executableTarget(
            name: "PWhisper",
            dependencies: [],
            path: "Sources",
            exclude: ["Info.plist"])
    ]
)
