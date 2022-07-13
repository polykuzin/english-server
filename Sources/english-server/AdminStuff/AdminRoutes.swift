//
//  AdminRoutes.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor
import Fluent
import FluentPostgresDriver

final class AdminRoutes: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped(APIKeyCheck())
        protected.group("admin") { admin in
//    curl -i -X POST -H "Content-Type: application/json"\
//    -H "x-api-key: 4310f636-43ec-41ba-aa34-b3e3c378d687"\
//    -d '{"shortUrl": "test", "longUrl": "http://www.example.com"}'\
//    http://localhost:8080/admin/shorten
            admin.post("shorten") { req -> EventLoopFuture<HTTPStatus> in
                let link = try req.content.decode(Link.self)
                
                let linkDoesNotExist = Link.query(on: req.db)
                    .filter(\.$shortUrl == link.shortUrl)
                    .first()
                    .flatMapThrowing { foundLink -> Link? in
                        guard foundLink == nil else {
                            throw Abort(.conflict)
                        }
                        return nil
                    }
                
                return linkDoesNotExist.flatMap { _ in
                    return link.save(on: req.db).transform(to: HTTPStatus.created)
                }
            }
//    curl -i -X DELETE\
//    -H "x-api-key: 4310f636-43ec-41ba-aa34-b3e3c378d687"\
//    http://localhost:8080/admin/test
            admin.delete(":key") { req -> EventLoopFuture<HTTPStatus> in
                guard let searchKey = req.parameters.get("key") else {
                    throw Abort(.badRequest)
                }
                
                let recordToDelete = Link.query(on: req.db)
                    .filter(\.$shortUrl == searchKey)
                    .first()
                
                return recordToDelete.flatMap { link -> EventLoopFuture<HTTPStatus> in
                    guard let link = link else {
                        return req.eventLoop.future(HTTPStatus.notFound)
                    }
                    return link.delete(on: req.db).transform(to: HTTPStatus.noContent)
                }
            }
//    curl -i -X GET\
//    -H "x-api-key: 4310f636-43ec-41ba-aa34-b3e3c378d687"\
//    http://localhost:8080/admin/test
            admin.get(":key") { req -> EventLoopFuture<Link> in
                guard let searchKey = req.parameters.get("key") else {
                    throw Abort(.badRequest)
                }
                
                return Link.query(on: req.db)
                    .filter(\.$shortUrl == searchKey)
                    .first()
                    .unwrap(or: Abort(.notFound))
            }
        }
    }
}

