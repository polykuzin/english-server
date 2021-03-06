//
//  configure.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(Logging())
    app.databases.use(
        .postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ),
        as: .psql
    )
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateLinks())
    
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    
    try routes(app)
}
