//
//  Diary.swift
//  momsnagging
//
//  Created by suni on 2022/05/28.
//

import Foundation
import SwiftyJSON

/**
 # (C) Diary
 - Authors: suni
 - Note: 일기장 조회 / 수정  API Response 모델 클래스
 */
class Diary: ModelType {
    enum Event { }
    
    var title: String?
    var context: String?
    var diaryDate: String?
    var today: Bool?

    required init(jsonData: JSON) {
        title = jsonData["title"].string
        context = jsonData["context"].string
        diaryDate = jsonData["diaryDate"].string
        today = jsonData["today"].bool
    }
}
