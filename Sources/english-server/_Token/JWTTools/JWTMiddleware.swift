//
//  JWTMiddleware.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import JWT
import Vapor

class JWTMiddleware : Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        if let token = request.http.headers[.authorization].first {
            do {
                try TokenHelpers.verifyToken(token)
                return try next.respond(to: request)
            } catch let error as JWTError {
                throw Abort(.unauthorized, reason: error.reason)
            }
        } else {
            throw Abort(.unauthorized, reason: "No Access Token")
        }
    }
}
