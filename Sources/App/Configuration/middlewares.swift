//
//  middlewares.swift
//  
//
//  Created by polykuzin on 26/06/2022.
//

import Vapor

extension MiddlewareConfig {
    
    mutating func addMiddlewares() {
        use(FileMiddleware.self) // Serves files from `Public/` directory
        use(ErrorMiddleware()) // Catches errors and converts to HTTP response
    }
}
