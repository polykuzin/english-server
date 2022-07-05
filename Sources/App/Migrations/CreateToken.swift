//
//  CreateToken.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Fluent

struct CreateToken : Migration {
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("userId", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }
}
