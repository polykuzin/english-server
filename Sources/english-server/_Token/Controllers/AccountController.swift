//
//  AccountController.swift
//  
//
//  Created by polykuzin on 12/07/2022.
//

import Vapor

final class AccountController {
    
    fileprivate var userService: UserService
    
    init(userService: _AccountService) {
        self.userService = userService
    }
    
    func signUp(_ request: Request, account: Account) throws -> Future<ResponseDto> {
        return try self.userService.signUp(request: request, user: user)
    }
    
    func signIn(_ request: Request, account: Account) throws -> Future<AccessDto> {
        return try self.userService.signIn(request: request, user: user)
    }
    
    func refreshToken(_ requets: Request, refreshTokenDto: RefreshTokenDto) throws -> Future<AccessDto> {
        return try self.userService.refreshToken(request: requets, refreshTokenDto: refreshTokenDto)
    }
}

extension AccountController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("v1/account")
        group.post(User.self, at: "/sign-up", use: self.signUp)
        group.post(User.self, at: "/sign-in", use: self.signIn)
        group.post(RefreshTokenDto.self, at: "/refresh-token", use: self.refreshToken)
    }
}
