//
//  UserResult.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation
import SwiftyJSON

/**
 # (C) UserResult
 - Authors: suni
 - Note: 회원 정보 수정 / 삭제 API Response 모델 클래스
 */
class UserResult: ModelType {
    enum Event { }
    
    var id: Int?

    required init(jsonData: JSON) {
        id = jsonData["id"].int
    }
}
