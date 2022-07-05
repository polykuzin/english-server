//
//  UserData.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor
import Fluent

final class UserData : Model {
    
    static let schema : String = "users"
    
    @ID
    public var id : UUID?
    
    @Field(key: "username")
    public var username : String
    
    @Field(key: "password")
    public var password : String
    
    public init() { }
    
    final public  class Public : Content {
        
        public var id : UUID?
        public var username : String
        
        public init(id: UUID?, username: String) {
            self.id = id
            self.username = username
        }
    }
    
    public init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}

extension UserData : Content {
    
    public func convertToPublic() -> UserData.Public {
        return UserData.Public(id: id, username: username)
    }
}

extension UserData : ModelAuthenticatable {
    
    static let usernameKey = \UserData.$username
    
    static let passwordHashKey = \UserData.$password
    
    public func verify(password: String) throws -> Bool {
        do {
            return try Bcrypt.verify(password, created: self.password)
        } catch is BcryptError {
            throw Abort(.unauthorized)
        }
    }
}
