//
//  Login.swift
//  momsnagging
//
//  Created by suni on 2022/05/25.
//

import Foundation
import SwiftyJSON

/**
 # (C) Login
 - Authors: suni
 - Note: 로그인  API Response 모델 클래스
 */
class Login: ModelType {
    enum Event { }
    
    var token: String?

    required init(jsonData: JSON) {
        token = jsonData["token"].string
    }
}
