//
//  Ext+EventLoopFuture.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor

extension EventLoopFuture where Value : UserDataDTO {
    
    func convertToPublic() -> EventLoopFuture<UserDataDTO.Public> {
        return self.map { user in
            return user.convertToPublic()
        }
    }
}

extension EventLoopFuture where Value == Array<UserDataDTO> {
    
    func convertToPublic() -> EventLoopFuture<[UserDataDTO.Public]> {
        return self.map {
            $0.convertToPublic()
        }
    }
}
