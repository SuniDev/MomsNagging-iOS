//
//  GradeViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class GradeViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var scheduleService = MoyaProvider<ScheduleService>()
    let mainTabHandler: PublishRelay<Int>
//    var todoListData: [TodoListModel] = []
//    var reportListData: [ReportModel] = []
//    var cellCount: Int = -1
    
    // MARK: - init
    init(withService provider: AppServices, mainTabHandler: PublishRelay<Int>) {
        self.mainTabHandler = mainTabHandler
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        // 탭
//        let tabCalendar: Driver<Void>
//        let tabPerformRate: Driver<Void>
        
        // 달력 - 캘린더
        /// 캘린더 데이터
        let loadCalendar: Driver<CalendarDate>
        let setCalendarMonth: Driver<Int>
        let setCalendarYear: Driver<Int>
        /// 캘린더 날짜 데이터
        let loadDayList: Driver<[String]>
        /// 캘린더 요일 데이터
        let loadWeekDay: Driver<[String]>
        /// 캘린더 날짜 선택
        let dayModelSelected: Driver<GradeDayItem>
        /// 캘린더 이동
        let btnPrevTapped: Driver<Void>
        let btnNextTapped: Driver<Void>
        
//        var tabAction: Driver<Bool>?
//        var statisticsPrev: Driver<Void>
//        var statisticsNext: Driver<Void>
//        var currentMonth: Int?
//        var currentYear: Int?
//        var awardTap: Driver<Void>
    }
    // MARK: - Output
    struct Output {
        // 달력 - 캘린더
        /// 캘린더 날짜 설정
        let setCalendarDate: Driver<CalendarDate>
        /// 캘린더 날짜 아이템
        let dayItems: Observable<[GradeDayItem]>
        /// 캘린더 요일 아이템
        let weekItems: Observable<[String]>
        /// 캘린더 날짜 선택
//        let dayItemSelected: Driver<IndexPath>
        /// 이전 달 이동
        let setLastMonth: Driver<CalendarDate>
        /// 다음 달 이동
        let setNextMonth: Driver<CalendarDate>
        /// 캘린더 날짜 개수
        let countDayItems: Driver<Int>
        /// 투두 리스트
        let todoItems: Observable<[TodoListModel]>
        /// 투두 리스트 갯수
        let countTodoItems: Driver<Int>
//        var tabAction = PublishRelay<Bool>()
//        var todoListData: Driver<[TodoListModel]>? // 투두리스트 더미 데이터모델
//        var cellItemCount = PublishRelay<Bool>()
//        var reportListData: Driver<[ReportModel]>?
//        var reportBottomData: Driver<[ReportBottomModel]>?
//        var statisticsPrev: Driver<Void>
//        var statisticsNext: Driver<Void>
//        var awardTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        // 로드 캘린더 날짜
        let setCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        // 캘린더 날짜 목록
        let dayList = BehaviorRelay<[String]>(value: [])
        // 선택 날짜
        let selectedDate = BehaviorRelay<String>(value: "")
        
        self.mainTabHandler.skip(1)
            .distinctUntilChanged()
            .filter({ $0 == 1 })
            .mapToVoid()
            .subscribe(onNext: {
                setCalendarDate.accept(setCalendarDate.value)
                selectedDate.accept(selectedDate.value)
                dayList.accept(dayList.value)
            }).disposed(by: disposeBag)
        
        // 캘린더 로드
        let loadCalendar = input.loadCalendar.asObservable().share()
        loadCalendar
            .subscribe(onNext: { date in
                setCalendarDate.accept(date)
                selectedDate.accept(self.getStrDate(date: date))
            }).disposed(by: disposeBag)
        
        input.loadDayList
            .drive(onNext: { list in
                dayList.accept(list)
            }).disposed(by: disposeBag)
        
        // 다음 달
        let setLastMonth = input.btnPrevTapped.asObservable()
            .map { _ -> CalendarDate in
                return setCalendarDate.value
            }
        
        // 이전 달
        let setNextMonth = input.btnNextTapped.asObservable()
            .map { _ -> CalendarDate in
                return setCalendarDate.value
            }
        
        // 캘린더 달 적용
        let setCalendarMonth = input.setCalendarMonth.asObservable().share()
        setCalendarMonth.skip(1)
            .map { month -> CalendarDate in
                var date = setCalendarDate.value
                date.month = month
                return date
            }
            .subscribe(onNext: { date in
                setCalendarDate.accept(date)
            }).disposed(by: disposeBag)
        
        // 캘린더 년 적용
        let setCalendarYear = input.setCalendarYear.asObservable().share()
        setCalendarYear.skip(1)
            .map { year -> CalendarDate in
                var date = setCalendarDate.value
                date.year = year
                return date
            }
            .subscribe(onNext: { date in
                setCalendarDate.accept(date)
            }).disposed(by: disposeBag)
        
        // 캘린더 API Request
        let requestCalendarDate = setCalendarDate.debug()
            .flatMapLatest { date -> Observable<GradeCalendar> in
                return self.reqeustGradeCalendar(year: date.year, month: date.month)
            }.share()
        
        // 캘린더 콜렉션뷰 Item 세팅
        let arrDay = requestCalendarDate
            .map { return $0.arrDay ?? [] }
            .filter { $0.count > 0 }
            .flatMapLatest { arrDay -> Observable<[GradeDay]> in
                return Observable.just(arrDay)
            }.share()
        
        let dayItems = Observable.zip(dayList.asObservable(), arrDay)
            .flatMapLatest { arrStrDay, arrDay -> Observable<[GradeDayItem]> in
                return self.getDayItems(arrStrDay: arrStrDay, arrDay: arrDay)
            }.share()
        
        // 캘린더 날짜 개수
        let countDayItems = dayItems.map { return $0.count }
        
        input.dayModelSelected
            .drive(onNext: { dayItem in
                if let date = dayItem.day?.date {
                    selectedDate.accept(date)
                }
            }).disposed(by: disposeBag)
        
        let todoItems = selectedDate
            .flatMapLatest { date -> Observable<[TodoListModel]> in
                return self.requestSchedule(date: date)
            }
        
        let countTodoItems = todoItems
            .map { return $0.count }
        
        return Output(setCalendarDate: setCalendarDate.asDriverOnErrorJustComplete(),
                      dayItems: dayItems,
                      weekItems: input.loadWeekDay.asObservable(),
                      setLastMonth: setLastMonth.asDriverOnErrorJustComplete(),
                      setNextMonth: setNextMonth.asDriverOnErrorJustComplete(),
                      countDayItems: countDayItems.asDriverOnErrorJustComplete(),
                      todoItems: todoItems,
                      countTodoItems: countTodoItems.asDriverOnErrorJustComplete())
        
//        let requestGetDiary = selectedDate
//            .flatMapLatest { date -> Observable<Diary> in
//                return self.requestGetDiary(date: date)
//            }
        
//        let tabAction = PublishRelay<Bool>()
//
//        input.tabAction?.drive { bool in
//            if bool {
//                tabAction.accept(true)
//            } else {
//                tabAction.accept(false)
//            }
//        }.disposed(by: disposeBag)
//
//        let todoListData = todoList()
//
//        let cellItemCount = PublishRelay<Bool>()
//        cellItemCount.accept((self.cellCount != 0))
//
//        let ratingData = ratingList()
//        let reportBottomData = statisticsList()
//
//        return Output(tabAction: tabAction, todoListData: todoListData.asDriver(), cellItemCount: cellItemCount, reportListData: ratingData.asDriver(), reportBottomData: reportBottomData, statisticsPrev: input.statisticsPrev, statisticsNext: input.statisticsNext, awardTap: input.awardTap)
    }
