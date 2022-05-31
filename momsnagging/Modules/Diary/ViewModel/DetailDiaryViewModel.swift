//
//  DetailDiaryViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import Foundation
import RxSwift
import RxCocoa

class DetailDiaryViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    private let selectedDate: BehaviorRelay<String>
    
    // TODO: Diary 날짜 받기
    init(withService provider: AppServices, selectedDate: String) {
        self.selectedDate = BehaviorRelay<String>(value: selectedDate)
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let willAppearDetailDiary: Driver<Void>
        /// 캘린더
        let loadCalendar: Driver<CalendarDate>
        let setCalendarMonth: Driver<Int>
        let setCalendarYear: Driver<Int>
        let loadDayList: Driver<[String]>
        let loadWeekDay: Driver<[String]>
//        let dayModelSelected: Driver<DetailDiaryDayItem>
        let dayItemsSelected: Driver<IndexPath>
        let btnPrevTapped: Driver<Void>
        let btnNextTapped: Driver<Void>
        let dateChangeAlertHandler: Driver<Bool>        // true : 네 / false : 아니오
        /// 더보기
        let btnMoreTapped: Driver<Void>
        let dimViewTapped: Driver<Void>
        let btnModifyTapped: Driver<Void>
        let btnDeleteTapped: Driver<Void>
        /// 뒤로가기
        let btnBackTapped: Driver<Void>
        let backAlertDoneHandler: Driver<Void>
        /// 삭제하기
        let deleteAlertDoneHandler: Driver<Void>
        /// 작성
        let textTitle: Driver<String?>
        let textContents: Driver<String?>
        let editingDidEndOnExitTitle: Driver<Void>
        let didBeginContents: Driver<Void>
        let didEndEditingContents: Driver<Void>
        /// 완료
        let btnDoneTapped: Driver<Void>
        let doneAlertDoneHandler: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 캘린더 날짜 설정
        let setTitleDate: Driver<String>
        let setCalendarDate: Driver<CalendarDate>
        let dayItems: BehaviorRelay<[DetailDiaryDayItem]>
        let weekItems: Observable<[String]>
        let setLastMonth: Driver<CalendarDate>
        let setNextMonth: Driver<CalendarDate>
        let showDateChangeAlert: Driver<String>
        let selectedDayIndex: Driver<Int>
        ///  바텀 시트
        let showBottomSheet: Driver<Void>
        let hideBottomSheet: Driver<Void>
        /// 작성 모드
        let isWriting: Driver<Bool>
        /// 뒤로 가기
        let showBackAlert: Driver<String>
        let goToBack: Driver<Void>
        /// 삭제 하기
        let showDeleteAlert: Driver<String>
        /// 제목 리턴
        let endEditingTitle: Driver<Void>
        /// 내용 플레이스홀더
        let setContentsPlaceholder: Driver<String>
        /// 작성 완료 가능
        let canBeDone: Driver<Bool>
        /// 다이어리 작성 완료
        let successDoneDiary: Driver<String>
        /// 제목 30자 이내 텍스트 (글자 제한)
        let setTextTitle: Driver<String>
        /// 제목 길이 초과 (30자)
        let lengthExceededTitle: Driver<Void>
        /// 내용 1000자 이내 텍스트 (글자 제한)
        let setTextContents: Driver<String>
        /// 내용 길이 초과 (1000자)
        let lengthExceededContents: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let isWriting = BehaviorRelay<Bool>(value: false)
        let contentsPlaceHolder = BehaviorRelay<String>(value: "")
        
        let textTitle = BehaviorRelay<String>(value: "")
        let textContents = BehaviorRelay<String>(value: "")
        let lengthExceededTitle = PublishRelay<Void>()
        let lengthExceededContents = PublishRelay<Void>()
        
        /// 캘린더
        // 캘린더 날짜
        let setCalendarDate = BehaviorRelay<CalendarDate>(value: CalendarDate())
        // 선택 날짜
        let selectedDate = BehaviorRelay<String>(value: self.selectedDate.value)
        let setTitleDate = PublishRelay<String>()
        
        // 캘린더 로드
        let loadCalendar = input.loadCalendar.asObservable().share()
        loadCalendar
            .subscribe(onNext: { date in
                setCalendarDate.accept(date)
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
                
        // 캘린더 콜렉션뷰 Item 세팅
        let dayItems = BehaviorRelay<[DetailDiaryDayItem]>(value: [])
        input.loadDayList
            .asObservable()
            .flatMapLatest { arrStrDay -> Observable<[DetailDiaryDayItem]> in
                return self.getDayItems(arrStrDay: arrStrDay, date: setCalendarDate.value)
            }.subscribe(onNext: { items in
                dayItems.accept(items)
            }).disposed(by: disposeBag)
        
        let selectedDayTrigger = BehaviorRelay<Int>(value: 0)
        let cancelSelectedDayIndex = BehaviorRelay<Int>(value: 0)
        let selectedDayIndex = BehaviorRelay<Int>(value: 0)
        
         input.dayItemsSelected.debug()
             .drive(onNext: { indexPath in
                 selectedDayTrigger.accept(indexPath.row)
             }).disposed(by: disposeBag)
        
        selectedDayTrigger.skip(1)
            .subscribe(onNext: { _ in
                cancelSelectedDayIndex.accept(selectedDayIndex.value)
            }).disposed(by: disposeBag)
        
        selectedDayIndex.skip(1)
            .subscribe(onNext: { index in
                let model = dayItems.value[index]
                selectedDate.accept(model.strDate)
            }).disposed(by: disposeBag)
       
        let isCanDateChange = selectedDayTrigger.skip(1)
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(!isWriting.value)
            }.share()
        
        let showDateChangeAlert = isCanDateChange
            .filter { $0 == false }
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_DIARY_BACK)
            }
        
        let dateChangeAlertHandler = input.dateChangeAlertHandler.asObservable().share()
        
        Observable.merge(isCanDateChange.filter { $0 == true }.asObservable(),
                         dateChangeAlertHandler.filter { $0 == true })
            .subscribe(onNext: { _ in
                selectedDayIndex.accept(selectedDayTrigger.value)
            }).disposed(by: disposeBag)
        
        dateChangeAlertHandler.debug()
            .filter { $0 == false }
            .subscribe(onNext: { _ in
                selectedDayIndex.accept(cancelSelectedDayIndex.value)
            }).disposed(by: disposeBag)
                
        let requestGetDiary = selectedDate.debug()
            .asObservable()
            .flatMapLatest { date -> Observable<Diary> in
                return self.requestGetDiary(date: date)
            }.share()
        
        let isWroteDiary = requestGetDiary
            .flatMapLatest { diary -> Observable<Bool> in
                return Observable.just(diary.title != nil && !(diary.title?.isEmpty ?? true))
            }.share()
        isWroteDiary
            .subscribe(onNext: { isWrote in
                isWriting.accept(!isWrote)
            }).disposed(by: disposeBag)
        
        requestGetDiary
            .subscribe(onNext: { diary in
                textTitle.accept(diary.title ?? "")
                textContents.accept(diary.context ?? "")
                setTitleDate.accept(self.getTitleDateString(dateString: diary.diaryDate ?? ""))
            }).disposed(by: disposeBag)
        
        requestGetDiary
            .filter { $0.context == nil || $0.context?.isEmpty ?? true }
            .flatMapLatest({ _ -> Observable<String> in
                return self.getContentsPlaceholder()
            })
            .subscribe(onNext: { text in
                if textContents.value.isEmpty {
                    contentsPlaceHolder.accept(text)
                }
            }).disposed(by: disposeBag)
        
        requestGetDiary
            .filter { $0.context != nil && !($0.context?.isEmpty ?? true) }
            .subscribe(onNext: { diary in
                textTitle.accept(diary.title ?? "")
                textContents.accept(diary.context ?? "")
            }).disposed(by: disposeBag)
        
        /// 작성 모드
        let btnModifyTapped = input.btnModifyTapped.asObservable().share()
        
        btnModifyTapped
            .subscribe(onNext: {
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        let btnDeleteTapped = input.btnDeleteTapped.asObservable()
        
        let hideBottomSheet = Observable.merge(btnModifyTapped, input.dimViewTapped.asObservable(), btnDeleteTapped)
        let showDeleteAlert = btnDeleteTapped
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_DIARY_DELETE)
            }
        
        isWriting
            .filter { $0 == true }
            .flatMapLatest({ _ -> Observable<String> in
                return self.getContentsPlaceholder()
            })
            .subscribe(onNext: { text in
                if textContents.value.isEmpty {
                    contentsPlaceHolder.accept(text)
                }
            }).disposed(by: disposeBag)
                
        let btnBackTapped = input.btnBackTapped.asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(isWriting.value)
            }.share()
        
        let showBackAlert = btnBackTapped
            .filter { $0 == true }
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_DIARY_BACK)
            }
        
        let backAlertDoneHandler = input.backAlertDoneHandler
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(isWriting.value)
            }.share()
            
        backAlertDoneHandler
            .filter { $0 == false }
            .mapToVoid()
            .subscribe(onNext: {
                isWriting.accept(false)
            }).disposed(by: disposeBag)
        
        ///  삭제하기
        let requestDeleteDiary = input.deleteAlertDoneHandler
            .asObservable()
            .flatMapLatest { _ -> Observable<Diary> in
                let title = ""
                let context = ""
                let date = selectedDate.value
                return self.requestPutDiary(title: title, context: context, diaryDate: date)
            }.share()
        
        /// 일기작 작성
        input.textTitle
            .asObservable()
            .scan("") { previous, new -> String in
                guard let new = new else { return "" }
                if new.count > 30 {
                    lengthExceededTitle.accept(())
                    return previous
                } else {
                    return new
                }
            }.subscribe(onNext: { text in
                textTitle.accept(text)
            }).disposed(by: disposeBag)
        
        input.textContents
            .asObservable()
            .scan("") { previous, new -> String in
                guard let new = new else { return "" }
                if new.count > 1000 {
                    lengthExceededContents.accept(())
                    return previous
                } else {
                    return new
                }
            }.subscribe(onNext: { text in
                textContents.accept(text)
            }).disposed(by: disposeBag)
        
        input.didBeginContents
            .drive(onNext: {
                if !contentsPlaceHolder.value.isEmpty {
                    contentsPlaceHolder.accept("")
                }
            }).disposed(by: disposeBag)

        input.didEndEditingContents
            .asObservable()
            .flatMapLatest({ _ -> Observable<String> in
                return self.getContentsPlaceholder()
            })
            .subscribe(onNext: { text in
                if textContents.value.isEmpty {
                    contentsPlaceHolder.accept(text)
                }
            }).disposed(by: disposeBag)
        
        let canBeDone = Observable.combineLatest(textTitle.asObservable(), textContents.asObservable())
            .map({ dTitle, dContents -> Bool in
                if !dTitle.isEmpty && !dContents.isEmpty && contentsPlaceHolder.value.isEmpty {
                    return true
                }
                return false
            })
        
        let successDoneDiary = input.btnDoneTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<String> in
                return self.getDoneAlertTitle()
            }
        
        let reqeustSaveDiary = input.doneAlertDoneHandler.debug()
            .asObservable()
            .flatMapLatest { _ -> Observable<Diary> in
                let title = textTitle.value
                let context = textContents.value
                let date = selectedDate.value
                return self.requestPutDiary(title: title, context: context, diaryDate: date)
            }.share()
        
        reqeustSaveDiary
            .subscribe(onNext: { _ in
                isWriting.accept(false)
            }).disposed(by: disposeBag)
        
        let goToBack = Observable.merge(
            backAlertDoneHandler.filter { $0 == true }.mapToVoid(),
            btnBackTapped.filter { $0 == false }.mapToVoid(),
            requestDeleteDiary.mapToVoid().asObservable())
        
        return Output(setTitleDate: setTitleDate.asDriverOnErrorJustComplete(),
                      setCalendarDate: setCalendarDate.asDriverOnErrorJustComplete(),
                      dayItems: dayItems,
                      weekItems: input.loadWeekDay.asObservable(),
                      setLastMonth: setLastMonth.asDriverOnErrorJustComplete(),
                      setNextMonth: setNextMonth.asDriverOnErrorJustComplete(),
                      showDateChangeAlert: showDateChangeAlert.asDriverOnErrorJustComplete(),
                      selectedDayIndex: selectedDayIndex.asDriverOnErrorJustComplete(),
                      showBottomSheet: input.btnMoreTapped,
                      hideBottomSheet: hideBottomSheet.asDriverOnErrorJustComplete(),
                      isWriting: isWriting.asDriverOnErrorJustComplete(),
                      showBackAlert: showBackAlert.asDriver(onErrorJustReturn: STR_DIARY_BACK),
                      goToBack: goToBack.asDriverOnErrorJustComplete(),
                      showDeleteAlert: showDeleteAlert.asDriver(onErrorJustReturn: STR_DIARY_DELETE),
                      endEditingTitle: input.editingDidEndOnExitTitle,
                      setContentsPlaceholder: contentsPlaceHolder.asDriverOnErrorJustComplete(),
                      canBeDone: canBeDone.asDriverOnErrorJustComplete(),
                      successDoneDiary: successDoneDiary.asDriverOnErrorJustComplete(),
                      setTextTitle: textTitle.asDriverOnErrorJustComplete(),
                      lengthExceededTitle: lengthExceededTitle.asDriverOnErrorJustComplete(),
                      setTextContents: textContents.asDriverOnErrorJustComplete(),
                      lengthExceededContents: lengthExceededContents.asDriverOnErrorJustComplete())
    }
}
extension DetailDiaryViewModel {
    
