//
//  Validate.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Foundation
import SwiftyJSON

/**
 # (C) Validate
 - Authors: suni
 - Note: 중복 확인  API Response 모델 클래스
 */
class Validate: ModelType {
    enum Event { }
    
    var isExist: Bool?

    required init(jsonData: JSON) {
        isExist = jsonData["isExist"].bool
    }
}
