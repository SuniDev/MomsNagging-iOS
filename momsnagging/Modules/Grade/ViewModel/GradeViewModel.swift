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
        let tabCalendar: Driver<Void>
        let tabStatistics: Driver<Void>
        
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
        
        // 통계 - 월간 평가
        /// 캘린더 데이터
        let setSttCalendarMonth: Driver<Int>
        let setSttCalendarYear: Driver<Int>
        /// 캘린더 이동
        let btnSttPrevTapped: Driver<Void>
        let btnSttNextTapped: Driver<Void>
        
//        var tabAction: Driver<Bool>?
//        var statisticsPrev: Driver<Void>
//        var statisticsNext: Driver<Void>
//        var currentMonth: Int?
//        var currentYear: Int?
//        var awardTap: Driver<Void>
    }
    // MARK: - Output
    struct Output {
        // 탭
        let tabCalendar: Driver<Void>
        let tabStatistics: Driver<Void>
        // 달력 - 캘린더
        /// 캘린더 날짜 설정
        let setCalendarDate: Driver<CalendarDate>
        /// 캘린더 날짜 아이템
        let dayItems: Observable<[GradeDayItem]>
        /// 캘린더 요일 아이템
        let weekItems: Observable<[String]>
        /// 이전 달 이동
        let setLastMonth: Driver<CalendarDate>
        /// 다음 달 이동
        let setNextMonth: Driver<CalendarDate>
        /// 캘린더 날짜 개수
        let countDayItems: Driver<Int>
        
        // 달력 - 투두 리스트
        /// 투두 리스트
        let todoItems: Observable<[TodoListModel]>
        /// 투두 리스트 갯수
        let countTodoItems: Driver<Int>
        
        // 통계 - 월간 평가
        /// 캘린더 날짜 설정
        let setSttCalendarDate: Driver<CalendarDate>
        /// 이전 달 이동
        let setSttLastMonth: Driver<CalendarDate>
        /// 다음 달 이동
        let setSttNextMonth: Driver<CalendarDate>
        /// 월간 평가 데이터
        let sttMonthlyItems: Observable<[StatisticsMontlyItem]>
        /// 월간 평가 개수
        let countSttMonthly: Driver<Int>
//        var reportListData: Driver<[ReportModel]>?
//        var reportBottomData: Driver<[ReportBottomModel]>?
//        var statisticsPrev: Driver<Void>
//        var statisticsNext: Driver<Void>
//        var awardTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        // MARK: - 공통
        // 달력 - 캘린더 날짜
        let setCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        // 달력 - 캘린더 날짜 목록
        let dayList = BehaviorRelay<[String]>(value: [])
        // 달력 - 선택 날짜
        let selectedDate = BehaviorRelay<String>(value: "")
    
        // 달력 - 캘린더 날짜
        let setSttCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        
        self.mainTabHandler.skip(1)
            .distinctUntilChanged()
            .filter({ $0 == 1 })
            .mapToVoid()
            .subscribe(onNext: {
                setCalendarDate.accept(setCalendarDate.value)
                dayList.accept(dayList.value)
                selectedDate.accept(selectedDate.value)
            }).disposed(by: disposeBag)
        
        // 캘린더 로드
        let loadCalendar = input.loadCalendar.asObservable().share()
        loadCalendar
            .subscribe(onNext: { date in
                // 달력
                setCalendarDate.accept(date)
                selectedDate.accept(self.getStrDate(date: date))
                // 통계
                setSttCalendarDate.accept(date)
            }).disposed(by: disposeBag)
        
        // MARK: - 달력 탭
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
                return self.requestGradeCalendar(year: date.year, month: date.month)
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
        
        // MARK: - 통계 탭
        // 다음 달
        let setSttLastMonth = input.btnSttPrevTapped.asObservable()
            .map { _ -> CalendarDate in
                return setSttCalendarDate.value
            }
        
        // 이전 달
        let setSttNextMonth = input.btnSttNextTapped.asObservable()
            .map { _ -> CalendarDate in
                return setSttCalendarDate.value
            }
        
        // 캘린더 달 적용
        let setSttCalendarMonth = input.setSttCalendarMonth.asObservable().share()
        setSttCalendarMonth.skip(1)
            .map { month -> CalendarDate in
                var date = setSttCalendarDate.value
                date.month = month
                return date
            }
            .subscribe(onNext: { date in
                setSttCalendarDate.accept(date)
            }).disposed(by: disposeBag)
        
        // 캘린더 년 적용
        let setSttCalendarYear = input.setSttCalendarYear.asObservable().share()
        setSttCalendarYear.skip(1)
            .map { year -> CalendarDate in
                var date = setSttCalendarDate.value
                date.year = year
                return date
            }
            .subscribe(onNext: { date in
                setSttCalendarDate.accept(date)
            }).disposed(by: disposeBag)
        
        // 월간 평가 API Request
        let requestStatisticsMonthly = setSttCalendarDate
            .flatMapLatest { date -> Observable<StatisticsMonthly> in
                return self.requestStatisticsMonthly(year: date.year, month: date.month)
            }.share()
        
        let arrStatisticsMonthly = requestStatisticsMonthly
            .map { return $0.arrData ?? [] }
            .filter { $0.count > 0 }
            .flatMapLatest { arrData -> Observable<[StatisticsMonthlyData]> in
                return Observable.just(arrData)
            }.share()
        
        let sttMonthlyItems = arrStatisticsMonthly
            .flatMapLatest { arrData -> Observable<[StatisticsMontlyItem]> in
                return self.getStatisticsMonthlyItems(arrData: arrData)
            }.share()
        
        let countSttMonthly = sttMonthlyItems
            .map { return $0.count }
        
        return Output(
                    tabCalendar: input.tabCalendar,
                    tabStatistics: input.tabStatistics,
                    setCalendarDate: setCalendarDate.asDriverOnErrorJustComplete(),
                    dayItems: dayItems,
                    weekItems: input.loadWeekDay.asObservable(),
                    setLastMonth: setLastMonth.asDriverOnErrorJustComplete(),
                    setNextMonth: setNextMonth.asDriverOnErrorJustComplete(),
                    countDayItems: countDayItems.asDriverOnErrorJustComplete(),
                    todoItems: todoItems,
                    countTodoItems: countTodoItems.asDriverOnErrorJustComplete(),
                    setSttCalendarDate: setSttCalendarDate.asDriverOnErrorJustComplete(),
                    setSttLastMonth: setSttLastMonth.asDriverOnErrorJustComplete(),
                    setSttNextMonth: setSttNextMonth.asDriverOnErrorJustComplete(),
                    sttMonthlyItems: sttMonthlyItems,
                    countSttMonthly: countSttMonthly.asDriverOnErrorJustComplete()
        )
    }    
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
    
    func getStatisticsMonthlyItems(arrData: [StatisticsMonthlyData]) -> Observable<[StatisticsMontlyItem]> {
        return Observable<[StatisticsMontlyItem]>.create { observer -> Disposable in
            var items = [StatisticsMontlyItem]()
            
            for data in arrData {
                                
                var week = ""
                switch data.weekOfMonth {
                case 1: week = "첫째주"
                case 2: week = "둘째주"
                case 3: week = "셋째주"
                case 4: week = "넷째주"
                case 5: week = "다섯째주"
                case 6: week = "여섯째주"
                default: week = ""
                }
                
                var grade = ""
                switch data.gradeOfWeek {
                case 1: grade = "수"
                case 2: grade = "우"
                case 3: grade = "미"
                case 4: grade = "양"
                case 5: grade = "가"
                default: grade = ""
                }
                
                let item = StatisticsMontlyItem(week: week, grade: grade)
                items.append(item)
            }
            
            observer.onNext(items)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

// MARK: - API
extension GradeViewModel {
    
    private func requestGradeCalendar(year: Int, month: Int) -> Observable<GradeCalendar> {
        let request = GradeCalendarRequest(retrieveYear: year, retrieveMonth: month)
        return self.provider.gradeService.calendar(request: request)
    }
    
    private func requestStatisticsMonthly(year: Int, month: Int) -> Observable<StatisticsMonthly> {
        let request = StatisticsMonthlyRequest(retrieveYear: year, retrieveMonth: month)
        return self.provider.gradeService.monthly(request: request)
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

struct StatisticsMontlyItem {
    let week: String
    let grade: String
}
