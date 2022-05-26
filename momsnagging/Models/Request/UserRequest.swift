//
//  LoginRequest.swift
//  momsnagging
//
//  Created by suni on 2022/05/25.
//

/**
 # (S) Login
 - Authors: suni
 - Note: 로그인 Request 모델
 */
struct LoginRequest: RequestModelType {
    var provider: String   // 소셜 로그인 플랫폼
    var code: String       // 플랫폼 코드
}

/**
 # (S) ValidateIDRequest
 - Authors: suni
 - Note: ID 중복 확인  Request 모델
 */
struct ValidateIDRequest: RequestModelType {
    var id: String   // 아이디
}

/**
 # (S) JoinRequest
 - Authors: suni
 - Note: 회원가입 Request 모델
 */
struct JoinRequest: RequestModelType {
    var provider: String    // 소셜 로그인 플랫폼
    var code: String        // 플랫폼 코드
    var device: String = "IOS"      // 디바이스
    var email: String       // 유저 이메일
    var id: String          // 아이디
    var nickname: String    // 호칭
}
