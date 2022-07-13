//
//  Logging.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor

final class Logging: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).map { res in
            if res.status == .movedPermanently {
                request.logger.info("[REDIRECT] \(request.url.path) -> \(res.headers[.location])")
            }
            return res
        }
    }
}
