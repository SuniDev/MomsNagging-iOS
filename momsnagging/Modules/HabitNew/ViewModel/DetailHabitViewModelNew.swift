//
//  DetailHabitViewModelNew.swift
//  momsnagging
//
//  Created by 전창평 on 2022/08/18.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift

class DetailHabitViewModelNew: BaseViewModel {
    let provider = MoyaProvider<ScheduleService>()
    
    var homeViewModel: HomeViewModel!
    var modify: Bool = false
    var todoModel: TodoListModel?
    
    var habitInfoOb = PublishSubject<TodoInfoResponseModel>()
    
    var recommendedTitle: String?
    var naggingId: Int?
    
    var modifySuccessOb = PublishSubject<Void>()
//    var registSuccess = PublishSubject<Void>()
//    var registError = PublishSubject<String>()
    
    var coachMarkStatusCheck: Bool?
    
    init(modify: Bool, homeViewModel: HomeViewModel, recommendedTitle: String?="", todoModel: TodoListModel?=nil, naggingId: Int?=0, coachMarkStatus: Bool? = false) {
        
        self.coachMarkStatusCheck = coachMarkStatus
        
        // GA - 습관 추가/수정 화면
        if coachMarkStatus == false {
            if modify {
                CommonAnalytics.logScreenView(.habit_modify)
            } else {
                if (recommendedTitle ?? "").isEmpty {
                    CommonAnalytics.logScreenView(.habit_add_own)
                } else {
                    CommonAnalytics.logScreenView(.habit_add_recommend)
                }
            }
        }
        
        self.modify = modify
        self.homeViewModel = homeViewModel
        self.recommendedTitle = recommendedTitle
        if let todoModel = todoModel {
            self.todoModel = todoModel
        }
        if let naggingId = naggingId {
            self.naggingId = naggingId
        } else {
            self.naggingId = 0
        }
        print("DetailHabitViewModelNew : \(self.todoModel?.id ?? 0)")
        print("DetailHabitViewModelNew : \(self.recommendedTitle ?? "")")
    }
}

