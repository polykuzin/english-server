//
//  JWTError.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import JWT

extension JWTError {
    static let payloadCreation = JWTError(identifier: "TokenHelpers.createPayload", reason: "User ID not found")
    static let createJWT = JWTError(identifier: "TokenHelpers.createJWT", reason: "Error getting token string")
    static let verificationFailed = JWTError(identifier: "TokenHelpers.verifyToken", reason: "JWT verification failed")
}
