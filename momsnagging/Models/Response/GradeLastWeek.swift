//
//  GradeLastWeek.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import SwiftyJSON

/**
 # (C) GradeLastWeek
 - Authors: suni
 - Note: 직전 주의 주간평가 조회 API Response 모델 클래스
 */
class GradeLastWeek: ModelType {
    enum Event { }
    
    var gradeLevel: Int?
    var createdYear: Int?
    var createdWeek: Int?
    var awardLevel: Int?

    required init(jsonData: JSON) {
        gradeLevel = jsonData["gradeLevel"].int
        createdYear = jsonData["createdYear"].int
        createdWeek = jsonData["createdWeek"].int
        awardLevel = jsonData["awardLevel"].int
    }
}
