// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SSF2ConverterApp",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "SSF2ConverterApp",
            path: "Sources/SSF2ConverterApp"
        )
    ]
)
