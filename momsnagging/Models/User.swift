//
//  User.swift
//  momsnagging
//
//  Created by suni on 2022/04/01.
//

import Foundation

enum SnsType: String {
    case google = "구글"
    case kakao = "카카오"
    case apple = "애플"
}

struct User {
    var loginInfo: LoginInfo?
    var nickname: String?
}

struct LoginInfo {
    var authToken: String?
    var authId: String?
    var email: String?
    var snsType: SnsType?
}
