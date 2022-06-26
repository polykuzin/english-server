//
//  BaseResponse.swift
//  
//
//  Created by polykuzin on 26/06/2022.
//

import Vapor

protocol ResponseConvertible {
    
    associatedtype Response : Content
    
    var toResponse : Response { get }
}

public struct Empty : Content { }

public struct BaseResponse<T: Content> : Content {
    let data : T?
    let status : Int
    let message : String
}
