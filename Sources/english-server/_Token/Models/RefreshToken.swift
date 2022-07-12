//
//  RefreshToken.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import Vapor
import Fluent
import FluentSQLite

final class RefreshToken : SQLiteModel {
    
    var id : Int?
    
    var token : String
    
    var expiredAt : Date
    
    var accountId : Account.ID
    
    func updateExpiredDate() {
        self.expiredAt = Date().addingTimeInterval(Constants.refreshTokenTime)
    }
    
    fileprivate enum Constants {
        static let refreshTokenTime : TimeInterval = 60 * 24 * 60 * 60
    }
    
    init(id: Int? = nil, token: String, expiredAt: Date = Date().addingTimeInterval(Constants.refreshTokenTime), userID: User.ID) {
        self.id = id
        self.token = token
        self.expiredAt = expiredAt
        self.userID = userID
    }
}

extension RefreshToken {
    
    var account : Parent<RefreshToken, Account> {
        return self.parent(\.accountId)
    }
}

extension RefreshToken : Content { }

extension RefreshToken : Parameter { }

extension RefreshToken : SQLiteMigration { }
