// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "english-server",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(
            url: "https://github.com/vapor/vapor.git",
            from: "4.0.0"
        ),
        .package(
            url: "https://github.com/vapor/fluent.git",
            from: "4.0.0"
        ),
        .package(
            url: "https://github.com/vapor/fluent-postgres-driver.git",
            from: "2.0.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "english-server",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
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
