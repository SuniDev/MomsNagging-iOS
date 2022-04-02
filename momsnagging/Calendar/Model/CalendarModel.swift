//
//  CalendarModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/24.
//

import Foundation

class CalendarModel {
    var weekDayList: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    /// 윤년 확인(2월 일수 확인을 위함)
    func checkLeapMonth() -> Bool {
        let year = getYear()
        if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) {
            return true
        } else {
            return false
        }
    }
    /// 오늘날짜 가져오기
    func getToday() -> Int {
        let today: Int = Date().getDay()
        return today
    }
    /// 이번년도 가져오기
    func getYear() -> Int {
        let year: Int = Date().getYear()
        return year
    }
    /// 이번달 가져오기
    func getMonth() -> Int {
        let month: Int = Date().getMonth()
        return month
    }
    /// 이번주 몇번째 요일인지 일(0)~토(6)
    func getWeekDay() -> Int {
        let weekDay: Int = Date().getWeekDay()
        return weekDay
    }
    /// 이번달 일수
    func getMonthDaysCount() -> Int {
        var count = 0
        let month = Date().getMonth()
        let month31 = [1, 3, 5, 7, 8, 10, 12]
        let month30 = [4, 6, 9, 11]
        let month29 = [2]
        for i in month31 where i == month {
            count = 31
        }
        
        for i in month30 where i == month {
            count = 30
        }
        for i in month29 where i == month {
            if checkLeapMonth() {
                count = 29
            } else {
                count = 28
            }
        }
        return count
    }
    /// 이번달 시작 요일 (0:월 ~ 6:일)
    func getMonthFirstDayWeekDay() -> Int {
        var count = getWeekDay()
        let today = getToday()
        for _ in 0..<today - 1 {
            if count != 0 {
                count -= 1
            } else {
                count = 6
            }
        }
        return count
    }
    /// 이번달 행수 = 콜렉션뷰높이 설정용
    func getMonthRow() -> Int {
        var count = 0
        var monthDayCount = getMonthDaysCount()
        let startWeekDay = getMonthFirstDayWeekDay()
        monthDayCount -= (7 - startWeekDay)
        count += 1
        count += (monthDayCount / 7)
        monthDayCount -= (7 * (monthDayCount / 7))
        if monthDayCount != 0 {
            count += 1
        }
        return count
    }
    /// 이번달 일 list (시작요일에 맞추기 위해 빈 cell 추가) + (이번달 일수 추가)
    func getDayList() -> [String] {
        let startWeekDay = getMonthFirstDayWeekDay()
        var dayList = [String]()
        for _ in 0..<(startWeekDay) {
            dayList.append("")
        }
        for i in 1...getMonthDaysCount() {
            dayList.append("\(i)")
        }
        return dayList
    }
    /// 저번달 일수
    func getLastMonthDaysCount() -> Int {
        var count = 0
        var month = Date().getMonth() - 1
        if month == 0 {
            month = 12
        }
        let month31 = [1, 3, 5, 7, 8, 10, 12]
        let month30 = [4, 6, 9, 11]
        let month29 = [2]
        for i in month31 where i == month {
            count = 31
        }
        
        for i in month30 where i == month {
            count = 30
        }
        for i in month29 where i == month {
            if checkLeapMonth() {
                count = 29
            } else {
                count = 28
            }
        }
        return count
    }
    /// 주간 달력 데이터
    func getWeek() -> [Int] {
        let today = getToday()
        let weekDay = getWeekDay()
        var lastMonthDay = getLastMonthDaysCount()
        var lastMonthDayCount = 0
        var nextMonthDay = 1
        var weekDayList = [Int]()
        for i in 0..<weekDay {
            weekDayList.append(today - (i + 1))
        }
        weekDayList.append(today)
        for i in 0..<(7 - weekDayList.count) {
            weekDayList.append(today + (i + 1))
        }
        weekDayList = weekDayList.sorted(by: <)
        for i in weekDayList where i <= 0 {
            lastMonthDayCount += 1
        }
        for i in 0..<weekDayList.count where weekDayList[i] > getMonthDaysCount() {
            weekDayList[i] = nextMonthDay
            nextMonthDay += nextMonthDay
        }
        lastMonthDay -= lastMonthDayCount
        lastMonthDay += 1
        for i in 0..<lastMonthDayCount {
            weekDayList[i] = lastMonthDay + i
        }
        return weekDayList
    }
}
/// 연월일 가져오기 Date Extenstion
extension Date {
    func getYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    func getDay() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    /// 일요일이 1로시작하지 않고 0으로 index하는게 편리하여 -1 함 (일 : 0 ~ 토: 6)
    /// -> (월 : 0 ~ 일 :6)으로 변경 4.2.
    func getWeekDay() -> Int {
        var i: Int!
        switch Calendar.current.component(.weekday, from: self) - 1 {
        case 0:
            i = 6
        case 1:
            i = 0
        case 2:
            i = 1
        case 3:
            i = 2
        case 4:
            i = 3
        case 5:
            i = 4
        case 6:
            i = 5
        default:
            break
        }
        return i
    }
}
