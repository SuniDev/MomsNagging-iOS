//
//  ApiList.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import Foundation

class ApiList {
    
    private static let kakaoNativeAppKey = "KakaoNativeAppKey"
    private static let googleClientIDKey = "GoogleClientID"
    
    static func getKakaoNativeAppKey() -> String {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: kakaoNativeAppKey) as? String else {
            return ""
        }
        return appKey
    }
    
    static func getGooleClientID() -> String {
        guard let id = Bundle.main.object(forInfoDictionaryKey: googleClientIDKey) as? String else {
            return ""
        }
        return id
    }
    
    static func baseUrl() -> String {
        switch Common.getDeployPhase() {
        case .debug:
            return "테스트서버주소"
        case .release:
            return "실서버주소"
        }
    }
    
    static var apiPath: String = "Api Path 를 적는 부분~~~~~!!"
    
    /*
     ex.
     static var login : String = "/login"
     */
}
