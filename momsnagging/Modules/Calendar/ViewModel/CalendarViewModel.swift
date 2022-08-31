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
    var weekDayListObservable = PublishSubject<[WeekDayListModel]>() // 이번주 주간 리스트 옵저버블
    
    var collectionViewHeight = PublishSubject<Int>() // 해당 월의 행수(row)
    
    var selectDay = PublishSubject<String>()
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
    
    /// 이번달 데이터 가져오기
    ///
    /// 주수 카운트 (이번 달의 행(row)수)
    func rowCount(currentMonth: Int, currentYear: Int) -> Int {
        return model.getMonthRow(currentMonth: currentMonth, currentYear: currentYear)
    }
    /// 주간 리스트
    func weekDayList(currentMonth: Int, currentYear: Int) {
        weekDayListObservable.onNext(model.getWeek(currentMonth: currentMonth, currentYear: currentYear))
    }
    
    func selectWeekDayList(currentMonth: Int, currentYear: Int, selectDate: Date) {
//        Log.debug("weekDayListObservableIntList", model.selectDateGetWeek(currentMonth: currentMonth, currentYear: currentYear, selectDate: selectDate))
        weekDayListObservable.onNext(model.selectDateGetWeek(currentMonth: currentMonth, currentYear: currentYear, selectDate: selectDate))
    }
    
    /// 월~일 String 호출
    func getWeekDayList() -> [String] {
        return model.weekDayList
    }
    /// 오늘날짜 yy,MM,dd 형태로 string return
    func todayFormatteryyMMdd() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: date)
    }
    /// 오늘날짜 yyyyMM 형태로 string return
    func todayFormatteryyyyMM() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        return formatter.string(from: date)
    }
    /// 오늘날짜 yyyy 형태로 string return
    func todayFormatteryyyy() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    /// 오늘날짜 dd 형태로 string return
    func todaydd() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    func getToday() -> Int {
        return model.getToday()
    }
    func getMonth() -> Int {
        return model.getMonth()
    }
    func getYear() -> Int {
        return model.getYear()
    }

    func getWeekDaySelectDate(dateString: String) -> String {
        var st = ""
        let formatterToString = DateFormatter()
        formatterToString.dateFormat = "yyyyMMdd"
        let date = formatterToString.date(from: dateString)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        st = formatter.string(from: date ?? Date())
        
        return st
    }
    
    func getSelectDate(dateString: String) -> String {
        var st = ""
        let formatterToString = DateFormatter()
        formatterToString.dateFormat = "yyyyMMdd"
        let date = formatterToString.date(from: dateString)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        st = formatter.string(from: date ?? Date())
        
        return st
    }
}