    private func getContentsPlaceholder() -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            let type = CommonUser.naggingLevel ?? .fondMom
            switch type {
            case .fondMom: observer.onNext("오늘 하루 어땠어~^^?")
            case .coolMom: observer.onNext("오늘 어땠니.")
            case .angryMom: observer.onNext("너는 꼭 엄마가 먼저 물어봐야 대답하더라. 오늘 어떻게 보냈니?")
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func getDoneAlertTitle() -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            let type = CommonUser.naggingLevel ?? .fondMom
            let nickName = CommonUser.nickName ?? "자식"
            switch type {
            case .fondMom: observer.onNext("우리 \(nickName) 오늘 하루도 수고 많았어^^")
            case .coolMom: observer.onNext("그래. 수고했다.")
            case .angryMom: observer.onNext("다했다고 놀지 말고 다음날 해야할 꺼 미리 미리 준비해놔라!")
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getTitleDateString(dateString: String) -> String {
        var st = ""
        let formatterToString = DateFormatter()
        formatterToString.dateFormat = "yyyy-MM-dd"
        let date = formatterToString.date(from: dateString)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        st = formatter.string(from: date ?? Date())
        
        return st
    }
    
}
extension DetailDiaryViewModel {
    func getDayItems(arrStrDay: [String], date: CalendarDate) -> Observable<[DetailDiaryDayItem]> {
        return Observable<[DetailDiaryDayItem]>.create { observer -> Disposable in
            var dayItems = [DetailDiaryDayItem]()
            for strDay in arrStrDay {
                var dayItem: DetailDiaryDayItem
                if strDay == "emptyCell" {
                    dayItem = DetailDiaryDayItem(strDay: "", strDate: "", isToday: false, isThisMonth: false)
                } else {
                    var date = date
                    date.day = Int(strDay) ?? 1
                    
                    let strDate = self.getStrDate(date: date)
                    dayItem = DetailDiaryDayItem(strDay: strDay, strDate: strDate, isToday: false, isThisMonth: true)
                    dayItem.isToday = strDate == Date().toString(for: "yyyy-MM-dd")
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
extension DetailDiaryViewModel {
    private func requestGetDiary(date: String) -> Observable<Diary> {
        let request = GetDiaryReqeust(retrieveDate: date)
        return self.provider.diaryService.getDiary(request: request)
    }
    private func requestPutDiary(title: String, context: String, diaryDate: String) -> Observable<Diary> {
        let request = PutDiaryReqeust(title: title, context: context, diaryDate: diaryDate)
        return self.provider.diaryService.putDiary(request: request)
    }
}

struct DetailDiaryDayItem {
    let strDay: String
    var strDate: String
    var isToday: Bool
    var isThisMonth: Bool
}
