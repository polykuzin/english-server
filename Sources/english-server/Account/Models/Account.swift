//
//  Account.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor
import Fluent

final class Account : Model {
    
    static let schema : String = "account"
    
    @ID
    var id : UUID?
    
    public init() { }
    
    @Field(key: "name")
    var name : String
    
    @Field(key: "password")
    var password : String
    
    final class Public : Content {
        var id : UUID?
        var name : String
        
        init(id: UUID?, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    public init(id: UUID? = nil, name: String, password: String) {
        self.id = id
        self.name = name
        self.password = password
    }
}

extension Account : Content {
    
    func convertToPublic() -> Account.Public {
        return Account.Public(
            id: id,
            name: name
        )
    }
}

extension Account : ModelAuthenticatable {
    
    static var usernameKey : KeyPath<Account, Field<String>> {
        return \Account.$name
    }
    
    static var passwordHashKey : KeyPath<Account, Field<String>> {
        return \Account.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
