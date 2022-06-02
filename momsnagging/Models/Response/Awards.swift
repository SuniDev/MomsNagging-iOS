//
//  Awards.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import SwiftyJSON

/**
 # (C) Awards
 - Authors: suni
 - Note: 상장 등급 조회 API Response 모델 클래스
 */
class Awards: ModelType {
    enum Event { }
    
    var level: Int?

    required init(jsonData: JSON) {
        level = jsonData["level"].int
    }
}
