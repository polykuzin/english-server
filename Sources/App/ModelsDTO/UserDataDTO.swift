//
//  UserDataDTO.swift
//  
//
//  Created by polykuzin on 07/07/2022.
//

import Vapor
import Fluent

final class UserDataDTO : Model {
    
    static let schema : String = "users"
    
    @ID
    public var id : UUID?
    
    @Field(key: "email")
    public var email : String
    
    @Field(key: "username")
    public var username : String
    
    @Field(key: "password")
    public var password : String
    
    @OptionalField(key: "siwaIdentifier")
    public var siwaIdentifier : String?
    
    public init() { }
    
    final public  class Public : Content {
        
        public var id : UUID?
        public var email : String
        public var username : String
        
        public init(id: UUID?, email: String, username: String) {
            self.id = id
            self.email = email
            self.username = username
        }
    }
    
    public init(id: UUID? = nil, email: String, username: String, password: String, siwaIdentifier: String? = nil) {
        self.id = id
        self.email = email
        self.username = username
        self.password = password
    }
}

extension UserDataDTO : Content {
    
    public func convertToPublic() -> UserDataDTO.Public {
        return UserDataDTO.Public(
            id: id,
            email: email,
            username: username
        )
    }
}

extension UserDataDTO : ModelAuthenticatable {
    
    static let usernameKey = \UserDataDTO.$username
    
    static let passwordHashKey = \UserDataDTO.$password
    
    public func verify(password: String) throws -> Bool {
        do {
            return try Bcrypt.verify(password, created: self.password)
        } catch is BcryptError {
            throw Abort(.unauthorized)
        }
    }
}
