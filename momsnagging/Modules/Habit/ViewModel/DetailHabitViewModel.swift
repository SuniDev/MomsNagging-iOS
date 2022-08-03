//
//  DetailHabitViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/06.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class DetailHabitViewModel: BaseViewModel, ViewModelType {
    
    enum CycleType: String {
        case week = "어떤 요일?"
        case number = "일주일에 몇 번 이상?"
    }
    
    enum TextHintType: String {
        case empty      = "습관 이름은 필수로 입력해야 한단다."
        case invalid    = "습관 이름은 30글자를 넘길 수 없단다."
        case none       = ""
    }
    
    var disposeBag = DisposeBag()
    var provider = MoyaProvider<ScheduleService>()
    var homeViewModel: HomeViewModel!
    var modifyPage: Bool?
    private let isNew: BehaviorRelay<Bool>
    let isRecommendHabit: BehaviorRelay<Bool>
    private var cycleWeek = BehaviorRelay<[String]>(value: ["월", "화", "수", "목", "금", "토", "일"])
    private var cycleNumber = BehaviorRelay<[String]>(value: ["1", "2", "3", "4", "5", "6"])
    private var dateParam: String?

    var routineInfoOb = PublishSubject<TodoInfoResponseModel>()
    var todoModel: TodoListModel?
    var modifySuccessOb = PublishSubject<Void>()
    var recommendHabitNameOb = PublishSubject<String>()
    var recommendHabitName: String?
    var isRecommendHabitBool: Bool!
    
    var coachMarkStatusCheck: Bool?
    
    init(isNew: Bool, isRecommendHabit: Bool, dateParam: String, homeViewModel: HomeViewModel, todoModel: TodoListModel?=nil, recommendHabitName: String?=nil, coachMarkStatus: Bool? = false) {
        self.isNew = BehaviorRelay<Bool>(value: isNew)
        self.modifyPage = !isNew
        self.isRecommendHabit = BehaviorRelay<Bool>(value: isRecommendHabit)
        self.isRecommendHabitBool = isRecommendHabit
        self.dateParam = dateParam
        self.homeViewModel = homeViewModel
        if let todoModel = todoModel {
            self.todoModel = todoModel
        }
        if let recommendHabitName = recommendHabitName {
            self.recommendHabitName = recommendHabitName
            self.modifyName = recommendHabitName
        }
        Log.debug("todoModel Id", "\(todoModel?.id ?? 0), 습관이름 : \(recommendHabitName ?? "")")
        
        self.coachMarkStatusCheck = coachMarkStatus
    }
    
    private var param = CreateTodoRequestModel()
    private var modifyName: String?
    private var modifyTime: String?
    private var modifyMon: Bool?
    private var modifyTue: Bool?
    private var modifyWed: Bool?
    private var modifyThu: Bool?
    private var modifyFri: Bool?
    private var modifySat: Bool?
    private var modifySun: Bool?
    private var modifyNumber: Int?
    private var modifyAlarm: String?
    private var isModify: Bool = true
    
    private var selectDateWeek: [String] = []
    
    private var weekAndNumberType = 0

    private func selectItemSet(items: [String]) {
        initWeekAndCountParamInit()
        if items.count != 0 {
            if weekAndNumberType == 0 {
                for i in items {
                    switch i {
                    case "월":
                        param.mon = true
                        modifyMon = true
                    case "화":
                        param.tue = true
                        modifyTue = true
                    case "수":
                        param.wed = true
                        modifyWed = true
                    case "목":
                        param.thu = true
                        modifyThu = true
                    case "금":
                        param.fri = true
                        modifyFri = true
                    case "토":
                        param.sat = true
                        modifySat = true
                    case "일":
                        param.sun = true
                        modifySun = true
                    default:
                        break
                    }
                }
            } else {
                modifyNumber = Int(items[0])!
                param.goalCount = Int(items[0])!
            }
        }
    }
    private func initWeekAndCountParamInit() {
        param.mon = false
        param.tue = false
        param.wed = false
        param.thu = false
        param.fri = false
        param.sat = false
        param.sun = false
        param.goalCount = 0
    }

    // MARK: - Input
    struct Input {
        /// 더보기
        let btnMoreTapped: Driver<Void>
        let dimViewTapped: Driver<Void>
        let btnModifyTapped: Driver<Void>
        let btnDeleteTapped: Driver<Void>
        /// 뒤로 가기
        let btnBackTapped: Driver<Void>
        let backAlertDoneHandler: Driver<Void>
        /// 삭제하기
        let deleteAlertDoneHandler: Driver<Void>
        /// 습관 이름
        let textName: Driver<String>
        let editingDidBeginName: Driver<Void>
        let editingDidEndName: Driver<Void>
        /// 수행 시간
        let btnPerformTimeTapped: Driver<Void>
        let textPerformTime: Driver<String?>
        /// 시작 날짜
        let btnStartDateTapped: Driver<Void>
        let textStartDate: Driver<String?>
        let startDateParam: Driver<String?>
        /// 이행 주기
        let btnCycleWeekTapped: Driver<Void>
        let btnCycleNumber: Driver<Void>
        let cycleModelSelected: Driver<String>
        let cycleModelDeselected: Driver<String>
        /// 잔소리 설정
        let valueChangedPush: Driver<Bool>
        let valueChangedTimePicker: Driver<Date>
        /// 완료
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
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
        /// 이름 수정 중
        let isEditingName: Driver<Bool>
        /// 텍스트 힌트
        let textHint: Driver<TextHintType>
        /// '수행 시간 설정' 이동
        let goToPerformTimeSetting: Driver<Void>
        /// 이행 주기 선택
        let selectCycleType: Driver<CycleType>
        /// 이행 주기 아이템
        let cycleItems: BehaviorRelay<[String]>
        /// 잔소리 알림 여부
        let isNaggingPush: Driver<Bool>
        /// 잔소리 시간 선택
        let setTimeNaggingPush: Driver<Date?>
        /// 완료 가능
        let canBeDone: Driver<Bool>
        /// 습관 추가 완료
        let successDoneAddHabit: Driver<Void>
        /// 습관 수정 완료
        let successDoneModifyHabit: Driver<Void>
        /// 추천습관 이름
        let recommendedName: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        self.requestRoutineInfo(scheduleId: todoModel?.id ?? 0)
        /// 작성 모드
        let isWriting = BehaviorRelay<Bool>(value: true)
        let isNew = self.isNew
        isNew
            .bind(onNext: {
                Log.debug("isNew~~", "\($0)")
//                isWriting.accept($0)
//                self.isModify = $0
            }).disposed(by: disposeBag)
        
        let btnModifyTapped = input.btnModifyTapped.asObservable().share()
        
        btnModifyTapped
            .subscribe(onNext: {
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        let btnDeleteTapped = input.btnDeleteTapped.asObservable()
        
        let hideBottomSheet = Observable.merge(btnModifyTapped, input.dimViewTapped.asObservable(), btnDeleteTapped)
        let showDeleteAlert = btnDeleteTapped
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_HABIT_DELETE)
            }
        
        let btnBackTapped = input.btnBackTapped.asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(isWriting.value)
            }.share()
        let showBackAlert = btnBackTapped
            .filter { $0 == true }
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_HABIT_BACK)
            }
        
        let backAlertDoneHandler = input.backAlertDoneHandler
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(self.isNew.value)
            }.share()
        
        let goToBack = Observable.merge(
            backAlertDoneHandler.filter { $0 == false }.mapToVoid(),
            backAlertDoneHandler.filter { $0 == true }.mapToVoid())
        
        backAlertDoneHandler
            .filter { $0 == true }
            .mapToVoid()
            .subscribe(onNext: {
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        /// 습관 이름
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        let recommendedName = BehaviorRelay<String>(value: self.recommendHabitName ?? "")
        
        input.textName
            .drive(onNext: { text in
                if self.recommendHabitName != nil {
                    textName.accept(self.recommendHabitName ?? "")
                } else {
                    textName.accept(text)
                }
                self.param.scheduleName = text
                self.modifyName = text
            }).disposed(by: disposeBag)
        
        input.editingDidBeginName
            .drive(onNext: { () in
                textHint.accept(.none)
                isEditingName.accept(true)
            }).disposed(by: disposeBag)
        
        input.editingDidEndName
            .drive(onNext: { () in
                isEditingName.accept(false)
                textName.accept(textName.value)
                self.param.scheduleName = textName.value
            }).disposed(by: disposeBag)
        
        let isEmptyName = input.editingDidEndName
                    .asObservable()
                    .flatMapLatest { _ -> Observable<Bool> in
                        Observable.just(textName.value.isEmpty)
                    }.share()
        
        isEmptyName.filter({ $0 == true })
            .bind(onNext: { _ in
                textHint.accept(.empty)
            }).disposed(by: disposeBag)
        
        // 사용 가능 여부 확인 (띄어쓰기 포함 한/영/숫자/이모지 30글자)
        let isValidName = isEmptyName
            .filter({ $0 == false })
            .flatMapLatest { _ -> Observable<Bool> in
                let name = textName.value
                if name.count > 30 {
                    return Observable.just(false)
                }
                return Observable.just(true)
            }.share()
        
        isValidName
            .bind(onNext: { isValid in
                textHint.accept(isValid ? .none : .invalid)
            }).disposed(by: disposeBag)
        
        /// 수행 시간 설정
        let textPerformTime = BehaviorRelay<String>(value: "")
        
        input.textPerformTime
            .drive(onNext: { text in
                textPerformTime.accept(text ?? "")
                self.param.scheduleTime = text ?? ""
                self.modifyTime = text ?? ""
                Log.debug("modifyTime", "\(text ?? "")")
            }).disposed(by: disposeBag)
        
        /// 시작 날짜
        let textStartDate = BehaviorRelay<String>(value: "")
        input.textStartDate
            .drive(onNext: { text in
                textStartDate.accept(text ?? "")
            }).disposed(by: disposeBag)
        
        input.startDateParam
            .drive(onNext: { text in
                self.param.scheduleDate = text
                self.selectDateWeek.removeAll()
                let date = text?.toDate()
                let st = date?.toStringE()
                
                if text != "" {
                    self.selectDateWeek.append(st ?? "")
                }
            }).disposed(by: disposeBag)
        
        /// 이행 주기
        let selectCycleType = BehaviorRelay<CycleType>(value: .week)
        let cycleItems = BehaviorRelay<[String]>(value: [])
        let selectedCycleItems = BehaviorRelay<[String]>(value: [])
        

        /// 상세 페이지로 진입시 서버 데이터 세팅 ========================= START
        if todoModel?.goalCount == 0 || todoModel?.goalCount == nil {
            selectCycleType.accept(.week)
        } else {
            selectCycleType.accept(.number)
        }
        
        /// 상세 페이지로 진입시 서버 데이터 세팅 ========================= END
        input.btnCycleWeekTapped
            .drive(onNext: { _ in
                selectCycleType.accept(.week)
            }).disposed(by: disposeBag)
        
        input.btnCycleNumber
            .drive(onNext: { _ in
                selectCycleType.accept(.number)
            }).disposed(by: disposeBag)
        
        selectCycleType
            .distinctUntilChanged()
            .filter { $0 == .week }
            .flatMapLatest { _ -> Observable<[String]> in
                return self.cycleWeek.asObservable()
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
                selectedCycleItems.accept([])
                self.weekAndNumberType = 0
            }).disposed(by: disposeBag)
        
        selectCycleType
            .distinctUntilChanged()
            .filter { $0 == .number }
            .flatMapLatest { _ -> Observable<[String]> in
                return self.cycleNumber.asObservable()
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
                selectedCycleItems.accept([])
                self.weekAndNumberType = 1
            }).disposed(by: disposeBag)
        
        input.cycleModelSelected
            .drive(onNext: { item in
                var selectedItems = selectedCycleItems.value
                if !selectedItems.contains(obj: item) {
                    selectedItems.append(item)
                    let items: [String] = selectedItems
//                    Log.debug("selectedItems ", items)
                    let addItems: [String] = selectedItems + self.selectDateWeek
                    print("selectDateWeek : \(self.selectDateWeek)")
                    let removeDupleicateItems: [String] = TaviCommon.removeDuplicate(addItems)
                    Log.debug("test!", self.selectDateWeek)
                    Log.debug("selectedItems", removeDupleicateItems)
                    if removeDupleicateItems.isEmpty {
                        self.selectItemSet(items: self.selectDateWeek)
                    } else {
                        self.selectItemSet(items: items)
                    }
                    selectedCycleItems.accept(items)
                }
            }).disposed(by: disposeBag)
        
        input.cycleModelDeselected
            .drive(onNext: { item in
                let selectedItems = selectedCycleItems.value
                selectedCycleItems.accept(selectedItems.removed(item))
                Log.debug("selectedItems ", selectedCycleItems.value)
                self.selectItemSet(items: selectedCycleItems.value)
            }).disposed(by: disposeBag)
        
        /// 잔소리 알림 설정
        let isNaggingPush = BehaviorRelay<Bool>(value: false)
        let timeNaggingPush = BehaviorRelay<Date?>(value: nil)
        
        input.valueChangedPush
            .drive(onNext: { isOn in
                Log.debug("isOnTest", "\(isOn)")
                isNaggingPush.accept(isOn)
            }).disposed(by: disposeBag)
        
        isNaggingPush
            .subscribe(onNext: { isOn in
                if !isOn {
                    timeNaggingPush.accept(nil)
                    self.param.alarmTime = nil
                    self.modifyAlarm = nil
                }
            }).disposed(by: disposeBag)
        
        input.valueChangedTimePicker
            .drive(onNext: { date in
                timeNaggingPush.accept(date)
                self.param.alarmTime = "\(TaviCommon.alarmTimeDateToStringFormatHHMM(date: date)):00"
                self.modifyAlarm = "\(TaviCommon.alarmTimeDateToStringFormatHHMM(date: date)):00"
            }).disposed(by: disposeBag)
        
        var canBeDone: Observable<Bool>?
        
        if isRecommendHabitBool {
            canBeDone = Observable.combineLatest(textPerformTime.asObservable(), textStartDate.asObservable(), selectedCycleItems.asObservable(), isNaggingPush.asObservable(), timeNaggingPush.asObservable())
                .map({ textPerformTime, textStartDate, selectedCycleItems, isNaggingPush, timeNaggingPush -> Bool in
                    if !textPerformTime.isEmpty && !selectedCycleItems.isEmpty && !textStartDate.isEmpty {
                        if !isNaggingPush {
                            return true
                        } else {
                            if timeNaggingPush != nil {
                                return true
                            }
                        }
                    }
                    return false
                })
        } else {
            canBeDone = Observable.combineLatest(isValidName.asObservable(), textPerformTime.asObservable(), textStartDate.asObservable(), selectedCycleItems.asObservable(), isNaggingPush.asObservable(), timeNaggingPush.asObservable())
                .map({ isValidName, textPerformTime, textStartDate, selectedCycleItems, isNaggingPush, timeNaggingPush -> Bool in
                    if isValidName && !textPerformTime.isEmpty && !selectedCycleItems.isEmpty && !textStartDate.isEmpty {
                        if !isNaggingPush {
                            return true
                        } else {
                            if timeNaggingPush != nil {
                                return true
                            }
                        }
                    }
                    return false
                })
        }
        
        // TODO: Request 습관 추가 API
        let done = input.btnDoneTapped.asObservable().share()
