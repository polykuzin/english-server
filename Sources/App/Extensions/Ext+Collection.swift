//
//  Ext+Collection.swift
//  
//
//  Created by polykuzin on 06/07/2022.
//

import Vapor

extension Collection where Element : UserData {
    
    func convertToPublic() -> [UserData.Public] {
        return self.map {
            $0.convertToPublic()
        }
    }
}
