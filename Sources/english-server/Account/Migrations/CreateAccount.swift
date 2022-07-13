//
//  CreateAccount.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor
import Fluent
import FluentPostgresDriver

struct CreateUser : Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("account")
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
