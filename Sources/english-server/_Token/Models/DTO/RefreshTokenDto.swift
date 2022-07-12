//
//  RefreshTokenDto.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import Vapor

struct RefreshTokenDto : Content {
    let refreshToken : String
}
