//
//  Link.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor
import Fluent

final class Link: Model, Content {
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "short_url")
    var shortUrl: String
    @Field(key: "long_url")
    var longUrl: String
    @Timestamp(key: "created_date", on: .create)
    var createdAt: Date?
    
    static let schema = "links"
    
    init() {  }
    
    init(id: UUID? = nil, short: String, long: String, created: Date? = Date()) {
        guard URL(string: long) != nil,
              created == created
        else {
            abort()
        }
        self.id = id
        self.shortUrl = short
        self.longUrl = long
        self.createdAt = created
    }
}
