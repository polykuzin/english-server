//
//  AccountController.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor

struct AccountController : RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        // TODO: FOR CATEGORIES
//        let basicAuthMiddleware = Account.authenticator()
//        let guardAuthMiddleware = Account.guardMiddleware()
//        let protected = acronymsRoutes.grouped(basicAuthMiddleware, guardAuthMiddleware)
//        protected.post(use: createHandler)
        let usersRoute = routes.grouped("api", "account")
            
        // TODO: Защитить админским АПИ ключом
        usersRoute.get(use: getAllHandler)
        
        // TODO: Защитить клиентским апи ключом и токеном
        usersRoute.post(use: createHandler)
        usersRoute.get(":accountId", use: getHandler)
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Account.Public> {
        do {
            let account = try req.content.decode(Account.self)
            account.password = try Bcrypt.hash(account.password)
            return account.save(on: req.db).map { account }
                .convertToPublic()
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Account.Public]> {
        Account.query(on: req.db)
            .all()
            .convertToPublic()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<Account.Public> {
        Account.find(req.parameters.get("accountId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
}
