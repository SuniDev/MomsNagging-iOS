//
//  ScheduleService.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import Foundation
import Moya
import SwiftyJSON

enum ScheduleService {
    case todoListLookUp(retrieveDate: String)
    case createTodo(param: CreateTodoRequestModel)
    case todoDetailLookUp(scheduleId: Int)
    case deleteTodo(scheduleId: Int)
    case modifyTodo(scheduleId: Int)
    case sortingTodoList(idArray: Array<Int>)
    case recommendedHabitCategoryLookUp
    case recommnededHabitListLookUp(categoryId: Int)
}

extension ScheduleService: TargetType {
    var baseURL: URL {
        return URL(string: Common.getBaseUrl())!
    }
    
    var path: String {
        switch self {
        case .todoListLookUp:
            return "schedules"
        case .createTodo:
            return "schedules"
        case .todoDetailLookUp:
            return "schedules"
        case .deleteTodo:
            return "schedules"
        case .modifyTodo:
            return "schedules"
        case .sortingTodoList:
            return "schedules/array"
        case .recommendedHabitCategoryLookUp:
            return "schedules/categories"
        case .recommnededHabitListLookUp:
            return "schedules/categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todoListLookUp:
            return .get
        case .createTodo:
            return .post
        case .todoDetailLookUp:
            return .get
        case .deleteTodo:
            return .delete
        case .modifyTodo:
            return .patch
        case .sortingTodoList:
            return .post
        case .recommendedHabitCategoryLookUp:
            return .get
        case .recommnededHabitListLookUp:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .todoListLookUp(retrieveDate: let retrieveDate):
            return .requestParameters(parameters: ["retrieveDate": retrieveDate], encoding: URLEncoding.queryString)
        case .createTodo(param: let param):
            return .requestJSONEncodable(param)
        case .todoDetailLookUp(scheduleId: let scheduleId):
            return .requestParameters(parameters: ["scheduleId": scheduleId], encoding: URLEncoding.queryString)
        case .deleteTodo(scheduleId: let scheduleId):
            return .requestParameters(parameters: ["scheduleId": scheduleId], encoding: URLEncoding.queryString)
        case .modifyTodo(scheduleId: let scheduleId):
            return .requestParameters(parameters: ["scheduleId": scheduleId], encoding: URLEncoding.queryString)
        case .sortingTodoList(idArray: let array):
            return .requestJSONEncodable(array)
        case .recommendedHabitCategoryLookUp:
            return .requestPlain
        case .recommnededHabitListLookUp(categoryId: let categoryId):
            return .requestParameters(parameters: ["categoryId": categoryId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .todoListLookUp:
            return ["Content-Type": "application/json"]
        case .createTodo:
            return ["Content-Type": "application/json"]
        case .todoDetailLookUp:
            return ["Content-Type": "application/json"]
        case .deleteTodo:
            return ["Content-Type": "application/json"]
        case .modifyTodo:
            return ["Content-Type": "application/json"]
        case .sortingTodoList:
            return ["Content-Type": "application/json"]
        case .recommendedHabitCategoryLookUp:
            return ["Content-Type": "application/json"]
        case .recommnededHabitListLookUp:
            return ["Content-Type": "application/json"]
        }
    }

}
