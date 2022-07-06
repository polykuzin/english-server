//
//  UserDataController.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import JWT
import Vapor
import Fluent

struct UserDataController : RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "user")
        usersRoutes.post(use: createUser(_:))
        usersRoutes.get(":id", use: getUser(_:))
        usersRoutes.post("apple", use: loginWithApple(_:))
        
        let basicAuthMiddleware = UserDataDTO.authenticator()
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: login(_:))
    }
    
    func getUser(_ req: Request) -> EventLoopFuture<UserDataDTO.Public> {
        UserDataDTO.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .convertToPublic()
    }
    
    func createUser(_ req: Request) throws -> EventLoopFuture<UserDataDTO.Public> {
        do {
            let user = try req.content.decode(UserDataDTO.self)
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
            let user = try req.auth.require(UserDataDTO.self)
            let token = try Token.generate(for: user)
            return token.save(on: req.db).map { token }
        } catch {
            throw error
        }
    }
    
    func loginWithApple(_ req: Request) throws -> EventLoopFuture<Token> {
        let data = try req.content.decode(TokenApple.self)
        guard
            let appIdentifier = Environment.get("IOS_APPLICATION_IDENTIFIER")
        else {
            throw Abort(.internalServerError)
        }
        return req.jwt
            .apple
            .verify(data.token, applicationIdentifier: appIdentifier)
            .flatMap { siwaToken -> EventLoopFuture<Token> in
                UserDataDTO.query(on: req.db)
                    .filter(\.$siwaIdentifier == siwaToken.subject.value)
                    .first()
                    .flatMap { user in
                        let userFuture: EventLoopFuture<UserDataDTO>
                        if let user = user {
                            userFuture = req.eventLoop.future(user)
                        } else {
                            guard
                                let email = siwaToken.email
                            else {
                                return req.eventLoop
                                    .future(error: Abort(.badRequest))
                            }
                            let user = UserDataDTO(
                                email: email,
                                username: email,
                                password: UUID().uuidString,
                                siwaIdentifier: siwaToken.subject.value
                            )
                            userFuture = user.save(on: req.db).map { user }
                        }
                        return userFuture.flatMap { user in
                            let token: Token
                            do {
                                token = try Token.generate(for: user)
                            } catch {
                                return req.eventLoop.future(error: error)
                            }
                            return token.save(on: req.db).map { token }
                        }
                    }
            }
    }
}
