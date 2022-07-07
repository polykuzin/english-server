// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "english-server",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        /// 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "english-server",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            resources: [
                .copy("menu.json")
            ]
        ),
        .testTarget(
            name: "english-server-tests",
            dependencies: [
                "english-server"
            ]
        )
    ]
)
