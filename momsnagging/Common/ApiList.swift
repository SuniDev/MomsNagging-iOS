//
//  ApiList.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import Foundation

class ApiList {
    enum DeployType : String {
        case debug
        case release
    }
    
    private static let configKey = "DeployPhase"
    private static let kakaoNativeAppKey = "KakaoNativeAppKey"
    private static let googleClientIDKey = "GoogleClientID"

    
    static func getDeployPhase() -> DeployType {
        let configValue = Bundle.main.object(forInfoDictionaryKey: configKey) as! String
        guard let phase = DeployType(rawValue: configValue) else {
            return DeployType.release
        }
        return phase
    }
    
    public static func getKakaoNativeAppKey() -> String {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: kakaoNativeAppKey) as? String else {
            return ""
        }
        return appKey
    }
    
    public static func getGooleClientID() -> String {
        guard let id = Bundle.main.object(forInfoDictionaryKey: googleClientIDKey) as? String else {
            return ""
        }
        return id
    }
    
    public static func BaseURL() -> String {
        switch getDeployPhase() {
        case .debug:
            return "테스트서버주소"
        case .release:
            return "실서버주소"
        }
    }
    static var apiPath : String = "Api Path 를 적는 부분~~~~~!!"
    /*
     ex.
     static var login : String = "/login"
     */
}
