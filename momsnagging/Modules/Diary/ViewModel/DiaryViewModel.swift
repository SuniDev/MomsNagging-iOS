//
//  DiaryViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/06.
//

import Foundation
import RxSwift
import RxCocoa

class DiaryViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let willAppearDiary: Driver<Void>
        /// 뒤로가기
        let btnBackTapped: Driver<Void>
        /// 캘린더 데이터
        let loadCalendar: Driver<CalendarDate>
        let setCalendarMonth: Driver<Int>
        let setCalendarYear: Driver<Int>
        /// 캘린더 날짜 데이터
        let loadDayList: Driver<[String]>
        /// 캘린더 요일 데이터
        let loadWeekDay: Driver<[String]>
        /// 캘린더 날짜 선택
        let dayModelSelected: Driver<DiaryDayItem>
        /// 캘린더 이동
        let btnPrevTapped: Driver<Void>
        let btnNextTapped: Driver<Void>
        /// 일기장 상세 이동
        let btnDetailTappd: Driver<Void>
        /// 일기장 프레임 탭
        let diaryViewTapped: Driver<Void>
        let emptyDiaryViewTapped: Driver<Void>
        
    }
    // MARK: - Output
    struct Output {
        /// 뒤로가기
        let goToBack: Driver<Void>
        /// 캘린더 날짜 설정
        let setCalendarDate: Driver<CalendarDate>
        /// 캘린더 날짜 아이템
        let dayItems: Observable<[DiaryDayItem]>
        /// 캘린더 요일 아이템
        let weekItems: Observable<[String]>
        /// 캘린더 날짜 선택
//        let dayItemSelected: Driver<IndexPath>
        /// 이전 달 이동
        let setLastMonth: Driver<CalendarDate>
        /// 다음 달 이동
        let setNextMonth: Driver<CalendarDate>
        /// 다이어리 데이터
        let setDiaryData: Driver<Diary>
        let isEmptyDiary: Driver<Bool>
        /// 작성하기 이동
        let goToDetail: Driver<DetailDiaryViewModel?>
    }
    
    func transform(input: Input) -> Output {
        // 로드 캘린더 날짜
        let setCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        // 캘린더 날짜 목록
        let dayList = BehaviorRelay<[String]>(value: [])
        // 선택 날짜
        let selectedDate = BehaviorRelay<String>(value: "")
        // 현재 선택 일기
//        let selectedDiary = BehaviorRelay<Diary?>(value: nil)
    
        let reloadData = input.willAppearDiary.skip(1)
        reloadData
            .drive(onNext: {
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
            .flatMapLatest { date -> Observable<DiaryCalendar> in
                self.isLoading.accept(true)
                return self.requestDiaryCalendar(year: date.year, month: date.month)
            }.share()
        requestCalendarDate
            .bind(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
        // 캘린더 콜렉션뷰 Item 세팅
        let arrDay = requestCalendarDate
            .map { return $0.arrDay ?? [] }
            .filter { $0.count > 0 }
            .flatMapLatest { arrDay -> Observable<[DiaryDay]> in
                return Observable.just(arrDay)
            }.share()
        
        let dayItems = Observable.zip(dayList.asObservable(), arrDay).debug()
            .flatMapLatest { arrStrDay, arrDay -> Observable<[DiaryDayItem]> in
                return self.getDayItems(arrStrDay: arrStrDay, arrDay: arrDay)
            }
                
        input.dayModelSelected
            .drive(onNext: { dayItem in
                if let date = dayItem.day?.diaryDate {
                    selectedDate.accept(date)
                }
            }).disposed(by: disposeBag)
        
        let requestGetDiary = selectedDate
            .flatMapLatest { date -> Observable<Diary> in
                self.isLoading.accept(true)
                return self.requestGetDiary(date: date)
            }.share()
        
        requestGetDiary
            .bind(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
        let isEmptyDiary = requestGetDiary
            .map { return $0.title?.isEmpty ?? true }
        
        let goToDetail = Observable.merge(input.btnDetailTappd.asObservable(),
                                          input.diaryViewTapped.asObservable(),
                                          input.emptyDiaryViewTapped.asObservable())
            .map { _ -> DetailDiaryViewModel? in
                let viewModel = DetailDiaryViewModel(withService: self.provider, selectedDate: selectedDate.value)
                return viewModel
            }.filter { $0 != nil }
            
        return Output(goToBack: input.btnBackTapped,
                      setCalendarDate: setCalendarDate.asDriverOnErrorJustComplete(),
                      dayItems: dayItems,
                      weekItems: input.loadWeekDay.asObservable(),
                      setLastMonth: setLastMonth.asDriverOnErrorJustComplete(),
                      setNextMonth: setNextMonth.asDriverOnErrorJustComplete(),
                      setDiaryData: requestGetDiary.asDriverOnErrorJustComplete(),
                      isEmptyDiary: isEmptyDiary.asDriverOnErrorJustComplete(),
                      goToDetail: goToDetail.asDriverOnErrorJustComplete()
        )
    }
}
extension DiaryViewModel {
    
    func getDayItems(arrStrDay: [String], arrDay: [DiaryDay]) -> Observable<[DiaryDayItem]> {
        return Observable<[DiaryDayItem]>.create { observer -> Disposable in
            var dayItems = [DiaryDayItem]()
            var cntDay = 0
            for strDay in arrStrDay {
                var dayItem: DiaryDayItem
                if strDay == "emptyCell" {
                    dayItem = DiaryDayItem(strDay: "", day: nil, isToday: false, isThisMonth: false)
                } else {
                    let day = arrDay[cntDay]
                    dayItem = DiaryDayItem(strDay: strDay, day: day, isToday: false, isThisMonth: true)
                    
                    if let strDate = day.diaryDate {
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
extension DiaryViewModel {
    private func requestDiaryCalendar(year: Int, month: Int) -> Observable<DiaryCalendar> {
        let request = DiaryCalendarRequest(retrieveYear: year, retrieveMonth: month)
        return self.provider.diaryService.diaryCalendar(request: request)
    }
    
    private func requestGetDiary(date: String) -> Observable<Diary> {
        let request = GetDiaryRequest(retrieveDate: date)
        return self.provider.diaryService.getDiary(request: request)
    }
}

struct CalendarDate {
    var year: Int = 2022
    var month: Int = 1
    var day: Int = 1
}

struct DiaryDayItem {
    let strDay: String
    var day: DiaryDay?
    var isToday: Bool
    var isThisMonth: Bool
}
