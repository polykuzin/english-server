//
//  routes.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    do {
        let accountController = AccountController()
        try app.register(collection: accountController)
    } catch {
        fatalError()
    }
    try app.register(collection: AdminRoutes())
    
    app.get(":key") { req -> EventLoopFuture<Response> in
      guard let searchKey = req.parameters.get("key") else {
        throw Abort(.badRequest)
      }

      return Link.query(on: req.db)
        .filter(\.$shortUrl == searchKey)
        .first()
        .unwrap(or: Abort(.notFound))
        .map { link -> Response in
          return req.redirect(to: link.longUrl, type: .permanent)
        }
    }
}
