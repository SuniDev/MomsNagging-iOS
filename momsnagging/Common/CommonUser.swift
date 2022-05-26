//
//  User.swift
//  momsnagging
//
//  Created by suni on 2022/04/01.
//

import Foundation

/**
 # (C) CommonUser.swift
 - Author: suni
 - Note: 회원 정보를 관리하는 공용 클래스
 */
// TODO: 클래스 이름 변견 예정
class CommonUser: NSObject {
    static var authorization: String?
}

enum SnsType: String {
    case google = "Google"
    case kakao = "Kakao"
    case apple = "Apple"
}

enum NaggingIntensity: String {
    case fondMom = "다정한 엄마"
    case coolMom = "냉정한 엄마"
    case angryMom = "화난 엄마"
}
