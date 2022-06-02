//
//  GradeCalendar.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import SwiftyJSON

/**
 # (C) GradeCalendar
 - Authors: suni
 - Note: 월간 달력 성적표 조회 API Response 모델 클래스
 */
class GradeCalendar: ModelType {
    enum Event { }
    
    var arrDay: [GradeDay]?

    required init(jsonData: JSON) {
        arrDay = jsonData.to(type: GradeDay.self) as? [GradeDay] ?? []
    }
}

/**
 # (C) GradeDay
 - Authors: suni
 - Note: 월간 달력 날짜 아이템 모델 클래스
 */
class GradeDay: ModelType {
    enum Event { }
    
    var avg: Int?
    var date: String?

    required init(jsonData: JSON) {
        avg = jsonData["avg"].int
        date = jsonData["date"].string
    }
}
