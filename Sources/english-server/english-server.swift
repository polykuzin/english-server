//
//  english-server.swift
//  
//
//  Created by polykuzin on 07/07/2022.
//

import Vapor

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
