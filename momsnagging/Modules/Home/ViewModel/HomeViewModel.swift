//
//  HomeViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import Moya
import SwiftyJSON

class HomeViewModel: BaseViewModel, ViewModelType {
    
    // MARK: Properties
    var provider = MoyaProvider<ScheduleService>()
    var disposeBag = DisposeBag()
    var todoListData: [TodoListModel] = []
    var todoListDataOB = BehaviorRelay<[TodoListModel]>(value: [])
    var addHabitSuccessOb = PublishSubject<Void>()
    var toggleIcSuccessOb = PublishSubject<Void>()
    var toggleCancelOb = PublishSubject<Void>()
    var delaySuccessOb = PublishSubject<Void>()
    var arraySuccessOb = PublishSubject<Void>()
    
    override init() {
    }
    
    // MARK: - Input
    struct Input {
        var inputDateString: String?
        var floatingBtnStatus: Bool?
        var selectStatus: Bool?
        var listBtnAction: Bool? // 리스트 버튼을 선택한 상태(취소, 저장버튼 보여짐) - true, 취소 또는 저장을 누른 상태 (리스트, 다이어리 버튼 보여짐) - false
        var sourceIndex: Int?
        var destinationIndex: Int?
        var scheduleType: String?
    }
    // MARK: - Output
    struct Output {
        var floatingBtnIc: Driver<Bool>? // 플로팅 토글시 버튼안의 +(false) x(true) 버튼 변경
        var todoListData: Driver<[TodoListModel]>? // 투두 리스트 데이터 TodoListModel은 임의로 만든 더미 모델형태입니다.
        var toggleImage: Driver<UIImage>! // 셀 선택 상태에 따른 체크박스 이미지
        var cellColorList: Driver<[ColorAsset]>! // 셀 선택상태에 따른 색상 리스트
//        var cellRightImg: Driver<Bool>?
        var diaryBtnStatus: Driver<Bool>?
        var listBtnStatus: Driver<Bool>?
        var cancelBtnStatus: Driver<Bool>?
        var saveBtnStatus: Driver<Bool>?
        
        var inputValue: Driver<HomeViewModel.Input>?
    }
    
    // MARK: - Temp
    var isEndProgress = PublishSubject<Void>()
    var todoListDataObserver = PublishSubject<[TodoListModel]>()
    
    func transform(input: Input) -> Output {
        let floatingBtnIc = BehaviorRelay<Bool>(value: false)
        if input.floatingBtnStatus ?? true {
            floatingBtnIc.accept(false)
        } else {
            floatingBtnIc.accept(true)
        }
        if input.selectStatus ?? true {
            
        } else {
            
        }
        let toggleImg = BehaviorRelay<UIImage>(value: UIImage(asset: Asset.Icon.todoNonSelect)!)
        let colorListOb = BehaviorRelay<[ColorAsset]>(value: [])
        var colorList: [ColorAsset] = []
        if input.selectStatus ?? false {
            colorList.removeAll()
            colorList.append(Asset.Color.monoLight010)
            colorList.append(Asset.Color.monoLight030)
            colorList.append(Asset.Color.monoDark020)
            colorList.append(Asset.Color.monoLight030)
            colorList.append(Asset.Color.monoDark020)
            colorListOb.accept(colorList)
            
            toggleImg.accept(UIImage(asset: Asset.Icon.todoSelect)!)
        } else {
            colorList.removeAll()
            colorList.append(Asset.Color.monoWhite)
            colorList.append(Asset.Color.monoLight010)
            colorList.append(Asset.Color.monoDark010)
            if input.scheduleType == "TODO" {
                colorList.append(Asset.Color.priMain)
                colorList.append(Asset.Color.monoWhite)
            } else if input.scheduleType == "ROUTINE" {
                colorList.append(Asset.Color.subLight030)
                colorList.append(Asset.Color.monoDark010)
            } else {
                colorList.append(Asset.Color.monoLight010)
                colorList.append(Asset.Color.monoDark010)
            }
            colorListOb.accept(colorList)
            
            toggleImg.accept(UIImage(asset: Asset.Icon.todoNonSelect)!)
        }
        
        let diaryBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let listBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let cancelBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let saveBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let inputValueOb = BehaviorRelay<HomeViewModel.Input>(value: HomeViewModel.Input())
        if input.listBtnAction ?? false {
            diaryBtnStatusOb.accept(true)
            listBtnStatusOb.accept(true)
            cancelBtnStatusOb.accept(false)
            saveBtnStatusOb.accept(false)
            inputValueOb.accept(HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false, scheduleType: nil))
        } else {
            diaryBtnStatusOb.accept(false)
            listBtnStatusOb.accept(false)
            cancelBtnStatusOb.accept(true)
            saveBtnStatusOb.accept(true)
            inputValueOb.accept(HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: true, scheduleType: nil))
        }
        if input.inputDateString != nil {
            self.requestTodoListLookUp(date: input.inputDateString ?? "")
        }
