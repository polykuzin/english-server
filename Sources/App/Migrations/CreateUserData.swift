//
//  CreateUserData.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Fluent

struct CreateUserData : Migration {
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .unique(on: "username")
            .create()
    }
}
