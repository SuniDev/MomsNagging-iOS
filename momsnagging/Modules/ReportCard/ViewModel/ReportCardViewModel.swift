//
//  ReportCardViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class ReportCardViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var todoListData: [TodoListModel] = []
    var reportListData: [ReportModel] = []
    var cellCount: Int = -1
    
    override init() {
    }
    // MARK: - Input
    struct Input {
        var tabAction: Driver<Bool>?
        var statisticsPrev: Driver<Void>
        var statisticsNext: Driver<Void>
        var currentMonth: Int?
        var currentYear: Int?
        var awardTap: Driver<Void>
    }
    // MARK: - Output
    struct Output {
        var tabAction = PublishRelay<Bool>()
        var todoListData: Driver<[TodoListModel]>? // 투두리스트 더미 데이터모델
        var cellItemCount = PublishRelay<Bool>()
        var reportListData: Driver<[ReportModel]>?
        var reportBottomData: Driver<[ReportBottomModel]>?
        var statisticsPrev: Driver<Void>
        var statisticsNext: Driver<Void>
        var awardTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let tabAction = PublishRelay<Bool>()
        
        input.tabAction?.drive { bool in
            if bool {
                tabAction.accept(true)
            } else {
                tabAction.accept(false)
            }
        }.disposed(by: disposeBag)
        
        let todoListData = todoList()
        
        let cellItemCount = PublishRelay<Bool>()
        cellItemCount.accept((self.cellCount != 0))
        
        let ratingData = ratingList()
        let reportBottomData = statisticsList()
        
        return Output(tabAction: tabAction, todoListData: todoListData.asDriver(), cellItemCount: cellItemCount, reportListData: ratingData.asDriver(), reportBottomData: reportBottomData, statisticsPrev: input.statisticsPrev, statisticsNext: input.statisticsNext, awardTap: input.awardTap)
    }
    // 더미데이터 부분
    func todoList() -> Driver<[TodoListModel]> {
        // 더미데이터 입니다. API 오면 붙이면 될듯합니다.
        let returnList = BehaviorRelay<[TodoListModel]>(value: [])
        var list: [TodoListModel] = []
        for _ in 0...2 {
            var model = TodoListModel()
//            model.isSelected = true
//            model.time = "time"
//            model.title = "Title"
            list.append(model)
        }
        returnList.accept(list)
        self.cellCount = list.count
        return returnList.asDriver()
    }
    
    // 통계페이지 등급 더미
    func ratingList() -> Driver<[ReportModel]> {
        let returnList = BehaviorRelay<[ReportModel]>(value: [])
        var list: [ReportModel] = []
        for _ in 0...3 {
            var model = ReportModel()
            model.rating = "수"
            list.append(model)
        }
        returnList.accept(list)
        self.cellCount = list.count
        return returnList.asDriver()
    }
    // 통계페이지 통계 더미
    func statisticsList() -> Driver<[ReportBottomModel]> {
        let returnList = BehaviorRelay<[ReportBottomModel]>(value: [])
        var list: [ReportBottomModel] = []
        for i in 0...5 {
            var model = ReportBottomModel()
            if i == 0 {
                model.days = 40
            } else if i == 1 {
                model.days = 12
            } else if i == 2 {
                model.days = 23
            } else if i == 3 {
                model.days = 14
            } else if i == 4 {
                model.count = 9
            } else {
                model.percent = 36
            }
            list.append(model)
        }
        returnList.accept(list)
        return returnList.asDriver()
    }
    func statisticsPrevMonth(month: Int, year: Int) -> [String] {
        var st = ""
        var month = month
        var year = year
        month -= 1
        if month == 0 {
            month = 12
            year -= 1
        }
        st = "\(year)년 \(month)월"
        return [st,"\(month)","\(year)"]
    }
    func statisticsNextMonth(month: Int, year: Int) -> [String] {
        var st = ""
        var month = month
        var year = year
        month += 1
        if month == 13 {
            month = 1
            year += 1
        }
        st = "\(year)년 \(month)월"
        return [st, "\(month)", "\(year)"]
    }
    
}
// MARK: - API
extension ReportCardViewModel {
    
}
