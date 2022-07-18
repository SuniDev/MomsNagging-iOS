//
//  TestSchedule.swift
//  momsnagging
//
//  Created by suni on 2022/06/03.
//

import Foundation

class Test {
    
    static let isShowEvaluation: Bool = true
    static let gradeLevel: Int = 1
    static let togetherCount: Int = 1004
    static let awardLevel: Int = 4
    
    static func getGradeAvg() -> Int {
        let num = Int.random(in: 1...3)
        if num == 1 {
            return 0
        } else if num == 2 {
            return 50
        } else {
            return 100
        }
    }
    
    static func getStatisticsMonthlyGrade() -> String {
        let gradeNum = Int.random(in: 1...5)
        
        switch gradeNum {
        case 1:  return "수"
        case 2:  return "우"
        case 3:  return "미"
        case 4:  return "양"
        case 5:  return "가"
        default: return "수"
        }
        
    }
    
    static func getRandomTodoList() -> [TodoListModel] {
        let num = Int.random(in: 1...3)
        if num == 1 {
            return Test.getTodoList1()
        } else if num == 2 {
            return Test.getTodoList2()
        } else {
            return Test.getTodoList3()
        }
    }
    
    static func getTodoList1(status: [Int]? = nil) -> [TodoListModel] {
        
        var todoList = [TodoListModel]()
        
        let arrType = ["ROUTINE", "ROUTINE", "TODO", "ROUTINE", "ROUTINE"]
        let arrName = ["따뜻한 차 한잔 마시기", "직접 아메리카노 만들어서 마시고 인스타에 올리기", "쿠팡 배송온 거 뜯기", "블로그에 글 작성하기", "직접 아메리카노 만들어서 마시고 인스타에 올리고 기분이 좋아서 블로그 포스팅"]
        let arrTime = ["일어나자마자", "점심 먹은 후", "9:00 AM", "점심 먹기 전", "점심을 맛있게 먹고"]
        let arrGoal = [0, 0, 0, 4, 0]
        
        var arrStatus = [Int]()
        
        if let status = status {
            arrStatus = status
        } else {
            arrStatus = [1, 1, 0, 2, 1]
        }
        
        for index in 0..<5 {
            var model = TodoListModel()
            model.seqNumber = index + 1
            model.scheduleType = arrType[index]
            model.scheduleName = arrName[index]
            model.naggingId = 1
            model.scheduleTime = arrTime[index]
            model.status = arrStatus[index]
            model.id = index + 1
            model.goalCount = arrGoal[index]
            model.originalId = index + 1
            todoList.append(model)
        }
        
        return todoList
    }
    
    static func getTodoList2(status: [Int]? = nil) -> [TodoListModel] {
        
        var todoList = [TodoListModel]()
        
        let arrType = ["TODO", "ROUTINE", "ROUTINE", "ROUTINE", "ROUTINE"]
        let arrName = ["쿠팡 배송온 거 뜯기",
                       "블로그에 글 작성하기",
                       "직접 아메리카노 만들어서 마시고 인스타에 올리고 기분이 좋아서 블로그 포스팅",
                       "따뜻한 차 한잔 마시기",
                       "직접 아메리카노 만들어서 마시고 인스타에 올리기"]
        let arrTime = ["일어나자마자", "점심 먹은 후", "2:00 PM", "점심 먹기 전", "점심을 맛있게 먹고"]
        let arrGoal = [0, 0, 0, 4, 0]
        
        var arrStatus = [Int]()
        
        if let status = status {
            arrStatus = status
        } else {
            arrStatus = [1, 2, 0, 1, 1]
        }
        
        for index in 0..<3 {
            var model = TodoListModel()
            model.seqNumber = index + 1
            model.scheduleType = arrType[index]
            model.scheduleName = arrName[index]
            model.naggingId = 1
            model.scheduleTime = arrTime[index]
            model.status = arrStatus[index]
            model.id = index + 1
            model.goalCount = arrGoal[index]
            model.originalId = index + 1
            todoList.append(model)
        }
        
        return todoList
    }
    
    static func getTodoList3(status: [Int]? = nil) -> [TodoListModel] {
        
        var todoList = [TodoListModel]()
        
        let arrType = ["TODO", "ROUTINE", "ROUTINE", "ROUTINE", "ROUTINE"]
        let arrName = ["직접 아메리카노 만들어서 마시고 인스타에 올리고 기분이 좋아서 블로그 포스팅",
                       "쿠팡 배송온 거 뜯기",
                       "블로그에 글 작성하기",
                       "따뜻한 차 한잔 마시기",
                       "직접 아메리카노 만들어서 마시고 인스타에 올리기"]
        let arrTime = ["일어나자마자",
                       "점심 먹은 후",
                       "10:00 AM",
                       "점심 먹기 전",
                       "점심을 맛있게 먹고"]
        let arrGoal = [0, 0, 0, 4, 0]
        
        var arrStatus = [Int]()
        
        if let status = status {
            arrStatus = status
        } else {
            arrStatus = [1, 1, 1, 1, 1]
        }
        
        for index in 0..<4 {
            var model = TodoListModel()
            model.seqNumber = index + 1
            model.scheduleType = arrType[index]
            model.scheduleName = arrName[index]
            model.naggingId = 1
            model.scheduleTime = arrTime[index]
            model.status = arrStatus[index]
            model.id = index + 1
            model.goalCount = arrGoal[index]
            model.originalId = index + 1
            todoList.append(model)
        }
        
        return todoList
    }

    static func getGradeDay(year: Int, month: Int) -> GradeCalendar {
        
        let calendar: GradeCalendar = GradeCalendar(jsonData: "")
        var arrDay = [GradeDay]()
        
        let monthDays = Test.getMonthDaysCount(currentMonth: month, currentYear: year)
        
        for i in 1 ..< monthDays + 1 {
            let day: GradeDay = GradeDay(jsonData: "")
            day.avg = Int.random(in: 0...100)
            day.date = "\(year)-\(month)-\(i)"
            arrDay.append(day)
        }
        
        calendar.arrDay = arrDay
        
        return calendar
    }
    
    /// 이번달 일수
    static func getMonthDaysCount(currentMonth: Int?=nil, currentYear: Int?=nil) -> Int {
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
            count = 28
        }
        return count
    }
    
}
