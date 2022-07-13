// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "english-server",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        
        /// 🕸 JSON Web Token
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0"),
        
        /// 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        /// 💻 ORM framework
        
        
        /// 💽 SQLite driver
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0")
    ],
    targets: [
        .executableTarget(
            name: "english-server",
            dependencies: [
                .product(name: "JWT", package: "jwt"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "FluentSQLite", package: "fluent-sqlite")
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
