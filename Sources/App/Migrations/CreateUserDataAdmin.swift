//
//  CreateUserDataAdmin.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor
import Fluent

struct CreateUserDataAdmin : Migration {
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        UserDataDTO.query(on: database)
            .filter(\.$username == "admin")
            .delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let passwordHash : String
        do {
            passwordHash = try Bcrypt.hash("password")
        } catch {
            return database.eventLoop.future(error: error)
        }
        let user = UserDataDTO(
            email: "polykuzin@gmail.com",
            username: "admin",
            password: passwordHash
        )
        return user.save(on: database)
    }
}
