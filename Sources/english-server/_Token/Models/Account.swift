//
//  Account.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import Vapor
import FluentSQLite

final class Account : SQLiteModel {
    var id : Int?
    
    var login : String
    
    var password : String
    
    init(id: Int? = nil, login: String, password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
}

extension Account {
    
    var refreshTokens : Children<Account, RefreshToken> {
        return self.children(\.accountId)
    }
}

extension Account : Content { }

extension Account : Parameter { }

extension Account : SQLiteMigration {
    
    static func prepare(on conn: SQLiteDatabase.Connection) -> Future<Void> {
        return Database.create(Account.self, on: conn, closure: { builder in
            try self.addProperties(to: builder)
            builder.unique(on: \.login)
        })
    }
}