//        이름,잔소리아이디,횟수카운트,수행시간,추가하는날짜,잔소리알림시간, (월~일 true false)
        
        // 추가
        let successDoneAddHabit = done
            .flatMapLatest { () -> Observable<Bool> in
                if self.isModify {
                    self.requestModifyRoutine(scheduleId: self.todoModel?.id ?? 0)
                } else {
                    self.requestRegistHabit()
                }
                return isNew.asObservable()
            }.filter { $0 == true }.mapToVoid().debug()

        // 수정
        let successDoneModifyHabit = done
            .flatMapLatest { () -> Observable<Bool> in
                return isNew.asObservable()
            }.filter { $0 == false }.mapToVoid().debug()
        
        successDoneModifyHabit
            .subscribe(onNext: {
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        return Output(showBottomSheet: input.btnMoreTapped,
                      hideBottomSheet: hideBottomSheet.asDriverOnErrorJustComplete(),
                      isWriting: isWriting.asDriverOnErrorJustComplete(),
                      showBackAlert: showBackAlert.asDriver(onErrorJustReturn: STR_HABIT_BACK),
                      goToBack: goToBack.asDriverOnErrorJustComplete(),
                      showDeleteAlert: showDeleteAlert.asDriver(onErrorJustReturn: STR_HABIT_BACK),
                      isEditingName: isEditingName.asDriverOnErrorJustComplete(),
                      textHint: textHint.asDriverOnErrorJustComplete(),
                      goToPerformTimeSetting: input.btnPerformTimeTapped,
                      selectCycleType: selectCycleType.asDriverOnErrorJustComplete(),
                      cycleItems: cycleItems,
                      isNaggingPush: isNaggingPush.asDriverOnErrorJustComplete(),
                      setTimeNaggingPush: timeNaggingPush.skip(1).distinctUntilChanged().asDriverOnErrorJustComplete(),
                      canBeDone: canBeDone!.asDriverOnErrorJustComplete(),
                      successDoneAddHabit: successDoneAddHabit.asDriverOnErrorJustComplete(),
                      successDoneModifyHabit: successDoneModifyHabit.asDriverOnErrorJustComplete(),
                      recommendedName: recommendedName.asDriverOnErrorJustComplete()
        )
    }
}

