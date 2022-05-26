//
//  UserService.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Foundation
import RxSwift
import Moya

/**
 # (P) AppUserService
 - Authors: suni
 - Note: 회원 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
 */
protocol AppUserService {
    var userService: UserService { get }
}

/**
 # (C) UserService
 - Authors: suni
 - Note: 로그인  관련 서비스 클래스.
 */
class UserService {
    private let networking = AppNetworking()
    
//    fileprivate func getUser(request: GetUserRequest) -> Single<GetUser> {
//        return networking.request(.getUser(request))
//            .map(GetUser.self)
//    }
}
