//
//  Ext+EventLoopFuture.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor

extension EventLoopFuture where Value : Account {
    
    func convertToPublic() -> EventLoopFuture<Account.Public> {
        return self.map { account  in
            return account.convertToPublic()
        }
    }
}

extension EventLoopFuture where Value == Array<Account> {
    
    func convertToPublic() -> EventLoopFuture<[Account.Public]> {
        return self.map { $0.convertToPublic() }
    }
}
