//
//  AccessDto.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import Vapor

struct AccessDto : Content {
    let expiredAt : Date
    let accessToken : String
    let refreshToken : String
}
