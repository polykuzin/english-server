//
//  Ext+Collection.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor

extension Collection where Element : Account {
    
    func convertToPublic() -> [Account.Public] {
        return self.map { $0.convertToPublic() }
    }
}
