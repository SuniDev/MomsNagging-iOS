//
//  DetailHabitViewNew.swift
//  momsnagging
//
//  Created by 전창평 on 2022/08/18.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources
import RxKeyboard

class DetailHabitViewNew: BaseViewController, Navigatable{
    
    /// variable & properties
    private var disposeBag = DisposeBag()
    var viewModel: DetailHabitViewModelNew?
    var navigator: Navigator!
    
    var modify: Bool = false
    
    var selectWeekList: [String] = []
    var selectCount: Int = 0
    
    var requestParam = CreateTodoRequestModel()
    var requestModifyParam = CreateTodoRequestModel()

    var alarmOn: Bool = false
    var weekAndCount: Bool = false // false = week
    var notSelectWeek = ""
    
    /// UI properties
    var scrollView = UIScrollView().then({
        $0.showsVerticalScrollIndicator = false
    })
    var backgroundFrame = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    var headFrame = UIView()
    var backBtn = UIButton()
    var doneBtn = UIButton().then({
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
        $0.isUserInteractionEnabled = false
    })
    
    var textCountLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.text = "0/30"
    })
    // 습관이름
    var habitNameFocusFrame = UIView()
    var habitNameXbtn = UIButton().then({
        $0.setImage(Asset.Icon.xCircleHabitName.image, for: .normal)
    })
    var habitNameTitle = UIView()
    var habitNameTF = UITextField().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.tag = 0
    })
    var habitNameBtn = UIButton()
    var habitNameInputFrame = UIView()
    // 수행시간
    var timeTitle = UIView()
    var timeTF = UITextField().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    var timeBtn = UIButton()
    var timeInputFrame = UIView()
    var timeTextFieldFrame = UIView()
    
    var modifyTimeView = UIView()
    var modifyTimeLbl = UILabel()
    var modifyTimeBtn = UIButton()
    // 시작날짜
    var startDateTitle = UIView()
    var startDateTF = UITextField().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    var startDateBtn = UIButton()
    var startDateInputFrame = UIView()
    var startDateTextFieldFrame = UIView()
    
    var modifyStartDateView = UIView()
    var modifyStartDateLbl = UILabel()
    var modifyStartDateBtn = UIButton()
    
    var datePickerView = UIDatePicker().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.cornerRadius = 6
        $0.isHidden = true
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
        $0.addTarget(self, action: #selector(selectDayAction), for: .valueChanged)
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    })
    var datePickerControlBar = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
        $0.isHidden = true
    })
    var datePickerSelectBtn = UIButton().then({
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
        $0.addTarget(self, action: #selector(selectDateAction), for: .touchUpInside)
    })
    
    // 이행주기
    var cycleTitle = UIView()
    var cycleBtnView = UIView()
    var weekBtn = UIButton()
    var emptyBtnWeek = UIButton()
    var countBtn = UIButton()
    var emptyBtnCount = UIButton()
    // 습관 요일
    var weekView = UIView()
    var mon = UIButton()
    var tue = UIButton()
    var wed = UIButton()
    var thu = UIButton()
    var fri = UIButton()
    var sat = UIButton()
    var sun = UIButton()
    // 습관 횟수
    var countView = UIView()
    var count1 = UIButton()
    var count2 = UIButton()
    var count3 = UIButton()
    var count4 = UIButton()
    var count5 = UIButton()
    var count6 = UIButton()
    
    //cycleDivider
    var cycleDivider = UIView().then({
        $0.backgroundColor = Asset.Color.monoLight010.color
    })

    // 잔소리 푸시 알림
    var pushAlarmTitle = UIView()
    lazy var switchPush = CommonSwitch()
    
    var addTimeView = UIView()
    
    var modifyAlarmView = UIView()
    var modifyAlarmLbl = UILabel()
    
    lazy var tfPicker = UITextField().then({
        $0.borderStyle = .none
        $0.textColor = .clear
        $0.backgroundColor = .clear
        $0.tintColor = .clear
        $0.tag = 10
    })
    lazy var modifyTfPicker = UITextField().then({
        $0.borderStyle = .none
        $0.textColor = .clear
        $0.backgroundColor = .clear
        $0.tintColor = .clear
        $0.tag = 11
    })
    lazy var timePicker = UIDatePicker().then({
        $0.minuteInterval = 5
        $0.locale = Locale(identifier: "ko_KR")
        $0.datePickerMode = .time
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    })
    var toolBarDoneBtn = UIBarButtonItem()
    var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)).then({
        $0.barStyle = .default
    })
    
    // MARK: - init
    init(viewModel: DetailHabitViewModelNew, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        self.modify = viewModel.modify
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        action()
        if modify {
            viewModel?.requestRoutineInfo()
            modifySetting()
        }
    }
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "습관 상세")
        habitNameTitle = detailHabitTitle(title: "습관 이름", required: true)
        habitNameInputFrame = inputFrame(placeHolderString: "어떤 습관 추가할래?", ic: false, textField: habitNameTF, btn: habitNameBtn, textFieldFrame: habitNameFocusFrame)
        
        if let recommendedTitle = viewModel?.recommendedTitle {
            self.habitNameTF.text = recommendedTitle
            self.requestParam.scheduleName = recommendedTitle
        }
        
        timeTitle = detailHabitTitle(title: "수행 시간", required: true)
        timeInputFrame = inputFrame(placeHolderString: "어떤 시간 혹은 상황에서 할래?", ic: true, textField: timeTF, btn: timeBtn, textFieldFrame: timeTextFieldFrame)
        modifyTimeView = TaviCommon.modifyBtnInputView(contentsLbl: modifyTimeLbl, btn: modifyTimeBtn)
        modifyTimeView.isHidden = true
        
        startDateTitle = detailHabitTitle(title: "시작 날짜", required: true)
        startDateInputFrame = inputFrame(placeHolderString: "언제부터 시작할래?", ic: true, textField: startDateTF, btn: startDateBtn, textFieldFrame: startDateTextFieldFrame)
        modifyStartDateView = TaviCommon.modifyBtnInputView(contentsLbl: modifyStartDateLbl, btn: modifyStartDateBtn)
        modifyStartDateView.isHidden = true
        
        cycleTitle = detailHabitTitle(title: "이행 주기", required: true)
        cycleBtnView = cycleBtnFrame(weekBtn: weekBtn, countBtn: countBtn, emptyBtnWeek: emptyBtnWeek, emptyBtnCount: emptyBtnCount)
        weekView = weekBtnFrame(mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat, sun: sun)
        countView = countBtnFrame(count1: count1, count2: count2, count3: count3, count4: count4, count5: count5, count6: count6)
        countView.isHidden = true
        
        pushAlarmTitle = detailHabitTitle(title: "잔소리 PUSH 알림", required: false)
        
        tfPicker.inputView = timePicker
        addTimeView = TaviCommon.addTimeView(tf: tfPicker)
        addTimeView.isHidden = true
        modifyTfPicker.inputView = timePicker
        modifyAlarmView = TaviCommon.modifyInputView(contentsLbl: modifyAlarmLbl, tf: modifyTfPicker)
        modifyAlarmView.isHidden = true
        requestParam.goalCount = 0
        
        timePickerSet()
        
        // delegate
        habitNameTF.delegate = self
        tfPicker.delegate = self
        modifyTfPicker.delegate = self
        
    }
    override func layoutSetting() {
        view.addSubview(headFrame)
        headFrame.addSubview(doneBtn)
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundFrame)
        backgroundFrame.addSubview(habitNameTitle)
        backgroundFrame.addSubview(habitNameInputFrame)
        backgroundFrame.addSubview(habitNameXbtn)
        backgroundFrame.addSubview(textCountLbl)
        backgroundFrame.addSubview(timeTitle)
        backgroundFrame.addSubview(timeInputFrame)
        backgroundFrame.addSubview(modifyTimeView)
        backgroundFrame.addSubview(startDateTitle)
        backgroundFrame.addSubview(startDateInputFrame)
        backgroundFrame.addSubview(modifyStartDateView)
        backgroundFrame.addSubview(cycleTitle)
        backgroundFrame.addSubview(cycleBtnView)
        backgroundFrame.addSubview(weekView)
        backgroundFrame.addSubview(countView)
        backgroundFrame.addSubview(cycleDivider)
        backgroundFrame.addSubview(pushAlarmTitle)
        backgroundFrame.addSubview(switchPush)
        backgroundFrame.addSubview(addTimeView)
        backgroundFrame.addSubview(modifyAlarmView)
        view.addSubview(datePickerView)
        view.addSubview(datePickerControlBar)
        datePickerControlBar.addSubview(datePickerSelectBtn)
        datePickerView.backgroundColor = .white
        
        
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        doneBtn.snp.makeConstraints({
            $0.centerY.equalTo(headFrame.snp.centerY)
            $0.trailing.equalTo(headFrame.snp.trailing).offset(-20)
            $0.width.equalTo(30)
        })
        scrollView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        backgroundFrame.snp.makeConstraints({
            $0.edges.equalTo(scrollView.snp.edges)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(676)
        })
        habitNameTitle.snp.makeConstraints({
            $0.top.equalTo(backgroundFrame.snp.top).offset(24)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.height.equalTo(24)
        })
        habitNameInputFrame.snp.makeConstraints({
            $0.top.equalTo(habitNameTitle.snp.bottom).offset(12)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-18)
            $0.height.equalTo(69)
        })
        habitNameXbtn.snp.makeConstraints({
            $0.top.equalTo(habitNameInputFrame.snp.top).offset(12)
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(habitNameInputFrame.snp.trailing).offset(-8)
        })
        textCountLbl.snp.makeConstraints({
            $0.centerY.equalTo(habitNameTitle.snp.centerY)
            $0.trailing.equalTo(habitNameInputFrame.snp.trailing)
            $0.height.equalTo(24)
        })
        
        timeTitle.snp.makeConstraints({
            $0.top.equalTo(habitNameInputFrame.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.height.equalTo(24)
        })
        timeInputFrame.snp.makeConstraints({
            $0.top.equalTo(timeTitle.snp.bottom).offset(12)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-18)
            $0.height.equalTo(69)
        })
        modifyTimeView.snp.makeConstraints({
            $0.top.equalTo(timeInputFrame.snp.top)
            $0.leading.equalTo(timeInputFrame.snp.leading)
            $0.trailing.equalTo(timeInputFrame.snp.trailing)
            $0.height.equalTo(48)
        })
        
        startDateTitle.snp.makeConstraints({
            $0.top.equalTo(timeInputFrame.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.height.equalTo(24)
        })
        startDateInputFrame.snp.makeConstraints({
            $0.top.equalTo(startDateTitle.snp.bottom).offset(12)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-18)
            $0.height.equalTo(69)
        })
        modifyStartDateView.snp.makeConstraints({
            $0.top.equalTo(startDateInputFrame.snp.top)
            $0.leading.equalTo(startDateInputFrame.snp.leading)
            $0.trailing.equalTo(startDateInputFrame.snp.trailing)
            $0.height.equalTo(48)
        })
        
        cycleTitle.snp.makeConstraints({
            $0.top.equalTo(startDateInputFrame.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.height.equalTo(24)
        })
        cycleBtnView.snp.makeConstraints({
            $0.top.equalTo(cycleTitle.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(22)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-22)
            $0.height.equalTo(42)
        })
        weekView.snp.makeConstraints({
            $0.top.equalTo(cycleBtnView.snp.bottom).offset(24)
            $0.leading.equalTo(backgroundFrame.snp.leading)
            $0.trailing.equalTo(backgroundFrame.snp.trailing)
            $0.height.equalTo(40)
        })
        countView.snp.makeConstraints({
            $0.top.equalTo(cycleBtnView.snp.bottom).offset(24)
            $0.leading.equalTo(backgroundFrame.snp.leading)
            $0.trailing.equalTo(backgroundFrame.snp.trailing)
            $0.height.equalTo(40)
        })
        cycleDivider.snp.makeConstraints({
            $0.top.equalTo(cycleBtnView.snp.bottom).offset(88)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
            $0.height.equalTo(1)
        })
        
        pushAlarmTitle.snp.makeConstraints({
            $0.top.equalTo(cycleDivider.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(18)
            $0.height.equalTo(24)
        })
        switchPush.snp.makeConstraints({
            $0.width.equalTo(60)
            $0.height.equalTo(36)
            $0.centerY.equalTo(pushAlarmTitle.snp.centerY)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-2)
        })
        addTimeView.snp.makeConstraints({
            $0.top.equalTo(pushAlarmTitle.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
            $0.height.equalTo(40)
        })
        modifyAlarmView.snp.makeConstraints({
            $0.top.equalTo(pushAlarmTitle.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
            $0.height.equalTo(40)
        })
        toolbarSet()
        datePickerSelectBtn.snp.makeConstraints({
            $0.centerY.equalTo(datePickerControlBar.snp.centerY)
            $0.trailing.equalTo(datePickerControlBar.snp.trailing).offset(-20)
            $0.height.equalTo(30)
        })
        datePickerControlBar.snp.makeConstraints({
            $0.bottom.equalTo(datePickerView.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(36)
        })
        datePickerView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-180)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    override func bind() {
        habitNameTF.rx.text.subscribe(onNext: { text in
            self.requestParam.scheduleName = text
            
            if text?.count ?? 0 > 30 {
                self.habitNameTF.text?.removeLast()
            } else {
                self.textCountLbl.text = "\(text?.count ?? 0)/30"
            }
            
            if text?.count != 0 {
                self.habitNameXbtn.isHidden = false
            } else {
                self.habitNameXbtn.isHidden = true
            }
            self.doneValidCheck()
        }).disposed(by: disposeBag)
        
        
        viewModel?.habitInfoOb.subscribe(onNext: { info in
            self.requestParam.scheduleName = info.scheduleName
            self.requestParam.naggingId = info.naggingId
            self.requestParam.goalCount = info.goalCount
            self.requestParam.scheduleTime = info.scheduleTime
            self.requestParam.scheduleDate = info.scheduleDate
            Log.debug("요일로 전환 확인", "\(TaviCommon.stringDateToE(stringData: info.scheduleDate ?? ""))")
            self.requestParam.alarmTime = info.alarmTime
            self.requestParam.mon = info.mon
            self.requestParam.tue = info.tue
            self.requestParam.wed = info.wed
            self.requestParam.thu = info.thu
            self.requestParam.fri = info.fri
            self.requestParam.sat = info.sat
            self.requestParam.sun = info.sun
            
            if info.mon ?? false {
                self.selectWeekListSet(item: "월")
            }
            if info.tue ?? false {
                self.selectWeekListSet(item: "화")
            }
            if info.wed ?? false {
                self.selectWeekListSet(item: "수")
            }
            if info.thu ?? false {
                self.selectWeekListSet(item: "목")
            }
            if info.fri ?? false {
                self.selectWeekListSet(item: "금")
            }
            if info.sat ?? false {
                self.selectWeekListSet(item: "토")
            }
            if info.sun ?? false {
                self.selectWeekListSet(item: "일")
            }
            
            self.habitNameTF.text = info.scheduleName ?? ""
            self.textCountLbl.text = "\(info.scheduleName?.count ?? 0)/30"
            self.modifyTimeLbl.text = info.scheduleTime ?? ""
            self.modifyTimeView.isHidden = false
            self.modifyStartDateLbl.text = TaviCommon.stringDateToyyyyMMdd_E(stringData: info.scheduleDate ?? "")
            self.modifyStartDateView.isHidden = false
            if info.goalCount != 0 {
                self.modifySetCycleBtn()
                self.requestParam.goalCount = info.goalCount
                self.selectCountSet(item: info.goalCount ?? 0)
            } else {
                self.notSelectSet(item: TaviCommon.stringDateToE(stringData: info.scheduleDate ?? ""))
            }
            self.notSelectWeek = TaviCommon.stringDateToE(stringData: info.scheduleDate ?? "")
            
            Log.debug("알람 시간", info.alarmTime)
            
            if info.alarmTime != "" {
                if let alarmTime = info.alarmTime {
                    self.switchPush.isOn = true
                    self.alarmOn = true
                    self.pushAlarmSet(isOn: true)
                    self.modifyAlarmView.isHidden = false
                    self.modifyAlarmLbl.text = TaviCommon.stringDateToHHMM_A(stringData: alarmTime)
                    
                    let dateForm = DateFormatter()
                    dateForm.dateFormat = "HH:mm:ss"
                    
                    let dateTime = dateForm.date(from: alarmTime)
                    if let unwrappedDate = dateTime {
                        self.timePicker.setDate(unwrappedDate, animated: true)
                    }
                }
            }
            
            self.requestModifyParam = self.requestParam
            
            self.doneValidCheck()
            LoadingHUD.hide()
        }).disposed(by: disposeBag)
        
        viewModel?.modifySuccessOb.subscribe(onNext: { _ in
            self.navigator.pop(sender: self)
        }).disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                if height == 0.0 {
                    if self.alarmOn {
                        self.backgroundFrame.snp.updateConstraints({
                            $0.height.equalTo(736)
                        })
                    } else {
                        self.backgroundFrame.snp.updateConstraints({
                            $0.height.equalTo(676)
                        })
                    }
                } else {
                    if self.alarmOn {
                        self.backgroundFrame.snp.updateConstraints({
                            $0.height.equalTo(736+height)
                        })
                    } else {
                        self.backgroundFrame.snp.updateConstraints({
                            $0.height.equalTo(676+height)
                        })
                    }
                }
            }).disposed(by: disposeBag)
        
    }
    
    func bindPerformTime(_ viewModel: PerformTimeSettingViewModel) {
        viewModel.perfromTime.skip(1)
            .subscribe(onNext: { text in
                self.timeTF.text = text
                self.requestParam.scheduleTime = text
                self.modifyTimeLbl.text = text
                self.modifyTimeView.isHidden = false
                self.doneValidCheck()
            }).disposed(by: disposeBag)
    }
    
    func action() {
        backBtn.rx.tap.bind {
            self.navigator.pop(sender: self)
        }.disposed(by: disposeBag)
        doneBtn.rx.tap.bind {
            if self.modify {
                Log.debug("완료버튼 누름", "수정페이지")
                self.viewModel?.requestModifyRoutine(requestParam: self.requestParam, requestModifyParam: self.requestModifyParam)
            } else {
                Log.debug("완료버튼 누름", "생성페이지")
                self.requestParam.naggingId = self.viewModel?.naggingId ?? 0
                self.viewModel?.requestRegistHabit(createTodoRequestModel: self.requestParam)
                self.navigator.pop(sender: self, toRoot: true)
            }
        }.disposed(by: disposeBag)
        
        // 습관 이름 삭제 버튼
        habitNameXbtn.rx.tap.bind {
            self.requestParam.scheduleName = ""
            self.habitNameTF.text = ""
            self.habitNameXbtn.isHidden = true
            self.doneValidCheck()
        }.disposed(by: disposeBag)
        
        // 수행 시간 버튼, 수정 버튼
        timeBtn.rx.tap.bind {
            self.habitNameFrameFocus(bool: false)
            let performTimeViewModel = PerformTimeSettingViewModel(performTime: self.modifyTimeLbl.text)
            self.bindPerformTime(performTimeViewModel)
            self.navigator.show(seque: .performTimeSetting(viewModel: performTimeViewModel), sender: self, transition: .navigation)
        }.disposed(by: disposeBag)
        modifyTimeBtn.rx.tap.bind {
            self.habitNameFrameFocus(bool: false)
            let performTimeViewModel = PerformTimeSettingViewModel(performTime: self.modifyTimeLbl.text)
            self.bindPerformTime(performTimeViewModel)
            self.navigator.show(seque: .performTimeSetting(viewModel: performTimeViewModel), sender: self, transition: .navigation)
        }.disposed(by: disposeBag)
        
        // 시작 날짜 버튼, 수정 버튼
        startDateBtn.rx.tap.bind {
            self.habitNameFrameFocus(bool: false)
            self.datePickerView.isHidden = false
            self.datePickerControlBar.isHidden = false
            if !self.modify && self.modifyStartDateView.isHidden {
                self.defaultStartDateSet()
            }
        }.disposed(by: disposeBag)
        modifyStartDateBtn.rx.tap.bind {
            self.habitNameFrameFocus(bool: false)
            self.datePickerView.isHidden = false
            self.datePickerControlBar.isHidden = false
            self.defaultStartDateSet()
        }.disposed(by: disposeBag)
        
        // 이행주기 버튼
        emptyBtnWeek.rx.tap.bind {
            print("요일")
            self.weekAndCount = false
            self.habitNameFrameFocus(bool: false)
            self.countBtn.isHidden = true
            self.weekBtn.isHidden = false
            self.weekView.isHidden = false
            self.countView.isHidden = true
            self.selectCount = 0
            self.resetCount()
            self.notSelectSet(item: self.notSelectWeek)
            self.doneValidCheck()
        }.disposed(by: disposeBag)
        emptyBtnCount.rx.tap.bind {
            print("몇번")
            self.weekAndCount = true
            self.habitNameFrameFocus(bool: false)
            self.countBtn.isHidden = false
            self.weekBtn.isHidden = true
            self.weekView.isHidden = true
            self.countView.isHidden = false
            self.selectWeekList.removeAll()
            self.resetWeek()
            self.doneValidCheck()
        }.disposed(by: disposeBag)
        
        // 요일 버튼
        mon.rx.tap.bind {
            self.selectWeekListSet(item: "월")
        }.disposed(by: disposeBag)
        tue.rx.tap.bind {
            self.selectWeekListSet(item: "화")
        }.disposed(by: disposeBag)
        wed.rx.tap.bind {
            self.selectWeekListSet(item: "수")
        }.disposed(by: disposeBag)
        thu.rx.tap.bind {
            self.selectWeekListSet(item: "목")
        }.disposed(by: disposeBag)
        fri.rx.tap.bind {
            self.selectWeekListSet(item: "금")
        }.disposed(by: disposeBag)
        sat.rx.tap.bind {
            self.selectWeekListSet(item: "토")
        }.disposed(by: disposeBag)
        sun.rx.tap.bind {
            self.selectWeekListSet(item: "일")
        }.disposed(by: disposeBag)
        // 횟수 버튼
        count1.rx.tap.bind {
            self.selectCountSet(item: 1)
        }.disposed(by: disposeBag)
        count2.rx.tap.bind {
            self.selectCountSet(item: 2)
        }.disposed(by: disposeBag)
        count3.rx.tap.bind {
            self.selectCountSet(item: 3)
        }.disposed(by: disposeBag)
        count4.rx.tap.bind {
            self.selectCountSet(item: 4)
        }.disposed(by: disposeBag)
        count5.rx.tap.bind {
            self.selectCountSet(item: 5)
        }.disposed(by: disposeBag)
        count6.rx.tap.bind {
            self.selectCountSet(item: 6)
        }.disposed(by: disposeBag)
             
        // 잔소리 알림
        self.switchPush.rx.tap().bind {
            if self.switchPush.isOn {
                Log.debug("꺼짐", "off")
                self.alarmOn = false
                self.requestParam.alarmTime = nil
                self.pushAlarmSet(isOn: false)
                self.doneValidCheck()
            } else {
                Log.debug("켜짐", "on")
                self.alarmOn = true
                self.pushAlarmSet(isOn: true)
                self.scrollView.scroll(to: .bottom)
                self.doneValidCheck()
            }
        }.disposed(by: disposeBag)
        
//        self.timePicker.rx.controlEvent(.allEvents).subscribe(<#T##observer: ObserverType##ObserverType#>)
        
        self.timePicker.rx.controlEvent(.valueChanged).subscribe(onNext: { _ in
            let date: Date = self.timePicker.date
            let st = "\(TaviCommon.alarmTimeDateToStringFormatHHMMa(date: date))"
            self.modifyAlarmView.isHidden = false
            self.modifyAlarmLbl.text = st
            self.addTimeView.isHidden = true
            self.requestParam.alarmTime = "\(TaviCommon.alarmTimeDateToStringFormatHHMM(date: date)):00"
//            Log.debug("timePicker", st)
            self.doneValidCheck()
        }).disposed(by: disposeBag)
        self.modifyTfPicker.rx.controlEvent(.valueChanged).subscribe(onNext: { _ in
            let date: Date = self.timePicker.date
            let st = "\(TaviCommon.alarmTimeDateToStringFormatHHMMa(date: date))"
            self.modifyAlarmView.isHidden = false
            self.modifyAlarmLbl.text = st
            self.addTimeView.isHidden = true
            self.requestParam.alarmTime = "\(TaviCommon.alarmTimeDateToStringFormatHHMM(date: date)):00"
            self.doneValidCheck()
        }).disposed(by: disposeBag)
    }
    
    func toolbarSet() {
        toolBarDoneBtn = UIBarButtonItem()
        toolBarDoneBtn.target = self
        toolBarDoneBtn.title = "완료"
        toolBarDoneBtn.action = #selector(toolBarDoneAction)
        let spaceFrmaeItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceFrmaeItem, toolBarDoneBtn], animated: true)
        tfPicker.inputAccessoryView = toolbar
        modifyTfPicker.inputAccessoryView = toolbar
    }

    /// Function
    @objc
    func toolBarDoneAction() {
        self.view.endEditing(true)
    }
    @objc
    func hideKeyboard() {
        self.view.endEditing(true)
        self.datePickerView.isHidden = true
        self.datePickerControlBar.isHidden = true
    }
    @objc
    func selectDayAction(_ sender: UIDatePicker) {
        Log.debug("weekAndCount", weekAndCount)
        self.selectWeekList.removeAll()
        if weekAndCount {
            resetWeek()
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        modifyStartDateLbl.text = formatter.string(from: sender.date)
        formatter.dateFormat = "yyyy-MM-dd"
        requestParam.scheduleDate = formatter.string(from: sender.date)
        formatter.dateFormat = "E"
        notSelectWeek = formatter.string(from: sender.date)
        notSelectSet(item: formatter.string(from: sender.date))
        doneValidCheck()
        modifyStartDateView.isHidden = false
    }
    @objc
    func selectDateAction() {
        self.view.endEditing(true)
        self.datePickerView.isHidden = true
        self.datePickerControlBar.isHidden = true
    }
    func defaultStartDateSet() {
        if weekAndCount {
            resetWeek()
        }
        Log.debug("defaultStartDateSet 1", modifyStartDateLbl)
        if modifyStartDateLbl.text != nil {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "yyyy.MM.dd (E)"
            let date = formatter.date(from: modifyStartDateLbl.text ?? "")
            Log.debug("defaultStartDateSet 1", modifyStartDateLbl)
            datePickerView.date = date!
            modifyStartDateLbl.text = formatter.string(from: date!)
            formatter.dateFormat = "yyyy-MM-dd"
            requestParam.scheduleDate = formatter.string(from: date!)
            formatter.dateFormat = "E"
            notSelectWeek = formatter.string(from: date!)
//            notSelectSet(item: formatter.string(from: date!))
            doneValidCheck()
            modifyStartDateView.isHidden = false
            
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko")
            formatter.dateFormat = "yyyy.MM.dd (E)"
            modifyStartDateLbl.text = formatter.string(from: Date())
            formatter.dateFormat = "yyyy-MM-dd"
            requestParam.scheduleDate = formatter.string(from: Date())
            formatter.dateFormat = "E"
            notSelectWeek = formatter.string(from: Date())
            notSelectSet(item: formatter.string(from: Date()))
            doneValidCheck()
            modifyStartDateView.isHidden = false
        }
    }
    
    func modifySetCycleBtn() {
        self.weekAndCount = true
        self.countBtn.isHidden = false
        self.weekBtn.isHidden = true
        self.weekView.isHidden = true
        self.countView.isHidden = false
        self.selectWeekList.removeAll()
        self.resetWeek()
    }
    
    func detailHabitTitle(title: String, required: Bool) -> UIView {
        let view = UIView()
        let lbl = UILabel().then({
            $0.text = title
            $0.textColor = Asset.Color.monoDark010.color
            $0.font = FontFamily.Pretendard.bold.font(size: 16)
        })
        let dot = UILabel().then({
            $0.text = "*"
            $0.textColor = Asset.Color.priMain.color
            $0.font = FontFamily.Pretendard.bold.font(size: 18)
        })
        view.addSubview(lbl)
        view.addSubview(dot)
        
        lbl.snp.makeConstraints({
            $0.centerY.equalTo(view.snp.centerY)
        })
        dot.snp.makeConstraints({
            $0.leading.equalTo(lbl.snp.trailing).offset(6)
            $0.centerY.equalTo(view.snp.centerY).offset(-2)
        })
        
        dot.isHidden = !required
        
        return view
    }
    func habitNameFrameFocus(bool: Bool) {
        if bool {
            print("habitNameFrameFocus: \(bool)")
            habitNameFocusFrame.layer.borderColor = Asset.Color.monoDark020.color.cgColor
        } else {
            self.view.endEditing(true)
            habitNameFocusFrame.layer.borderColor = Asset.Color.monoLight020.color.cgColor
        }
    }
    
    func inputFrame(placeHolderString: String, ic: Bool, textField: UITextField, btn: UIButton, textFieldFrame: UIView) -> UIView {
        let view = UIView()
        let attributes = [
            NSAttributedString.Key.foregroundColor: Asset.Color.monoDark030.color,
            NSAttributedString.Key.font: FontFamily.Pretendard.regular.font(size: 14)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes:attributes as [NSAttributedString.Key : Any])
        _ = textFieldFrame.then({
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(asset: Asset.Color.monoLight020)?.cgColor
        })
        let divider = UIView().then({
            $0.backgroundColor = Asset.Color.monoLight010.color
        })
        let arrowIc = UIImageView().then({
            $0.image = UIImage(asset: Asset.Icon.chevronRight)
        })
        view.addSubview(textFieldFrame)
        textFieldFrame.addSubview(textField)
        textFieldFrame.addSubview(arrowIc)
        textFieldFrame.addSubview(btn)
        view.addSubview(divider)
        
        textFieldFrame.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(48)
        })
        
        textField.snp.makeConstraints({
            $0.top.equalTo(textFieldFrame.snp.top)
            $0.leading.equalTo(textFieldFrame.snp.leading).offset(8)
            $0.trailing.equalTo(textFieldFrame.snp.trailing).offset(-8)
            $0.bottom.equalTo(textFieldFrame.snp.bottom)
        })
        arrowIc.snp.makeConstraints({
            $0.width.height.equalTo(18)
            $0.centerY.equalTo(textFieldFrame.snp.centerY)
            $0.trailing.equalTo(textFieldFrame.snp.trailing).offset(-8)
        })
        btn.snp.makeConstraints({
            $0.edges.equalTo(textFieldFrame.snp.edges)
        })
        
        divider.snp.makeConstraints({
            $0.height.equalTo(1)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
        
        arrowIc.isHidden = !ic
        btn.isHidden = !ic
        
        return view
    }
    
    func cycleBtnFrame(weekBtn: UIButton, countBtn: UIButton, emptyBtnWeek: UIButton, emptyBtnCount: UIButton) -> UIView {
        let view = UIView().then({
            $0.layer.borderColor = Asset.Color.monoLight020.color.cgColor
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 8
        })
        weekBtn.setTitle("어떤 요일?", for: .normal)
        weekBtn.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        weekBtn.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 14)
        weekBtn.layer.masksToBounds = true
        weekBtn.layer.cornerRadius = 5
        weekBtn.backgroundColor = Asset.Color.priLight010.color
        countBtn.setTitle("일주일에 몇 번 이상?", for: .normal)
        countBtn.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        countBtn.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 14)
        countBtn.layer.masksToBounds = true
        countBtn.layer.cornerRadius = 5
        countBtn.backgroundColor = Asset.Color.priLight010.color
        countBtn.isHidden = true
        
        let lbl1 = UILabel().then({
            $0.text = "어떤 요일?"
            $0.textColor = Asset.Color.monoDark030.color
            $0.font = FontFamily.Pretendard.regular.font(size: 14)
        })
        
        let lbl2 = UILabel().then({
            $0.text = "일주일에 몇 번 이상?"
            $0.textColor = Asset.Color.monoDark030.color
            $0.font = FontFamily.Pretendard.regular.font(size: 14)
        })
        
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        view.addSubview(weekBtn)
        view.addSubview(countBtn)
        view.addSubview(emptyBtnWeek)
        view.addSubview(emptyBtnCount)
        
        weekBtn.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(3)
            $0.leading.equalTo(view.snp.leading).offset(3)
            $0.trailing.equalTo(view.snp.centerX).offset(-1.5)
            $0.bottom.equalTo(view.snp.bottom).offset(-3)
        })
        emptyBtnWeek.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(3)
            $0.leading.equalTo(view.snp.leading).offset(3)
            $0.trailing.equalTo(view.snp.centerX).offset(-1.5)
            $0.bottom.equalTo(view.snp.bottom).offset(-3)
        })
        lbl1.snp.makeConstraints({
            $0.center.equalTo(weekBtn.snp.center)
        })
        countBtn.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(3)
            $0.leading.equalTo(view.snp.centerX).offset(1.5)
            $0.trailing.equalTo(view.snp.trailing).offset(-3)
            $0.bottom.equalTo(view.snp.bottom).offset(-3)
        })
        emptyBtnCount.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(3)
            $0.leading.equalTo(view.snp.centerX).offset(1.5)
            $0.trailing.equalTo(view.snp.trailing).offset(-3)
            $0.bottom.equalTo(view.snp.bottom).offset(-3)
        })
        lbl2.snp.makeConstraints({
            $0.center.equalTo(countBtn.snp.center)
        })
        
        return view
    }
    
    func weekBtnFrame(mon: UIButton, tue: UIButton, wed: UIButton, thu: UIButton, fri: UIButton, sat: UIButton, sun: UIButton) -> UIView {
        mon.setTitle("월", for: .normal)
        tue.setTitle("화", for: .normal)
        wed.setTitle("수", for: .normal)
        thu.setTitle("목", for: .normal)
        fri.setTitle("금", for: .normal)
        sat.setTitle("토", for: .normal)
        sun.setTitle("일", for: .normal)
        
        cycleBtnNormal(btn: mon, sunDay: false)
        cycleBtnNormal(btn: tue, sunDay: false)
        cycleBtnNormal(btn: wed, sunDay: false)
        cycleBtnNormal(btn: thu, sunDay: false)
        cycleBtnNormal(btn: fri, sunDay: false)
        cycleBtnNormal(btn: sat, sunDay: false)
        cycleBtnNormal(btn: sun, sunDay: true)
        
        let view = UIView()
        view.addSubview(mon)
        view.addSubview(tue)
        view.addSubview(wed)
        view.addSubview(thu)
        view.addSubview(fri)
        view.addSubview(sat)
        view.addSubview(sun)
        
        mon.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(tue.snp.leading).offset(-10.5)
            $0.centerY.equalTo(tue.snp.centerY)
        })
        tue.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(wed.snp.leading).offset(-10.5)
            $0.centerY.equalTo(wed.snp.centerY)
        })
        wed.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(thu.snp.leading).offset(-10.5)
            $0.centerY.equalTo(thu.snp.centerY)
        })
        thu.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.centerX.equalTo(view.snp.centerX)
        })
        fri.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.leading.equalTo(thu.snp.trailing).offset(10.5)
            $0.centerY.equalTo(thu.snp.centerY)
        })
        sat.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.leading.equalTo(fri.snp.trailing).offset(10.5)
            $0.centerY.equalTo(fri.snp.centerY)
        })
        sun.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.leading.equalTo(sat.snp.trailing).offset(10.5)
            $0.centerY.equalTo(sat.snp.centerY)
        })
        return view
    }

    func countBtnFrame(count1: UIButton, count2: UIButton, count3: UIButton, count4: UIButton, count5: UIButton, count6: UIButton) -> UIView {
        count1.setTitle("1", for: .normal)
        count2.setTitle("2", for: .normal)
        count3.setTitle("3", for: .normal)
        count4.setTitle("4", for: .normal)
        count5.setTitle("5", for: .normal)
        count6.setTitle("6", for: .normal)
        
        cycleBtnNormal(btn: count1, sunDay: false)
        cycleBtnNormal(btn: count2, sunDay: false)
        cycleBtnNormal(btn: count3, sunDay: false)
        cycleBtnNormal(btn: count4, sunDay: false)
        cycleBtnNormal(btn: count5, sunDay: false)
        cycleBtnNormal(btn: count6, sunDay: false)
        
        let view = UIView()
        
        view.addSubview(count1)
        view.addSubview(count2)
        view.addSubview(count3)
        view.addSubview(count4)
        view.addSubview(count5)
        view.addSubview(count6)
        
        count1.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(count2.snp.leading).offset(-14.2)
            $0.centerY.equalTo(count2.snp.centerY)
        })
        count2.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(count3.snp.leading).offset(-14.2)
            $0.centerY.equalTo(count3.snp.centerY)
        })
        count3.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.trailing.equalTo(view.snp.centerX).offset(-7.1)
        })
        count4.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.leading.equalTo(view.snp.centerX).offset(7.1)
        })
        count5.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.leading.equalTo(count4.snp.trailing).offset(14.2)
            $0.centerY.equalTo(count4.snp.centerY)
        })
        count6.snp.makeConstraints({
            $0.width.height.equalTo(40)
            $0.leading.equalTo(count5.snp.trailing).offset(14.2)
            $0.centerY.equalTo(count5.snp.centerY)
        })
        return view
    }
    
    func cycleBtnNormal(btn: UIButton, sunDay: Bool) {
        if sunDay {
            btn.setTitleColor(Asset.Color.error.color, for: .normal)
        } else {
            btn.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        }
        btn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 12)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Asset.Color.monoLight020.color.cgColor
        btn.layer.cornerRadius = 20
        btn.backgroundColor = Asset.Color.monoWhite.color
    }
    
    func cycleBtnSelect(btn: UIButton) {
        btn.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Asset.Color.priLight030.color.cgColor
        btn.layer.cornerRadius = 20
        btn.backgroundColor = Asset.Color.priLight030.color
    }
    
    func cycleBtnNotTouchable(btn: UIButton) {
        touchbleReset()
        btn.setTitleColor(Asset.Color.monoDark020.color, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Asset.Color.priLight018Dis.color.cgColor
        btn.layer.cornerRadius = 20
        btn.backgroundColor = Asset.Color.priLight018Dis.color
        btn.isUserInteractionEnabled = false
    }
    
    func notSelectSet(item: String) {
        if !weekAndCount {
            resetWeek()
            weekListSet()
            switch item {
            case "월":
                cycleBtnNotTouchable(btn: mon)
                requestParam.mon = true
            case "화":
                cycleBtnNotTouchable(btn: tue)
                requestParam.tue = true
            case "수":
                cycleBtnNotTouchable(btn: wed)
                requestParam.wed = true
            case "목":
                cycleBtnNotTouchable(btn: thu)
                requestParam.thu = true
            case "금":
                cycleBtnNotTouchable(btn: fri)
                requestParam.fri = true
            case "토":
                cycleBtnNotTouchable(btn: sat)
                requestParam.sat = true
            case "일":
                cycleBtnNotTouchable(btn: sun)
                requestParam.sun = true
            default:
                break
            }
        }
    }
    
    // <-selectWeekListSet
    func weekIncludeCheck(item: String) -> Bool {
        var bool : Bool = false
        for i in selectWeekList {
            if i == item {
                bool = true
            }
        }
        return bool
    }
    func weekRemoveItem(item: String) {
        var listIndex : Int = -1
        for (index, i) in selectWeekList.enumerated() {
            if i == item {
                listIndex = index
            }
        }
        if listIndex != -1 {
            selectWeekList.remove(at: listIndex)
        }
    }
    func selectWeekSet(item: String, select:Bool) {
        switch item {
        case "월":
            if select {
                cycleBtnSelect(btn: mon)
                requestParam.mon = true
            } else {
                cycleBtnNormal(btn: mon, sunDay: false)
                requestParam.mon = false
            }
        case "화":
            if select {
                cycleBtnSelect(btn: tue)
                requestParam.tue = true
            } else {
                cycleBtnNormal(btn: tue, sunDay: false)
                requestParam.tue = false
            }
        case "수":
            if select {
                cycleBtnSelect(btn: wed)
                requestParam.wed = true
            } else {
                cycleBtnNormal(btn: wed, sunDay: false)
                requestParam.wed = false
            }
        case "목":
            if select {
                cycleBtnSelect(btn: thu)
                requestParam.thu = true
            } else {
                cycleBtnNormal(btn: thu, sunDay: false)
                requestParam.thu = false
            }
        case "금":
            if select {
                cycleBtnSelect(btn: fri)
                requestParam.fri = true
            } else {
                cycleBtnNormal(btn: fri, sunDay: false)
                requestParam.fri = false
            }
        case "토":
            if select {
                cycleBtnSelect(btn: sat)
                requestParam.sat = true
            } else {
                cycleBtnNormal(btn: sat, sunDay: false)
                requestParam.sat = false
            }
        case "일":
            if select {
                cycleBtnSelect(btn: sun)
                requestParam.sun = true
            } else {
                cycleBtnNormal(btn: sun, sunDay: true)
                requestParam.sun = false
            }
        default:
            break
        }
    }
    
    // 요일 선택
    func selectWeekListSet(item: String) {
        self.habitNameFrameFocus(bool: false)
        if self.weekIncludeCheck(item: item) {
            self.weekRemoveItem(item: item)
            self.selectWeekSet(item: item, select: false)
        } else {
            self.selectWeekList.append(item)
            self.selectWeekSet(item: item, select: true)
        }
        Log.debug("selectWeekList", self.selectWeekList)
        doneValidCheck()
    }
    
    func selectCountSet(item: Int) {
        self.habitNameFrameFocus(bool: false)
        switch item {
        case 1:
            self.selectCount(item: item)
            self.cycleBtnSelect(btn: count1)
        case 2:
            self.selectCount(item: item)
            self.cycleBtnSelect(btn: count2)
        case 3:
            self.selectCount(item: item)
            self.cycleBtnSelect(btn: count3)
        case 4:
            self.selectCount(item: item)
            self.cycleBtnSelect(btn: count4)
        case 5:
            self.selectCount(item: item)
            self.cycleBtnSelect(btn: count5)
        case 6:
            self.selectCount(item: item)
            self.cycleBtnSelect(btn: count6)
        default:
            break
        }
    }
    // 횟수 선택
    func selectCount(item: Int) {
        resetCount()
        self.selectCount = item
        self.requestParam.goalCount = item
        doneValidCheck()
    }
    func resetCount() {
        cycleBtnNormal(btn: count1, sunDay: false)
        cycleBtnNormal(btn: count2, sunDay: false)
        cycleBtnNormal(btn: count3, sunDay: false)
        cycleBtnNormal(btn: count4, sunDay: false)
        cycleBtnNormal(btn: count5, sunDay: false)
        cycleBtnNormal(btn: count6, sunDay: false)
        requestParam.goalCount = 0
        doneValidCheck()
    }
    func touchbleReset() {
        mon.isUserInteractionEnabled = true
        tue.isUserInteractionEnabled = true
        wed.isUserInteractionEnabled = true
        thu.isUserInteractionEnabled = true
        fri.isUserInteractionEnabled = true
        sat.isUserInteractionEnabled = true
        sun.isUserInteractionEnabled = true
    }
    func resetWeek() {
        cycleBtnNormal(btn: mon, sunDay: false)
        cycleBtnNormal(btn: tue, sunDay: false)
        cycleBtnNormal(btn: wed, sunDay: false)
        cycleBtnNormal(btn: thu, sunDay: false)
        cycleBtnNormal(btn: fri, sunDay: false)
        cycleBtnNormal(btn: sat, sunDay: false)
        cycleBtnNormal(btn: sun, sunDay: true)
        requestParam.mon = false
        requestParam.tue = false
        requestParam.wed = false
        requestParam.thu = false
        requestParam.fri = false
        requestParam.sat = false
        requestParam.sun = false
        doneValidCheck()
    }
    
    // 잔소리 알림 선택시 레이아웃 셋
    func pushAlarmSet(isOn: Bool) {
        addTimeView.isHidden = !isOn
//        modifyTimeView.isHidden = !isOn
        if isOn {
            addTimeView.fadeIn()
            backgroundFrame.snp.updateConstraints({
                $0.height.equalTo(736)
            })
        } else {
            modifyAlarmView.isHidden = true
            addTimeView.fadeOut()
            backgroundFrame.snp.updateConstraints({
                $0.height.equalTo(676)
            })
        }
    }
    
    // 요일 리스트 세팅
    func weekListSet() {
        for i in selectWeekList {
            switch i {
            case "월":
                cycleBtnSelect(btn: mon)
                requestParam.mon = true
            case "화":
                cycleBtnSelect(btn: tue)
                requestParam.tue = true
            case "수":
                cycleBtnSelect(btn: wed)
                requestParam.wed = true
            case "목":
                cycleBtnSelect(btn: thu)
                requestParam.thu = true
            case "금":
                cycleBtnSelect(btn: fri)
                requestParam.fri = true
            case "토":
                cycleBtnSelect(btn: sat)
                requestParam.sat = true
            case "일":
                cycleBtnSelect(btn: sun)
                requestParam.sun = true
            default:
                break
            }
        }
    }
    
    // 완료 체크
    func doneValidCheck() {
        print("""
        requestParamTest
        requestParam.scheduleName : \(requestParam.scheduleName),
        requestParam.scheduleTime : \(requestParam.scheduleTime),
        requestParam.scheduleDate : \(requestParam.scheduleDate),
        requestParamCount : \(requestParam.goalCount),
        requestParamWeekMon: \(requestParam.mon),
        requestParamWeekTue: \(requestParam.tue),
        requestParamWeekWed: \(requestParam.wed),
        requestParamWeekThu: \(requestParam.thu),
        requestParamWeekFri: \(requestParam.fri),
        requestParamWeekSat: \(requestParam.sat),
        requestParamWeekSun: \(requestParam.sun),
        requestParamAlarm : \(requestParam.alarmTime)
        """)
        if alarmOn {
            Log.debug("알람 on!", "")
            if weekAndCount { // 몇회
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != "" && requestParam.goalCount != 0 && requestParam.alarmTime != nil {
                    print("알람 있고 카운트 선택 완료 Done")
                    doneBtn.isUserInteractionEnabled = true
                    doneBtn.setTitleColor(Asset.Color.priMain.color, for: .normal)
                } else {
                    doneBtn.isUserInteractionEnabled = false
                    doneBtn.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
                }
            } else { // 요일
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != "" && (requestParam.mon ?? false || requestParam.tue ?? false || requestParam.wed ?? false || requestParam.thu ?? false || requestParam.fri ?? false || requestParam.sat ?? false || requestParam.sun ?? false) && requestParam.alarmTime != nil {
                    print("알람 있고 요일 선택 완료 Done")
                    doneBtn.isUserInteractionEnabled = true
                    doneBtn.setTitleColor(Asset.Color.priMain.color, for: .normal)
                } else {
                    doneBtn.isUserInteractionEnabled = false
                    doneBtn.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
                }
            }
        } else {
            Log.debug("알람 off!", "")
            if weekAndCount { // 몇회
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != "" && requestParam.goalCount != 0 {
                    print("알람 없이 횟수 선택 완료 Done")
                    doneBtn.isUserInteractionEnabled = true
                    doneBtn.setTitleColor(Asset.Color.priMain.color, for: .normal)
                } else {
                    doneBtn.isUserInteractionEnabled = false
                    doneBtn.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
                }
            } else { // 요일
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != "" && (requestParam.mon ?? false || requestParam.tue ?? false || requestParam.wed ?? false || requestParam.thu ?? false || requestParam.fri ?? false || requestParam.sat ?? false || requestParam.sun ?? false){
                    print("알람 없이 요일 선택 완료 Done")
                    doneBtn.isUserInteractionEnabled = true
                    doneBtn.setTitleColor(Asset.Color.priMain.color, for: .normal)
                } else {
                    doneBtn.isUserInteractionEnabled = false
                    doneBtn.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
                }
            }
        }
    }
    
    func modifySetting() {
        
    }
    
    func timePickerSet() {
        if modifyTimeLbl.text == nil {
            let date = Date(timeInterval: 300, since: Date())
            Log.debug("dateTest : ", date)
            timePicker.date = date
        }
    }
    func defaultSetAlarmTimeSet() {
        let date: Date = self.timePicker.date
        let st = "\(TaviCommon.alarmTimeDateToStringFormatHHMMa(date: date))"
        self.modifyAlarmLbl.text = st
        self.modifyAlarmView.isHidden = false
        self.requestParam.alarmTime = "\(TaviCommon.alarmTimeDateToStringFormatHHMM(date: date)):00"
        self.doneValidCheck()
    }
  
}


extension DetailHabitViewNew: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.habitNameFrameFocus(bool: true)
        } else if textField.tag == 10 {
            scrollView.scroll(to: .bottom)
            defaultSetAlarmTimeSet()
        } else if textField.tag == 11 {
            scrollView.scroll(to: .bottom)
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.habitNameFrameFocus(bool: false)
        } else if textField.tag == 10 {
            
        } else if textField.tag == 11 {
            
        }
        return true
    }
}
