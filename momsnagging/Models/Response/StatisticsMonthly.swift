//
//  StatisticsMonthly.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import SwiftyJSON

/**
 # (C) StatisticsMonthly
 - Authors: suni
 - Note: 월간 주간평가 조회 API Response 모델 클래스
 */
class StatisticsMonthly: ModelType {
    enum Event { }
    
    var arrData: [StatisticsMonthlyData]?

    required init(jsonData: JSON) {
        arrData = jsonData.to(type: StatisticsMonthlyData.self) as? [StatisticsMonthlyData] ?? []
    }
}
/**
 # (C) StatisticsMonthlyData
 - Authors: suni
 - Note: 월간 주간평가 조회 데이터 모델 클래스
 */
class StatisticsMonthlyData: ModelType {
    enum Event { }
    
    var weekOfMonth: Int?
    var gradeOfWeek: Int?

    required init(jsonData: JSON) {
        weekOfMonth = jsonData["weekOfMonth"].int
        gradeOfWeek = jsonData["gradeOfWeek"].int
    }
}
