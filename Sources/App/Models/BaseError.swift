//
//  DomainError.swift
//  
//
//  Created by polykuzin on 26/06/2022.
//

import Vapor

public enum BaseError : LocalizedError {
    case notFoundError(String)
    case somethingWrong(String)
    case validationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let error):
            return error
            
        case .notFoundError(let error):
            return error
            
        case .somethingWrong(let error):
            return error
        }
    }
}

extension BaseError {
    
    public var status : HTTPStatus {
        switch self {
        case .notFoundError:
            return .notFound
            
        case .validationError:
            return .badRequest
            
        case .somethingWrong:
            return .internalServerError
        }
    }
    
    public var toResponse : BaseResponse<Empty> {
        return BaseResponse(
            data : nil,
            status : Int(status.code),
            message : localizedDescription
        )
    }
}
