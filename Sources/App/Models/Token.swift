//
//  Token.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor
import Fluent

final class Token : Model {
    
    static let schema : String = "tokens"
    
    @ID
    public var id : UUID?
    
    @Field(key: "value")
    public var value : String
    
    @Parent(key: "userId")
    public var user : UserDataDTO
    
    public init() { }
    
    public init(id: UUID? = nil, value: String, userId: UserDataDTO.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}

extension Token : Content {
    
    static func generate(for user: UserDataDTO) throws -> Token {
        let random = [UInt8].random(count: 16).base64
        do {
            return try Token(value: random, userId: user.requireID())
        } catch is FluentError {
            throw Abort(.forbidden)
        }
    }
}

extension Token : ModelTokenAuthenticatable {
    
    var isValid : Bool {
        return true
    }
    
    typealias User = App.UserDataDTO
    
    static let userKey = \Token.$user
    
    static let valueKey = \Token.$value
}
