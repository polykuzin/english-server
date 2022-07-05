//
//  Ext+EventLoopFuture.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor

extension EventLoopFuture where Value : UserData {
    
    func convertToPublic() -> EventLoopFuture<UserData.Public> {
        return self.map { user in
            return user.convertToPublic()
        }
    }
}

extension EventLoopFuture where Value == Array<UserData> {
    
    func convertToPublic() -> EventLoopFuture<[UserData.Public]> {
        return self.map {
            $0.convertToPublic()
        }
    }
}
