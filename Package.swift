// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "english-server",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        /// 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        
        /// 🔵 Swift ORM (queries, models, relations, etc) built on PostgreSQL.,
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        
        /// 🚀  Event-driven network application framework for high performance protocol servers & clients, non-blocking.
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.35.0"),
        
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Vapor", package: "vapor"),
            "Data"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .target(name: "Domain", dependencies: [
            .product(name: "NIO", package: "swift-nio")
        ]),
        .target(name: "Data", dependencies: [
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            "Domain"
        ]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
