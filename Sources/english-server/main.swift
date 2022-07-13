//
//  english-server.swift
//  
//
//  Created by polykuzin on 07/07/2022.
//

import Vapor

var env = try Environment.detect()

try LoggingSystem.bootstrap(from: &env)

let app = Application(env)

defer { app.shutdown() }

try configure(app)

try app.run()
