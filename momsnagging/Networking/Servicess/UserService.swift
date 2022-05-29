//
//  UserService.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

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
 - Note: 회원  관련 서비스 클래스.
 */
class UserService {
    private let networking = AppNetworking()
    
    func getUser(request: GetUserRequest) -> Observable<User> {
        return networking.request(.getUser(request))
            .map(to: User.self)
            .asObservable()
    }
    
    func putUser(request: PutUserRequest) -> Observable<UserResult> {
        return networking.request(.putUser(request))
            .map(to: UserResult.self)
            .asObservable()
    }
    
    func deleteUser(request: DeleteUserRequest) -> Observable<UserResult> {
        return networking.request(.deleteUser(request))
            .map(to: UserResult.self)
            .asObservable()
    }
    
}
