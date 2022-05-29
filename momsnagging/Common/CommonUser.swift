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
    
    static var isLogin: Bool = false
    static var authorization: String? {
        didSet {
            if let authorization = authorization {
                isLogin = true
                Common.setUserDefaults(true, forKey: .isAutoLogin)
                Common.setKeychain(authorization, forKey: .authorization)
            } else {
                isLogin = false
                Common.setUserDefaults(false, forKey: .isAutoLogin)
                Common.removeKeychain(forKey: .authorization)
            }
        }
    }
    
    static var id: Int?
    static var email: String?
    static var provider: SnsType?
    static var nickName: String?
    static var personId: String?
    static var naggingLevel: NaggingLevel?
    static var allowGeneralNotice: Bool?
    static var allowTodoNotice: Bool?
    static var allowRoutineNotice: Bool?
    static var allowWeeklyNotice: Bool?
    static var allowOtherNotice: Bool?
        
    static func setUser(_ user: User, _ completion:(() -> Void)? = nil) {
        self.id = user.id
        self.email = user.email
        self.provider = self.getSnsType(user.provider)
        self.nickName = user.nickName ?? ""
        self.personId = user.personId ?? ""
        self.naggingLevel = self.getNaggingLevel(user.naggingLevel)
        self.allowGeneralNotice = user.allowGeneralNotice
        self.allowTodoNotice = user.allowTodoNotice
        self.allowRoutineNotice = user.allowRoutineNotice
        self.allowWeeklyNotice = user.allowWeeklyNotice
        self.allowOtherNotice = user.allowOtherNotice
    
        completion?()
    }
    
    static func getSnsType(_ provider: String?) -> SnsType? {
        
        guard let provider = provider else {
            return nil
        }
        
        if provider == SnsType.google.rawValue {
            return SnsType.google
        } else if provider == SnsType.kakao.rawValue {
            return SnsType.kakao
        } else if provider == SnsType.apple.rawValue {
            return SnsType.apple
        }
        return nil
    }
    
    static func getNaggingLevel(_ level: Int?) -> NaggingLevel {
        
        guard let level = level else {
            return NaggingLevel.fondMom
        }
        
        switch level {
        case 0: return NaggingLevel.fondMom
        case 1: return NaggingLevel.coolMom
        case 2: return NaggingLevel.angryMom
        default: return NaggingLevel.fondMom
        }
    }
}

enum SnsType: String {
    case google = "Google"
    case kakao = "Kakao"
    case apple = "Apple"
}

enum NaggingLevel: String {
    case fondMom = "다정한 엄마"
    case coolMom = "냉정한 엄마"
    case angryMom = "화난 엄마"
}
