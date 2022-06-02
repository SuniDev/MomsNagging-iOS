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
    case modifyTodo(scheduleId: Int, modifyParam: Array<ModifyTodoRequestModel>)
    case sortingTodoList(param: Array<ScheduleArrayModel>)
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
        case .todoDetailLookUp(scheduleId: let id):
            return "schedules/\(id)"
        case .deleteTodo(scheduleId: let id):
            return "schedules/\(id)"
        case .modifyTodo(scheduleId: let id, modifyParam: _):
            return "schedules/\(id)"
        case .sortingTodoList:
            return "schedules/array"
        case .recommendedHabitCategoryLookUp:
            return "schedules/categories"
        case .recommnededHabitListLookUp(categoryId: let id):
            return "schedules/categories/\(id)"
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
        case .todoDetailLookUp:
            return .requestPlain
        case .deleteTodo:
            return .requestPlain
        case .modifyTodo(scheduleId: _, modifyParam: let param):
            return .requestJSONEncodable(param)
        case .sortingTodoList(param: let param):
            return .requestJSONEncodable(param)
        case .recommendedHabitCategoryLookUp:
            return .requestPlain
        case .recommnededHabitListLookUp:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .todoListLookUp:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .createTodo:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .todoDetailLookUp:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .deleteTodo:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .modifyTodo:
            return ["Content-Type": "application/json-patch+json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .sortingTodoList:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .recommendedHabitCategoryLookUp:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        case .recommnededHabitListLookUp:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        }
    }

}
