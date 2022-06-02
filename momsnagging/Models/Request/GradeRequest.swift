//
//  GradeRequest.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation

/**
 # (S) GradeAwardsRequest
 - Authors: suni
 - Note: 상장 등급 조회 Request 모델
 */
struct GradeAwardsRequest: RequestModelType { }

/**
 # (S) GradeCalendar
 - Authors: suni
 - Note: 월간 달력 성적표 조회 Request 모델
 */
struct GradeCalendarRequest: RequestModelType {
    var retrieveYear: Int   // 조회할 년도
    var retrieveMonth: Int   // 조회할 월
}

/**
 # (S) GradeLastWeekRequest
 - Authors: suni
 - Note: 직전 주의 주간평가 조회 Request 모델
 */
struct GradeLastWeekRequest: RequestModelType { }

/**
 # (S) StatisticsMonthlyRequest
 - Authors: suni
 - Note: 월간 주간평가 조회 Request 모델
 */
struct StatisticsMonthlyRequest: RequestModelType {
    var retrieveYear: Int   // 조회할 년도
    var retrieveMonth: Int   // 조회할 월
}

/**
 # (S) StatisticsRequest
 - Authors: suni
 - Note: 성적표 통계 조회 Request 모델
 */
struct StatisticsRequest: RequestModelType { }
