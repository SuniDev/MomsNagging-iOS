//
//  DiaryService.swift
//  momsnagging
//
//  Created by suni on 2022/05/28.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/**
 # (P) AppDiaryService
 - Authors: suni
 - Note: 일기장 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
 */
protocol AppDiaryService {
    var diaryService: DiaryService { get }
}

/**
 # (C) DiaryService
 - Authors: suni
 - Note: 일기장  관련 서비스 클래스.
 */
class DiaryService {
    private let networking = AppNetworking()
    
    func diaryCalendar(request: DiaryCalendarRequest) -> Observable<DiaryCalendar> {
        return networking.request(.diaryCalendar(request))
            .map(to: DiaryCalendar.self)
            .asObservable()
    }
    
    func getDiary(request: GetDiaryReqeust) -> Observable<Diary> {
        return networking.request(.getDiary(request))
            .map(to: Diary.self)
            .asObservable()
    }
    
    func putDiary(request: PutDiaryReqeust) -> Observable<Diary> {
        return networking.request(.putDiary(request))
            .map(to: Diary.self)
            .asObservable()
    }
    
}
