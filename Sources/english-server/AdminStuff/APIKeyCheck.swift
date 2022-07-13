//
//  APIKeyCheck.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor

// Development and Test key 4310f636-43ec-41ba-aa34-b3e3c378d687

struct APIKeyCheck : Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard
            let apiKey: String = request.headers["ADMIN_KEY"].first,
            let storedKey = Environment.get("ADMIN_KEY"),
            apiKey == storedKey
        else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        return next.respond(to: request)
    }
}
