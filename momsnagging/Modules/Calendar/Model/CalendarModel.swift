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
    func checkLeapMonth(currentYear: Int?=nil) -> Bool {
        var year = getYear()
        if let currentYear = currentYear {
            year = currentYear
        }
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
    // 저번달 가져오기
    func getLastMonth(currentMonth: Int) -> Int {
        var month: Int = 0
        if currentMonth == 1 {
            month = 12
        } else {
            month = currentMonth - 1
        }
        return month
    }
    /// 저번연도 가져오기
    func getLastYear(currentYear: Int) -> Int {
        var year: Int = 0
        year = currentYear - 1
        return year
    }
    /// 다음달 가져오기
    func getNextMonth(currentMonth: Int) -> Int {
        var month: Int = 0
        if currentMonth == 12 {
            month = 1
        } else {
            month = currentMonth + 1
        }
        return month
    }
    /// 내년도 가져오기
    func getNextYear(currentYear: Int) -> Int {
        var year: Int = 0
        year = currentYear + 1
        return year
    }
    /// 이번주 몇번째 요일인지 일(0)~토(6)
    func getWeekDay() -> Int {
        let weekDay: Int = Date().getWeekDay()
        return weekDay
    }
    /// 이번달 일수
    func getMonthDaysCount(currentMonth: Int?=nil, currentYear: Int?=nil) -> Int {
        var count = 0
        var month = Date().getMonth()
        if let currentMonth = currentMonth {
            month = currentMonth
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
            if let currentYear = currentYear {
                if checkLeapMonth(currentYear: currentYear) {
                    count = 29
                } else {
                    count = 28
                }
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
    /// 입력 날짜의 요일 가져오기 월:0 ~ 일:6
    func getDayOfWeek(_ today: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        var i = 0
        switch weekDay {
        case 1:
            i = 6
        case 2:
            i = 0
        case 3:
            i = 1
        case 4:
            i = 2
        case 5:
            i = 3
        case 6:
            i = 4
        case 7:
            i = 5
        default:
            break
        }
        return i
    }
    /// 이번달 행수 = 콜렉션뷰높이 설정용
    func getMonthRow(currentMonth: Int, currentYear: Int) -> Int {
        var count = 0
        var monthDayCount = getMonthDaysCount(currentMonth: currentMonth, currentYear: currentYear)
        var startWeekDayString: String = ""
        if currentMonth > 9 {
            startWeekDayString = "\(currentYear)-\(currentMonth)-01"
        } else {
            startWeekDayString = "\(currentYear)-\(currentMonth)-01"
        }
        let startWeekDay = getDayOfWeek(startWeekDayString)
        monthDayCount -= (7 - startWeekDay!)
        count += 1
        count += (monthDayCount / 7)
        monthDayCount -= (7 * (monthDayCount / 7))
        if monthDayCount != 0 {
            count += 1
        }
        return count
    }
    /// 이번달 일 list (시작요일에 맞추기 위해 빈 cell 추가) + (이번달 일수 추가)  최초 세팅시에만 호출
    func getDefaultDayList() -> [String] {
        let startWeekDay = getMonthFirstDayWeekDay()
        var dayList = [String]()
        for _ in 0..<(startWeekDay) {
            dayList.append("emptyCell")
        }
        for i in 1...getMonthDaysCount() {
            dayList.append("\(i)")
        }
        return dayList
    }
    /// 이전달, 다음달로 넘어갈때 일 list 값 전달
    func getOtherMonthDayList(currentMonth: Int, currentYear: Int) -> [String] {
        var startWeekDayString: String = ""
        if currentMonth > 9 {
            startWeekDayString = "\(currentYear)-\(currentMonth)-01"
        } else {
            startWeekDayString = "\(currentYear)-0\(currentMonth)-01"
        }
        let startWeekDay = getDayOfWeek(startWeekDayString)
        var dayList = [String]()
        for _ in 0..<(startWeekDay!) {
            dayList.append("emptyCell")
        }
        for i in 1...getMonthDaysCount(currentMonth: currentMonth, currentYear: currentYear) {
            dayList.append("\(i)")
        }
        return dayList
    }
    /// 저번달 일수 _ 주간 달력 데이터에서 사용
    func getLastMonthDaysCount(currentMonth: Int?=nil, currentYear: Int) -> Int {
        var count = 0
        var month = getMonth()
        if let currentMonth = currentMonth {
            month = currentMonth - 1
        }
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
            if checkLeapMonth(currentYear: currentYear) {
                count = 29
            } else {
                count = 28
            }
        }
        return count
    }
    // 주간 달력 데이터
    func getWeek(currentMonth: Int, currentYear: Int) -> [Int] {
        let today = getToday()
        let weekDay = getWeekDay()
        var lastMonthDay = getLastMonthDaysCount(currentMonth: currentMonth, currentYear: currentYear)
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
        for i in 0..<weekDayList.count where weekDayList[i] > getMonthDaysCount(currentMonth: currentMonth, currentYear: currentYear) {
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
