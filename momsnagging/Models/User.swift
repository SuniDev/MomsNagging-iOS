//
//  User.swift
//  momsnagging
//
//  Created by suni on 2022/04/01.
//

import Foundation

enum SnsType: String {
    case google = "Google"
    case kakao = "Kakao"
    case apple = "Apple"
}

struct User {
    var loginInfo: LoginInfo?
    var nickname: String?
}

struct LoginInfo {
    var authToken: String?
    var email: String?
    var snsType: SnsType?
}