extension DetailHabitViewModelNew {
    func requestRegistHabit(createTodoRequestModel: CreateTodoRequestModel) {
        if coachMarkStatusCheck == true {
            return
        }
        
        LoadingHUD.show()
//        let param = CreateTodoRequestModel(scheduleName: scheduleName, naggingId: naggingId, goalCount: goalCount, scheduleTime: scheduleTime, scheduleDate: scheduleDate, alarmTime: alarmTime, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat, sun: sun)
        let param = createTodoRequestModel
        
        Log.debug("createHabit param:", "\(param)")
        
        provider.request(.createTodo(param: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    Log.debug("createHabit json:", "\(json)")
                    self.homeViewModel.addHabitSuccessOb.onNext(())
                    LoadingHUD.hide()
                } catch { // Error
                    Log.error("createHabit error", "\(error)")
                    LoadingHUD.hide()
                    return
                }
            case .failure(let error):
                Log.error("createHabit failure error", "\(error)")
                LoadingHUD.hide()
            }
        })
    }
    
    func requestRoutineInfo() {
        if coachMarkStatusCheck == true {
            return
        }
        
        LoadingHUD.show()
        Log.debug("requestRoutineInfo:", self.todoModel?.id ?? 0)
        provider.request(.todoDetailLookUp(scheduleId: self.todoModel?.id ?? 0), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    var model = TodoInfoResponseModel()
                    model.id = json.dictionary?["id"]?.intValue ?? 0
                    model.naggingId = json.dictionary?["naggingId"]?.intValue ?? 0
                    model.goalCount = json.dictionary?["goalCount"]?.intValue ?? 0
                    model.scheduleName = json.dictionary?["scheduleName"]?.stringValue ?? ""
                    model.scheduleTime = json.dictionary?["scheduleTime"]?.stringValue ?? ""
                    model.scheduleDate = json.dictionary?["scheduleDate"]?.stringValue ?? ""
                    model.alarmTime = json.dictionary?["alarmTime"]?.stringValue ?? ""
                    model.done = json.dictionary?["done"]?.boolValue ?? false
                    model.mon = json.dictionary?["mon"]?.boolValue ?? false
                    model.tue = json.dictionary?["tue"]?.boolValue ?? false
                    model.wed = json.dictionary?["wed"]?.boolValue ?? false
                    model.thu = json.dictionary?["thu"]?.boolValue ?? false
                    model.fri = json.dictionary?["fri"]?.boolValue ?? false
                    model.sat = json.dictionary?["sat"]?.boolValue ?? false
                    model.sun = json.dictionary?["sun"]?.boolValue ?? false
                    model.scheduleType = json.dictionary?["scheduleType"]?.stringValue ?? ""
                    
                    self.habitInfoOb.onNext(model)
                    
                    Log.debug("todoDetailLookUp json:", "\(json)")
                    LoadingHUD.hide()
                } catch { // Error
                    Log.error("todoDetailLookUp error", "\(error)")
                    LoadingHUD.hide()
                }
            case .failure(let error):
                Log.error("todoDetailLookUp error", "\(error)")
                LoadingHUD.hide()
            }
        })
    }
    
    func requestModifyRoutine(requestParam: CreateTodoRequestModel, requestModifyParam: CreateTodoRequestModel) {
        if coachMarkStatusCheck == true {
            return
        }
        
        LoadingHUD.show()
        var param: [ModifyTodoRequestModel] = []
        var model = ModifyTodoRequestModel()
        param.removeAll()
        
        if requestParam.scheduleName != requestModifyParam.scheduleName {
            if let name = requestParam.scheduleName {
                model.op = "replace"
                model.path = "/scheduleName"
                model.value = "\(name)"
                param.append(model)
            }
        }
        if requestParam.scheduleTime != requestModifyParam.scheduleTime {
            if let time = requestParam.scheduleTime {
                model.op = "replace"
                model.path = "/scheduleTime"
                model.value = "\(time)"
                param.append(model)
            }
        }
        if requestParam.scheduleDate != requestModifyParam.scheduleDate {
            if let date = requestParam.scheduleDate {
                model.op = "replace"
                model.path = "/scheduleDate"
                model.value = "\(date)"
                param.append(model)
            }
        }
        if let mon = requestParam.mon {
            model.op = "replace"
            model.path = "/mon"
            model.value = "\(mon)"
            param.append(model)
        }
        if let tue = requestParam.tue {
            model.op = "replace"
            model.path = "/tue"
            model.value = "\(tue)"
            param.append(model)
        }
        if let wed = requestParam.wed {
            model.op = "replace"
            model.path = "/wed"
            model.value = "\(wed)"
            param.append(model)
        }
        if let thu = requestParam.thu {
            model.op = "replace"
            model.path = "/thu"
            model.value = "\(thu)"
            param.append(model)
        }
        if let fri = requestParam.fri {
            model.op = "replace"
            model.path = "/fri"
            model.value = "\(fri)"
            param.append(model)
        }
        if let sat = requestParam.sat {
            model.op = "replace"
            model.path = "/sat"
            model.value = "\(sat)"
            param.append(model)
        }
        if let sun = requestParam.sun {
            model.op = "replace"
            model.path = "/sun"
            model.value = "\(sun)"
            param.append(model)
        }
        if requestParam.goalCount != requestModifyParam.goalCount {
            if let goalCount = requestParam.goalCount {
                model.op = "replace"
                model.path = "/goalCount"
                model.value = "\(goalCount)"
                param.append(model)
            }
        }
        if requestParam.alarmTime == nil {
            if requestParam.alarmTime != requestModifyParam.alarmTime {
                if let alarm = requestParam.alarmTime {
                    _ = "\(TaviCommon.alarmTimeStringToDateToStringHHMM(stringData: alarm)):00"
                    model.op = "replace"
                    model.path = "/alarmTime"
                    model.value = "null"
                    param.append(model)
                }
            }
        } else {
            if requestParam.alarmTime != requestModifyParam.alarmTime {
                if let alarm = requestParam.alarmTime {
                    let alarmTime = "\(TaviCommon.alarmTimeStringToDateToStringHHMM(stringData: alarm)):00"
                    model.op = "replace"
                    model.path = "/alarmTime"
                    model.value = "\(alarmTime)"
                    param.append(model)
                }
            }
        }
        
        Log.debug("modifyParam: ", param)
        
        provider.request(.modifyTodo(scheduleId: todoModel?.id ?? 0, modifyParam: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("modifyTodo json : \(json)")
                    self.modifySuccessOb.onNext(())
                    self.homeViewModel.isEndProgress.onNext(())
                    self.homeViewModel.addHabitSuccessOb.onNext(())
                    LoadingHUD.hide()
                } catch { // Error
                    Log.error("modifyTodo error", "\(error)")
                    LoadingHUD.hide()
                }
            case .failure(let error):
                Log.error("modifyTodo failure error", "\(error)")
                LoadingHUD.hide()
            }
        })
    }
    
}
