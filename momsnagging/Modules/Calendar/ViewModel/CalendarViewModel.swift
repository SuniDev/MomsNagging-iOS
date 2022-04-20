//
//  CalendarViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/24.
//

import Foundation
import RxSwift
import Moya

class CalendarViewModel {
    
    // MARK: - Observable
    var monthObservable = BehaviorSubject<Int>(value: CalendarModel().getMonth()) // 최초 현재월 방출
    var yearObservable = BehaviorSubject<Int>(value: CalendarModel().getYear()) // 최초 현재 연도 방출
    
    var weekDay = BehaviorSubject<[String]>(value: CalendarModel().weekDayList) // 월~일 리스트 방출
    var daylist = BehaviorSubject<[String]>(value: CalendarModel().getDefaultDayList()) // 최초 이번달 일수 리스트 방출
    var weekDayListObservable = PublishSubject<[Int]>() // 이번주 주간 리스트 옵저버블
    
    var collectionViewHeight = PublishSubject<Int>() // 해당 월의 행수(row)
    // MARK: - Properties & Variable
    private var model = CalendarModel()
    /// 지난달 가져오기
    func getLastMonth(currentMonth: Int, currentYear: Int) {
        if model.getLastMonth(currentMonth: currentMonth) == 12 {
            yearObservable.onNext(model.getLastYear(currentYear: currentYear))
            daylist.onNext(model.getOtherMonthDayList(currentMonth: model.getLastMonth(currentMonth: currentMonth), currentYear: model.getLastYear(currentYear: currentYear)))
            collectionViewHeight.onNext(rowCount(currentMonth: model.getLastMonth(currentMonth: currentMonth), currentYear: model.getLastYear(currentYear: currentYear)))
        }
        monthObservable.onNext(model.getLastMonth(currentMonth: currentMonth))
        daylist.onNext(model.getOtherMonthDayList(currentMonth: model.getLastMonth(currentMonth: currentMonth), currentYear: currentYear))
        collectionViewHeight.onNext(rowCount(currentMonth: model.getLastMonth(currentMonth: currentMonth), currentYear: currentYear))
    }
    /// 다음달 데이터 가져오기
    func getNextMonth(currentMonth: Int, currentYear: Int) {
        if model.getNextMonth(currentMonth: currentMonth) == 1 {
            yearObservable.onNext(model.getNextYear(currentYear: currentYear))
            daylist.onNext(model.getOtherMonthDayList(currentMonth: model.getNextMonth(currentMonth: currentMonth), currentYear: model.getNextYear(currentYear: currentYear)))
            collectionViewHeight.onNext(rowCount(currentMonth: model.getLastMonth(currentMonth: currentMonth), currentYear: model.getLastYear(currentYear: currentYear)))
        }
        monthObservable.onNext(model.getNextMonth(currentMonth: currentMonth))
        daylist.onNext(model.getOtherMonthDayList(currentMonth: model.getNextMonth(currentMonth: currentMonth), currentYear: currentYear))
        collectionViewHeight.onNext(rowCount(currentMonth: model.getLastMonth(currentMonth: currentMonth), currentYear: currentYear))
    }
    /// 주수 카운트 (이번 달의 행(row)수)
    func rowCount(currentMonth: Int, currentYear: Int) -> Int {
        return model.getMonthRow(currentMonth: currentMonth, currentYear: currentYear)
    }
    /// 주간 리스트
    func weekDayList(currentMonth: Int, currentYear: Int) {
        weekDayListObservable.onNext(model.getWeek(currentMonth: currentMonth, currentYear: currentYear))
    }
}