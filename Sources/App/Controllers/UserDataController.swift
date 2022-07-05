//
//  UserDataController.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor

struct UserDataController : RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "user")
        usersRoutes.get(":id", use: getUser(_:))
        usersRoutes.post(use: createUser(_:))
        
        let basicAuthMiddleware = UserData.authenticator()
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: login(_:))
    }
    
    func getUser(_ req: Request) -> EventLoopFuture<UserData.Public> {
        UserData.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func createUser(_ req: Request) throws -> EventLoopFuture<UserData.Public> {
        do {
            let user = try req.content.decode(UserData.self)
            user.password = try Bcrypt.hash(user.password)
            return user.save(on: req.db).map {
                user.convertToPublic()
            }
        } catch is DecodingError {
            throw Abort(.badRequest)
        } catch is BcryptError {
            throw Abort(.internalServerError)
        }
    }
    
    func login(_ req: Request) throws -> EventLoopFuture<Token> {
        do {
            let user = try req.auth.require(UserData.self)
            let token = try Token.generate(for: user)
            return token.save(on: req.db).map { token }
        } catch {
            throw error
        }
    }
}