//    // 통계페이지 등급 더미
//    func ratingList() -> Driver<[ReportModel]> {
//        let returnList = BehaviorRelay<[ReportModel]>(value: [])
//        var list: [ReportModel] = []
//        for _ in 0...3 {
//            var model = ReportModel()
//            model.rating = "수"
//            list.append(model)
//        }
//        returnList.accept(list)
//        self.cellCount = list.count
//        return returnList.asDriver()
//    }
//    // 통계페이지 통계 더미
//    func statisticsList() -> Driver<[ReportBottomModel]> {
//        let returnList = BehaviorRelay<[ReportBottomModel]>(value: [])
//        var list: [ReportBottomModel] = []
//        for i in 0...5 {
//            var model = ReportBottomModel()
//            if i == 0 {
//                model.days = 40
//            } else if i == 1 {
//                model.days = 12
//            } else if i == 2 {
//                model.days = 23
//            } else if i == 3 {
//                model.days = 14
//            } else if i == 4 {
//                model.count = 9
//            } else {
//                model.percent = 36
//            }
//            list.append(model)
//        }
//        returnList.accept(list)
//        return returnList.asDriver()
//    }
//    func statisticsPrevMonth(month: Int, year: Int) -> [String] {
//        var st = ""
//        var month = month
//        var year = year
//        month -= 1
//        if month == 0 {
//            month = 12
//            year -= 1
//        }
//        st = "\(year)년 \(month)월"
//        return [st,"\(month)","\(year)"]
//    }
//    func statisticsNextMonth(month: Int, year: Int) -> [String] {
//        var st = ""
//        var month = month
//        var year = year
//        month += 1
//        if month == 13 {
//            month = 1
//            year += 1
//        }
//        st = "\(year)년 \(month)월"
//        return [st, "\(month)", "\(year)"]
//    }
    
}

