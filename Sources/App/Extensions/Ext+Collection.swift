//
//  Ext+Collection.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor

extension Collection where Element : UserDataDTO {
    
    func convertToPublic() -> [UserDataDTO.Public] {
        return self.map {
            $0.convertToPublic()
        }
    }
}
