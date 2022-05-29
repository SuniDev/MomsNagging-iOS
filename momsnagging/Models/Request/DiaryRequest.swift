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

/**
 # (S) GetDiaryReqeust
 - Authors: suni
 - Note: 일기장 조회 Request 모델
 */
struct GetDiaryReqeust: RequestModelType {
    var retrieveDate: String   // 조회 일자
}

/**
 # (S) PutDiaryReqeust
 - Authors: suni
 - Note: 일기장 수정 Request 모델
 */
struct PutDiaryReqeust: RequestModelType {
    var title: String       // 타이틀
    var context: String     // 내용
    var diaryDate: String   // 일기장 날짜
}
