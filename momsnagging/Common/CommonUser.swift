//
//  User.swift
//  momsnagging
//
//  Created by suni on 2022/04/01.
//

import Foundation
import UIKit
import Firebase
/**
 # (C) CommonUser.swift
 - Author: suni
 - Note: 회원 정보를 관리하는 공용 클래스
 */
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
    static var personalId: String?
    static var naggingLevel: NaggingLevel = NaggingLevel.fondMom
    static var statusMsg: String = STR_STATUSMSG_DEFAULT
    static var allowTodoNotice: Bool?
    static var allowRoutineNotice: Bool?
    static var allowWeeklyNotice: Bool?
    static var allowOtherNotice: Bool?
        
    static func setUser(_ user: User, _ completion:(() -> Void)? = nil) {
        self.id = user.id
        self.email = user.email
        self.provider = self.getSnsType(user.provider)
        self.nickName = user.nickName ?? ""
        self.personalId = user.personalId ?? ""
        self.naggingLevel = self.getNaggingLevel(user.naggingLevel)
        self.statusMsg = user.statusMsg ?? STR_STATUSMSG_DEFAULT
        self.allowTodoNotice = user.allowTodoNotice
        self.allowRoutineNotice = user.allowRoutineNotice
        self.allowWeeklyNotice = user.allowWeeklyNotice
        self.allowOtherNotice = user.allowOtherNotice
    
        completion?()
    }
    
    static func logout(_ completion:(() -> Void)? = nil) {
        self.authorization = nil
        
        self.id = nil
        self.email = nil
        self.provider = nil
        self.nickName = nil
        self.personalId = nil
        self.naggingLevel = .fondMom
        self.statusMsg = STR_STATUSMSG_DEFAULT
        self.allowTodoNotice = nil
        self.allowRoutineNotice = nil
        self.allowWeeklyNotice = nil
        self.allowOtherNotice = nil
    
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
    
    static func getNaggingLevel(_ level: NaggingLevel) -> Int {
        switch level {
        case .fondMom:
            return 0
        case .coolMom:
            return 1
        case .angryMom:
            return 2
        }
    }
    
    static func getNicknameImage(_ nickName: String?) -> UIImage {
        guard let nickName = nickName else {
            return Asset.Assets.emojiDaughter.image
        }
        
        if nickName == "아들" {
            return Asset.Assets.emojiSon.image
        }
        
        return Asset.Assets.emojiDaughter.image
    }
    
    /**
     # getFCMToken
     - Authors: suni
     - Returns: FCM 토큰 String
     - Note: FCM 토큰을 반환하는 함수
     */
    static func getFCMToken() -> String {
        if let fcmToken = Messaging.messaging().fcmToken {
            return fcmToken
        }
        return ""
    }
    
    static func getGeneralNotice() -> Bool {
        return CommonUser.allowTodoNotice ?? false
        && CommonUser.allowRoutineNotice ?? false
        && CommonUser.allowWeeklyNotice ?? false
        && CommonUser.allowOtherNotice ?? false
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
    case angryMom = "화가 많은 엄마"
}
