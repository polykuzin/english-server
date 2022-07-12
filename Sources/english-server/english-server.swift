//
//  english-server.swift
//  
//
//  Created by polykuzin on 07/07/2022.
//

import Vapor
import FluentSQLite

@main
public struct english_server {
    
    public static func main() async throws {
        let webapp = Application()
        webapp.post("reflect", use: Self.reflect(_:))
        try webapp.run()
    }
    
    static func reflect(_ req: Request) async throws -> String {
        if let body = req.body.string {
            return body
        }
        throw Abort(.badRequest)
    }
}

public func routes(_ router: Router) throws {
    let accountController = AccountController(userService: AccountService)
    try router.register(collection: accountController)
}

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    try services.register(FluentSQLiteProvider())
    let sqlite = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)database.db"))
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: Account.self, database: .sqlite)
    migrations.add(model: RefreshToken.self, database: .sqlite)
    
    services.register(migrations)
}

