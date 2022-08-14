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
import UIKit

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
        let willApearView: Driver<Void>
        let viewTapped: Driver<Void>
        
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
        /// 달력 팁
        let btnTipTapped: Driver<Void>
        
        // 통계 - 월간 평가
        /// 캘린더 데이터
        let setSttCalendarMonth: Driver<Int>
        let setSttCalendarYear: Driver<Int>
        /// 캘린더 이동
        let btnSttPrevTapped: Driver<Void>
        let btnSttNextTapped: Driver<Void>
        
        // 상장
        let btnAwardTapped: Driver<Void>
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
        /// 팁 보이기
        let isHiddenTip: Driver<Bool>
        
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
        /// 성적표 통계
        let sttItems: Observable<[StatisticsItem]>
        /// 함께 한지
        let countTogether: Driver<Int>
        /// 성적표 통게 개수
        let countStt: Driver<Int>
        /// 팁 숨기기
        let hideTip: Driver<Void>
        
        // 상장
        let showAward: Driver<AwardViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        // MARK: - 공통
        // 달력 - 캘린더 날짜
        let setCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        // 달력 - 캘린더 날짜 목록
        let dayList = BehaviorRelay<[String]>(value: [])
        // 달력 - 선택 날짜
        let selectedDate = BehaviorRelay<String>(value: "")
    
        // 통계 - 캘린더 날짜
        let setSttCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        // 통계 - 성적표 통계 트리거
        let requestStatisticsTrigger = PublishSubject<Void>()
        
        self.mainTabHandler.skip(1)
            .distinctUntilChanged()
            .filter({ $0 == 1 })
            .mapToVoid()
            .subscribe(onNext: {
                setCalendarDate.accept(setCalendarDate.value)
                dayList.accept(dayList.value)
                selectedDate.accept(selectedDate.value)
                setSttCalendarDate.accept(setSttCalendarDate.value)
                requestStatisticsTrigger.onNext(())
            }).disposed(by: disposeBag)
        
        input.willApearView
            .drive(onNext: {
                requestStatisticsTrigger.onNext(())
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
                self.isLoading.accept(true)
                return self.requestGradeCalendar(year: date.year, month: date.month)
            }.share()
        requestCalendarDate
            .bind(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
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
                self.isLoading.accept(true)
                return self.requestSchedule(date: date)
            }.share()
        
        let countTodoItems = todoItems
            .map { return $0.count }
        
        todoItems
            .bind(onNext: { _ in self.isLoading.accept(false) })
            .disposed(by: disposeBag)
        
        // MARK: - 통계 탭
        // 통계 탭
        let tabStatistics = input.tabStatistics.asObservable().share()
        
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
                self.isLoading.accept(true)
                return self.requestStatisticsMonthly(year: date.year, month: date.month)
            }.share()
        requestStatisticsMonthly
            .bind(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
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
        
        // 성적표 통계 API Request
        let requestStatistics = requestStatisticsTrigger
            .flatMapLatest { _ -> Observable<Statistics> in
                self.isLoading.accept(true)
                return self.requestStatistics()
            }.share()
        
        let sttItems = requestStatistics
            .flatMapLatest { data -> Observable<[StatisticsItem]> in
                self.isLoading.accept(false)
                return self.getStatisticsItems(data: data)
            }.share()
        
        let countStt = sttItems
            .map { return $0.count }
        
        let countTogether = requestStatistics
            .map { return Common.TEST ? Test.togetherCount : $0.togetherCount ?? 0 }
            .filter({ $0 > 0 })
        
        // 상장
        let showAward = input.btnAwardTapped
            .map { _ -> AwardViewModel in
                let viewModel = AwardViewModel(withService: self.provider)
                return viewModel
            }
        
        // 달력 Tip
        let isHiddenTip = BehaviorRelay<Bool>(value: true)
        
        tabStatistics
            .subscribe(onNext: {
                if !isHiddenTip.value {
                    isHiddenTip.accept(true)
                }
            }).disposed(by: disposeBag)
        
        input.btnTipTapped
            .drive(onNext: {
                isHiddenTip.accept(!isHiddenTip.value)
            }).disposed(by: disposeBag)
        
        return Output(
                    tabCalendar: input.tabCalendar,
                    tabStatistics: tabStatistics.asDriverOnErrorJustComplete(),
                    setCalendarDate: setCalendarDate.asDriverOnErrorJustComplete(),
                    dayItems: dayItems,
                    weekItems: input.loadWeekDay.asObservable(),
                    setLastMonth: setLastMonth.asDriverOnErrorJustComplete(),
                    setNextMonth: setNextMonth.asDriverOnErrorJustComplete(),
                    countDayItems: countDayItems.asDriverOnErrorJustComplete(),
                    isHiddenTip: isHiddenTip.asDriver(onErrorJustReturn: true),
                    todoItems: todoItems,
                    countTodoItems: countTodoItems.asDriverOnErrorJustComplete(),
                    setSttCalendarDate: setSttCalendarDate.asDriverOnErrorJustComplete(),
                    setSttLastMonth: setSttLastMonth.asDriverOnErrorJustComplete(),
                    setSttNextMonth: setSttNextMonth.asDriverOnErrorJustComplete(),
                    sttMonthlyItems: sttMonthlyItems,
                    countSttMonthly: countSttMonthly.asDriverOnErrorJustComplete(),
                    sttItems: sttItems,
                    countTogether: countTogether.asDriverOnErrorJustComplete(),
                    countStt: countStt.asDriverOnErrorJustComplete(),
                    hideTip: input.viewTapped,
                    showAward: showAward.asDriver()
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
                    dayItem = GradeDayItem(strDay: "", day: nil, isToday: false, isThisMonth: false, isFuture: false)
                } else {
                    let now = Date().to(for: "yyyy-MM-dd")

                    let day = arrDay[cntDay]
                    var isFuture = false
                    if let date = day.date?.toDate(for: "yyyy-MM-dd"), now.dateCompare(fromDate: date) == "Future" {
                        isFuture = true
                    }
                    
                    dayItem = GradeDayItem(strDay: strDay, day: day, isToday: false, isThisMonth: true, isFuture: isFuture)
                    
                    if let strDate = day.date {
                        dayItem.isToday = strDate == now.toString(for: "yyyy-MM-dd")
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
                
                var grade = "?"
                switch data.gradeOfWeek {
                case 1: grade = "수"
                case 2: grade = "우"
                case 3: grade = "미"
                case 4: grade = "양"
                case 5: grade = "가"
                default: grade = "?"
                }
                
                let item = StatisticsMontlyItem(week: week, grade: grade)
                items.append(item)
            }
            
            observer.onNext(items)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getStatisticsItems(data: Statistics) -> Observable<[StatisticsItem]> {
        return Observable<[StatisticsItem]>.create { observer -> Disposable in            
            var items = [StatisticsItem]()
            
            items.append(StatisticsItem(title: "전체 수행", tip: Asset.Assets.gradeTip1.image, data: "\(data.fullDoneCount ?? 0)", suffix: "일"))
            items.append(StatisticsItem(title: "일부 수행", tip: Asset.Assets.gradeTip2.image, data: "\(data.partialDoneCount ?? 0)", suffix: "일"))
            items.append(StatisticsItem(title: "습관 수행", tip: Asset.Assets.gradeTip3.image, data: "\(data.routineDoneCount ?? 0)", suffix: "일"))
            items.append(StatisticsItem(title: "할일 수행", tip: Asset.Assets.gradeTip4.image, data: "\(data.todoDoneCount ?? 0)", suffix: "일"))
            items.append(StatisticsItem(title: "일기 작성", tip: Asset.Assets.gradeTip5.image, data: "\(data.diaryCount ?? 0)", suffix: "번"))
            items.append(StatisticsItem(title: "평균 수행률", tip: Asset.Assets.gradeTip6.image, data: "\(data.performanceAvg ?? 0)", suffix: "%"))
            
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
    
    private func requestStatistics() -> Observable<Statistics> {
        let request = StatisticsRequest()
        return self.provider.gradeService.statistics(request: request)
    }
    
    private func requestSchedule(date: String) -> Observable<[TodoListModel]> {
        return Observable<[TodoListModel]>.create { observer -> Disposable in
            if Common.TEST {
                 observer.onNext(Test.getRandomTodoList())
                observer.onCompleted()
            }
            
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
                    
                } catch {
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
    var isFuture: Bool
}

struct StatisticsMontlyItem {
    let week: String
    let grade: String
}

struct StatisticsItem {
    let title: String
    let tip: UIImage
    let data: String
    let suffix: String
}
