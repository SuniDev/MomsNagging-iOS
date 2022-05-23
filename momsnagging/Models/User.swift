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

enum NaggingIntensity: String {
    case fondMom = "다정한 엄마"
    case coolMom = "냉정한 엄마"
    case angryMom = "화난 엄마"
}

struct User {
    var loginInfo: LoginInfo?
    var nickname: String?
    var naggingIntensity: NaggingIntensity?
}

struct LoginInfo {
    var authToken: String?
    var authId: String?
    var email: String?
    var snsType: SnsType?
}
