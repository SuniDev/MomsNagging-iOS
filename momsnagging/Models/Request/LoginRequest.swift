//
//  LoginRequest.swift
//  momsnagging
//
//  Created by suni on 2022/05/25.
//

// MARK: Login Request 모델
struct LoginRequest: RequestModelType {
    var provider: String   // 소셜 로그인 플랫폼
    var code: String       // 플랫폼 코드
}