extension GradeViewModel {
    
    func getDayItems(arrStrDay: [String], arrDay: [GradeDay]) -> Observable<[GradeDayItem]> {
        return Observable<[GradeDayItem]>.create { observer -> Disposable in
            var dayItems = [GradeDayItem]()
            var cntDay = 0
            for strDay in arrStrDay {
                var dayItem: GradeDayItem
                if strDay == "emptyCell" {
                    dayItem = GradeDayItem(strDay: "", day: nil, isToday: false, isThisMonth: false)
                } else {
                    let day = arrDay[cntDay]
                    dayItem = GradeDayItem(strDay: strDay, day: day, isToday: false, isThisMonth: true)
                    
                    if let strDate = day.date {
                        dayItem.isToday = strDate == Date().toString(for: "yyyy-MM-dd")
                    }
                    
                    cntDay += 1
                }
                dayItems.append(dayItem)
            }
            observer.onNext(dayItems)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getStrDate(date: CalendarDate) -> String {
        let strYear = "\(date.year)"
        
        var strMonth = "\(date.month)"
        var strDay = "\(date.day)"
        
        if date.month < 10 {
            strMonth = "0\(date.month)"
        }
        
        if date.day < 10 {
            strDay = "0\(date.day)"
        }
        
        return "\(strYear)-\(strMonth)-\(strDay)"
    }
}

// MARK: - API
extension GradeViewModel {
    
    private func reqeustGradeCalendar(year: Int, month: Int) -> Observable<GradeCalendar> {
        let request = GradeCalendarRequest(retrieveYear: year, retrieveMonth: month)
        return self.provider.gradeService.calendar(request: request)
    }
    
    private func requestSchedule(date: String) -> Observable<[TodoListModel]> {
        return Observable<[TodoListModel]>.create { observer -> Disposable in
            self.scheduleService.request(.todoListLookUp(retrieveDate: date), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestTodoListLookUp json : \(json)")
                    
                    var todoList = [TodoListModel]()
                    
                    if json.dictionary?["status"]?.intValue == nil {
                        for item in json.array! {
                            var model = TodoListModel()
                            model.seqNumber = item.dictionary?["seqNumber"]?.intValue ?? 0
                            model.scheduleType = item.dictionary?["scheduleType"]?.stringValue ?? ""
                            model.scheduleName = item.dictionary?["scheduleName"]?.stringValue ?? ""
                            model.naggingId = item.dictionary?["naggingId"]?.intValue ?? 0
                            model.scheduleTime = item.dictionary?["scheduleTime"]?.stringValue ?? ""
                            model.status = item.dictionary?["status"]?.intValue ?? 0
                            model.id = item.dictionary?["id"]?.intValue ?? 0
                            model.goalCount = item.dictionary?["goalCount"]?.intValue ?? 0
                            model.originalId = item.dictionary?["originalId"]?.intValue ?? 0
                            todoList.append(model)
                        }
                    }
                    observer.onNext(todoList)
                    observer.onCompleted()
                    
                } catch(let error) {
                    Log.error("requestTodoListLookUp error", "\(error)")
                    observer.onError(error)
                }
            case .failure(let error):
                Log.error("requestTodoListLookUp failure error", "\(error)")
                observer.onError(error)
            }
        })
        return Disposables.create()
        }
    }
}

struct GradeDayItem {
    let strDay: String
    var day: GradeDay?
    var isToday: Bool
    var isThisMonth: Bool
}
