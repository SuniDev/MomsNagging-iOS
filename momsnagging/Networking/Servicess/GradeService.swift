//
//  GradeService.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

/**
 # (P) AppGradeService
 - Authors: suni
 - Note: 평가 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
 */
protocol AppGradeService {
    var gradeService: GradeService { get }
}

/**
 # (C) GradeService
 - Authors: suni
 - Note: 평가  관련 서비스 클래스.
 */
class GradeService {
    private let networking = AppNetworking()
    
    func award(request: GradeAwardsRequest) -> Observable<Awards> {
        return networking.request(.gradeAwards(request))
            .map(to: Awards.self)
            .asObservable()
    }
    
    func calendar(request: GradeCalendarRequest) -> Observable<GradeCalendar> {
        return networking.request(.gradeCalendar(request))
            .map(to: GradeCalendar.self)
            .asObservable()
    }
    
    func lastWeek(request: GradeLastWeekRequest) -> Observable<GradeLastWeek> {
        return networking.request(.gradeLastWeek(request))
            .map(to: GradeLastWeek.self)
            .asObservable()
    }
    
    func monthly(request: StatisticsMonthlyRequest) -> Observable<StatisticsMonthly> {
        return networking.request(.gradeMonthly(request))
            .map(to: StatisticsMonthly.self)
            .asObservable()
    }
    
    func statistics(request: GradeStatisticsRequest) -> Observable<Statistics> {
        return networking.request(.gradeStatistics(request))
            .map(to: Statistics.self)
            .asObservable()
    }
    
}
