//
//  Statistics.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import SwiftyJSON

/**
 # (C) Statistics
 - Authors: suni
 - Note: 성적표 통계 조회 API Response 모델 클래스
 */
class Statistics: ModelType {
    enum Event { }
    
    var fullDoneCount: Int?
    var partialDoneCount: Int?
    var performanceAvg: Int?
    var todoDoneCount: Int?
    var routineDoneCount: Int?
    var diaryCount: Int?
    var togetherCount: Int?

    required init(jsonData: JSON) {
        fullDoneCount = jsonData["fullDoneCount"].int
        partialDoneCount = jsonData["partialDoneCount"].int
        performanceAvg = jsonData["performanceAvg"].int
        todoDoneCount = jsonData["todoDoneCount"].int
        routineDoneCount = jsonData["routineDoneCount"].int
        diaryCount = jsonData["diaryCount"].int
        togetherCount = jsonData["togetherCount"].int
    }
}
