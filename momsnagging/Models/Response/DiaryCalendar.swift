//
//  DiaryCalendar.swift
//  momsnagging
//
//  Created by suni on 2022/05/28.
//

import Foundation
import SwiftyJSON

/**
 # (C) DiaryCalendar
 - Authors: suni
 - Note: 월간 달력 일기장 조회  API Response 모델 클래스
 */
class DiaryCalendar: ModelType {
    enum Event { }
    
    var arrDay: [DiaryDay]?

    required init(jsonData: JSON) {
        arrDay = jsonData.to(type: DiaryDay.self) as? [DiaryDay] ?? []
    }
}

/**
 # (C) DiaryDay
 - Authors: suni
 - Note: 일기장 날짜 아이템 모델 클래스
 */
class DiaryDay: ModelType {
    enum Event { }
    
    var diaryExists: Bool?
    var diaryDate: String?

    required init(jsonData: JSON) {
        diaryExists = jsonData["diaryExists"].bool
        diaryDate = jsonData["diaryDate"].string
    }
}