//        let todoListData = todoList(sourceIndex: input.sourceIndex, destIndex: input.destinationIndex)
        return Output(floatingBtnIc: floatingBtnIc.asDriver(), todoListData: todoListDataOB.asDriver(), toggleImage: toggleImg.asDriver(), cellColorList: colorListOb.asDriver(), diaryBtnStatus: diaryBtnStatusOb.asDriver(), listBtnStatus: listBtnStatusOb.asDriver(), cancelBtnStatus: cancelBtnStatusOb.asDriver(), saveBtnStatus: saveBtnStatusOb.asDriver(), inputValue: inputValueOb.asDriver())
    }
    
    func todoList(sourceIndex: Int?=nil, destIndex: Int?=nil) -> Driver<[TodoListModel]> {
        // 더미데이터 입니다. API 오면 붙이면 될듯합니다.
        let returnList = BehaviorRelay<[TodoListModel]>(value: [])
        var list: [TodoListModel] = []
//        for i in 0...4 {
//            var model = TodoListModel()
//            model.isSelected = false
//            model.time = "time"
//            model.title = "Title"
//            if i == 2 {
//                model.prefix = "할일"
//                model.type = .todo
//            } else if i == 3 {
//                model.prefix = "4회"
//                model.type = .count
//            } else {
//                model.type = .normal
//            }
//            list.append(model)
//        }
        
//        if let sourceIndex = sourceIndex {
//            let moveCell = list[sourceIndex]
//            list.remove(at: sourceIndex)
//            list.insert(moveCell, at: destIndex!)
//        }
        returnList.accept(list)
        return returnList.asDriver()
    }
    
}

extension HomeViewModel {
    func requestTodoListLookUp(date: String) {
        provider.request(.todoListLookUp(retrieveDate: date), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestTodoListLookUp json : \(json)")
                    self.todoListData.removeAll()
                    if json.dictionary?["status"]?.intValue == nil {
                        for item in json.array! {
                            var model = TodoListModel()
                            model.seqNumber = item.dictionary?["seqNumber"]?.intValue ?? 0
                            model.scheduleType = item.dictionary?["scheduleType"]?.stringValue ?? ""
                            model.scheduleName = item.dictionary?["scheduleName"]?.stringValue ?? ""
                            model.naggingId = item.dictionary?["naggingId"]?.intValue ?? 0
                            model.scheduleTime = item.dictionary?["scheduleTime"]?.stringValue ?? ""
                            model.done = item.dictionary?["done"]?.boolValue ?? nil
                            model.id = item.dictionary?["id"]?.intValue ?? 0
                            model.goalCount = item.dictionary?["goalCount"]?.intValue ?? 0
                            model.originalId = item.dictionary?["originalId"]?.intValue ?? 0
                            self.todoListData.append(model)
                        }
                    }
                    
                    self.todoListDataOB.accept(self.todoListData)
                    self.todoListDataObserver.onNext(self.todoListData)
                    self.isEndProgress.onNext(())
                } catch(let error) {
                    Log.error("requestTodoListLookUp error", "\(error)")
                }
            case .failure(let error):
                Log.error("requestTodoListLookUp failure error", "\(error)")
            }
        })
    }
    
    func requestRoutineDone(scheduleId: Int) {
        var param: [ModifyTodoRequestModel] = []
        var model = ModifyTodoRequestModel()
        model.op = "replace"
        model.path = "/done"
        model.value = "true"
        param.append(model)
        provider.request(.modifyTodo(scheduleId: scheduleId, modifyParam: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestRoutineDone json : \(json)")
                    self.toggleIcSuccessOb.onNext(())
                } catch let error {
                    print("requestRoutineDone error : \(error)")
                }
            case .failure(let error):
                print("requestRoutineDone failure error : \(error)")
            }
        })
    }
    func requestRoutineCancel(scheduleId: Int) {
        var param: [ModifyTodoRequestModel] = []
        var model = ModifyTodoRequestModel()
        model.op = "replace"
        model.path = "/done"
        model.value = "false"
        param.append(model)
        provider.request(.modifyTodo(scheduleId: scheduleId, modifyParam: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestRoutineCancel json : \(json)")
                    self.toggleCancelOb.onNext(())
                } catch let error {
                    print("requestRoutineCancel error : \(error)")
                }
            case .failure(let error):
                print("requestRoutineCancel failure error : \(error)")
            }
        })
    }
    
    func requestDelete(scheduleId: Int) {
        provider.request(.deleteTodo(scheduleId: scheduleId), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("deleteTodo json : \(json)")
                    self.addHabitSuccessOb.onNext(())
                } catch let error {
                    Log.error("deleteTodo error", "\(error)")
                    self.addHabitSuccessOb.onNext(())
                }
            case .failure(let error):
                Log.error("deleteTodo failure error", "\(error)")
            }
        })
    }
    
    func requestDeleay(scheduleId: Int) {
        var param: [ModifyTodoRequestModel] = []
        var model = ModifyTodoRequestModel()
        model.op = "replace"
        model.path = "/done"
        model.value = nil
        param.append(model)
        provider.request(.modifyTodo(scheduleId: scheduleId, modifyParam: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestDeleay : \(json)")
                    self.delaySuccessOb.onNext(())
                } catch let error {
                    Log.error("requestDeleay error", "\(error)")
                }
            case .failure(let error):
                Log.error("requestDeleay failure error", "\(error)")
            }
        })
    }
    
    func requestArray(param: [ScheduleArrayModel]) {
        let param: [ScheduleArrayModel] = param
        print("request param : \(param)")
        provider.request(.sortingTodoList(param: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestArray Json : \(json)")
                    self.arraySuccessOb.onNext(())
                } catch let error {
                    Log.error("requestArray failure error", "\(error) 빈값이 와요 근데 성공")
                    self.arraySuccessOb.onNext(())
                }
            case .failure(let error):
                Log.error("requestArray failure error", "\(error)")
            }
        })
    }
    
}
