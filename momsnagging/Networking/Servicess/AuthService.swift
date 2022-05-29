//
//  AuthService.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/**
 # (P) AppAuthService
 - Authors: suni
 - Note: 인증 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
 */
protocol AppAuthService {
    var authService: AuthService { get }
}

/**
 # (C) AuthService
 - Authors: suni
 - Note: 인증 관련 서비스 클래스.
 */
class AuthService {
    private let networking = AppNetworking()
    
    func login(request: LoginRequest) -> Observable<Login> {
        return networking.request(.login(request))
            .map(to: Login.self)
            .asObservable()
    }
    
    func validateID(request: ValidateIDRequest) -> Observable<Validate> {
        return networking.request(.validateID(request))
            .map(to: Validate.self)
            .asObservable()
    }
    
    func join(request: JoinRequest) -> Observable<Login> {
        return networking.request(.join(request))
            .map(to: Login.self)
            .asObservable()
    }
}