// MARK: - Service
extension DetailHabitViewModel {
    func requestRegistHabit() {
        if coachMarkStatusCheck != true {
            LoadingHUD.show()
        }
//        param.scheduleDate = self.dateParam ?? ""
        if self.recommendHabitName != nil {
            self.param.scheduleName = self.recommendHabitName
        }
        provider.request(.createTodo(param: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    Log.debug("createHabit json:", "\(json)")
                    self.homeViewModel.addHabitSuccessOb.onNext(())
                    LoadingHUD.hide()
                } catch let error {
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
    
    func requestRoutineInfo(scheduleId: Int) {
        if coachMarkStatusCheck != true {
            LoadingHUD.show()
        }
        provider.request(.todoDetailLookUp(scheduleId: scheduleId), completion: { res in
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
                    
                    self.routineInfoOb.onNext(model)
                    Log.debug("todoDetailLookUp json:", "\(json)")
                    if model.scheduleName == "" {
                        self.param.scheduleName = nil
                        self.isModify = false
                    } else {
                        self.param.scheduleName = model.scheduleName
                        self.isModify = true
                    }
                    
                    
                    self.recommendHabitNameOb.onNext(self.recommendHabitName ?? "")
                    LoadingHUD.hide()
                } catch let error {
                    Log.error("todoDetailLookUp error", "\(error)")
                    LoadingHUD.hide()
                }
            case .failure(let error):
                Log.error("todoDetailLookUp error", "\(error)")
                LoadingHUD.hide()
            }
        })
    }
    
    func requestModifyRoutine(scheduleId: Int) {
        if coachMarkStatusCheck != true {
            LoadingHUD.show()
        }
        var param: [ModifyTodoRequestModel] = []
        var model = ModifyTodoRequestModel()
        param.removeAll()
        if modifyName != nil {
            model.op = "replace"
            model.path = "/scheduleName"
            model.value = "\(modifyName!)"
//            model.value = "가나다라마자사아아아!!!"
            param.append(model)
        }
        if modifyTime != nil {
            model.op = "replace"
            model.path = "/scheduleTime"
            model.value = "\(modifyTime!)"
            param.append(model)
        }
        if modifyMon != nil {
            model.op = "replace"
            model.path = "/mon"
            model.value = "\(modifyMon!)"
            param.append(model)
        }
        if modifyTue != nil {
            model.op = "replace"
            model.path = "/tue"
            model.value = "\(modifyTue!)"
            param.append(model)
        }
        if modifyWed != nil {
            model.op = "replace"
            model.path = "/wed"
            model.value = "\(modifyWed!)"
            param.append(model)
        }
        if modifyThu != nil {
            model.op = "replace"
            model.path = "/thu"
            model.value = "\(modifyThu!)"
            param.append(model)
        }
        if modifyFri != nil {
            model.op = "replace"
            model.path = "/fri"
            model.value = "\(modifyFri!)"
            param.append(model)
        }
        if modifySat != nil {
            model.op = "replace"
            model.path = "/sat"
            model.value = "\(modifySat!)"
            param.append(model)
        }
        if modifySun != nil {
            model.op = "replace"
            model.path = "/sun"
            model.value = "\(modifySun!)"
            param.append(model)
        }
        if modifyNumber != nil {
            model.op = "replace"
            model.path = "/goalCount"
            model.value = "\(modifyNumber!)"
            param.append(model)
        }
        if modifyAlarm != nil {
            model.op = "replace"
            model.path = "/alarmTime"
            model.value = "\(modifyAlarm!)"
            param.append(model)
        }
        provider.request(.modifyTodo(scheduleId: scheduleId, modifyParam: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("modifyTodo json : \(json)")
                    self.modifySuccessOb.onNext(())
                    self.homeViewModel.isEndProgress.onNext(())
                    self.homeViewModel.addHabitSuccessOb.onNext(())
                    LoadingHUD.hide()
                } catch let error {
                    Log.error("modifyTodo error", "\(error)")
                    LoadingHUD.hide()
                }
            case .failure(let error):
                Log.error("modifyTodo failure error", "\(error)")
                LoadingHUD.hide()
            }
        })
    }
    
    func requestDeleteRoutine(scheduleId: Int) {
        if coachMarkStatusCheck != true {
            LoadingHUD.show()
        }
        provider.request(.deleteTodo(scheduleId: scheduleId), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("deleteTodo json : \(json)")
                    self.modifySuccessOb.onNext(())
                    self.homeViewModel.addHabitSuccessOb.onNext(())
                    LoadingHUD.hide()
                } catch let error {
                    Log.error("deleteTodo error", "\(error)")
                    self.modifySuccessOb.onNext(())
                    self.homeViewModel.addHabitSuccessOb.onNext(())
                    LoadingHUD.hide()
                }
            case .failure(let error):
                LoadingHUD.hide()
                Log.error("deleteTodo failure error", "\(error)")
            }
        })
    }
}
