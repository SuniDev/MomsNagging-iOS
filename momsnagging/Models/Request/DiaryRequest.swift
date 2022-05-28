//
//  DiaryRequest.swift
//  momsnagging
//
//  Created by suni on 2022/05/28.
//

import Foundation

/**
 # (S) DiaryCalendarRequest
 - Authors: suni
 - Note: 월간 달력 일기장 조회 Request 모델
 */
struct DiaryCalendarRequest: RequestModelType {
    var retrieveYear: Int   // 조회할 년도
    var retrieveMonth: Int  // 조회할 월
}
