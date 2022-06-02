//
//  GradeMonthly.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import SwiftyJSON

/**
 # (C) GradeMonthly
 - Authors: suni
 - Note: 월간 주간평가 조회 API Response 모델 클래스
 */
class GradeMonthly: ModelType {
    enum Event { }
    
    var weekOfMonth: Int?
    var gradeOfWeek: Int?

    required init(jsonData: JSON) {
        weekOfMonth = jsonData["weekOfMonth"].int
        gradeOfWeek = jsonData["gradeOfWeek"].int
    }
}
