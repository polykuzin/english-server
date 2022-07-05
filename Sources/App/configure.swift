//
//  configure.swift
//
//
//  Created by polykuzin on 26/06/2022.
//

import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)
    
    app.migrations.add(CreateUserData())
    app.migrations.add(CreateToken())
    
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    
    try routes(app)
}
