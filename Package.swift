// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "english-server",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        
        /// 🕸 JSON Web Token
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        
        /// 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        
        /// 💻 ORM framework
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        
        /// 💽 Postgress driver
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "english-server",
            dependencies: [
                .product(name: "JWT", package: "jwt"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
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
