//
//  User.swift
//  momsnagging
//
//  Created by KBIZ on 2022/05/26.
//
//

import Foundation
import SwiftyJSON

/**
 # (C) User
 - Authors: suni
 - Note: 회원 정보 조회 API Response 모델 클래스
 */
class User: ModelType {
    enum Event { }
    
    var id: Int?
    var email: String?
    var provider: String?
    var nickName: String?
    var personalId: String?
    var naggingLevel: Int?
    var statusMsg: String?
    var device: String?
    var allowTodoNotice: Bool?
    var allowRoutineNotice: Bool?
    var allowWeeklyNotice: Bool?
    var allowOtherNotice: Bool?

    required init(jsonData: JSON) {
        id = jsonData["id"].int
        email = jsonData["email"].string
        provider = jsonData["provider"].string
        nickName = jsonData["nickName"].string
        personalId = jsonData["personalId"].string
        naggingLevel = jsonData["naggingLevel"].int
        statusMsg = jsonData["statusMsg"].string
        device = jsonData["device"].string
        allowTodoNotice = jsonData["allowTodoNotice"].bool
        allowRoutineNotice = jsonData["allowRoutineNotice"].bool
        allowWeeklyNotice = jsonData["allowWeeklyNotice"].bool
        allowOtherNotice = jsonData["allowOtherNotice"].bool
    }
}
