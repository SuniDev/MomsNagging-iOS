//
//  Constants.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

class Constants {
    static let appMail: String = "suniapps919@gmail.com"
    static var appName: String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        } else {
            return "엄마의 잔소리"
        }
    }
    
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1.0"
    }
    
    static var appBundleId: String {
        return Bundle.main.bundleIdentifier ?? "team.jasik.momsnagging"
    }
}
