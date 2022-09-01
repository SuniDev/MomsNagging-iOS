//
//  TodoViewNew.swift
//  momsnagging
//
//  Created by 전창평 on 2022/08/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources

class TodoViewNew: BaseViewController, Navigatable{
    
    /// variable & properties
    private var disposeBag = DisposeBag()
    var viewModel: TodoViewModelNew?
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
    // 할일이름
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
    })
    lazy var modifyTfPicker = UITextField().then({
        $0.borderStyle = .none
        $0.textColor = .clear
        $0.backgroundColor = .clear
        $0.tintColor = .clear
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
    init(viewModel: TodoViewModelNew, navigator: Navigator) {
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
//            viewModel?.requestRoutineInfo()
            viewModel?.requestTodoInfo()
            modifySetting()
        }
    }
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "할일 상세")
        habitNameTitle = detailHabitTitle(title: "할일 이름", required: true)
        habitNameInputFrame = inputFrame(placeHolderString: "어떤 할일 추가할래?", ic: false, textField: habitNameTF, btn: habitNameBtn, textFieldFrame: habitNameFocusFrame)
        
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
        
        pushAlarmTitle = detailHabitTitle(title: "잔소리 알림", required: false)
        tfPicker.inputView = timePicker
        addTimeView = TaviCommon.addTimeView(tf: tfPicker)
        addTimeView.isHidden = true
        modifyTfPicker.inputView = timePicker
        modifyAlarmView = TaviCommon.modifyInputView(contentsLbl: modifyAlarmLbl, tf: modifyTfPicker)
        modifyAlarmView.isHidden = true
        requestParam.goalCount = 0
        // delegate
        habitNameTF.delegate = self
        
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
            $0.height.equalTo(UIScreen.main.bounds.height - 60)
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
        
        pushAlarmTitle.snp.makeConstraints({
            $0.top.equalTo(modifyStartDateView.snp.bottom).offset(40)
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
            
            self.habitNameTF.text = info.scheduleName ?? ""
            self.textCountLbl.text = "\(info.scheduleName?.count ?? 0)/30"
            self.modifyTimeLbl.text = info.scheduleTime ?? ""
            self.modifyTimeView.isHidden = false
            self.modifyStartDateLbl.text = TaviCommon.stringDateToyyyyMMdd_E(stringData: info.scheduleDate ?? "")
            self.modifyStartDateView.isHidden = false
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
        
    }
    
    func bindPerformTime(_ viewModel: PerformTimeSettingViewModel) {
        viewModel.perfromTime.skip(1)
            .subscribe(onNext: { text in
//                self.timeTF.text = text
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
            Log.debug("완료버튼 누름", "완료!!")
            if self.modify {
                Log.debug("완료버튼 누름", "수정페이지")
                self.viewModel?.requestModifyTodo(requestParam: self.requestParam, requestModifyParam: self.requestModifyParam)
            } else {
                Log.debug("완료버튼 누름", "생성페이지")
                self.viewModel?.requestRegistTodo(createTodoRequestModel: self.requestParam)
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
            let performTimeViewModel = PerformTimeSettingViewModel(performTime: self.timeTF.text)
            self.bindPerformTime(performTimeViewModel)
            self.navigator.show(seque: .performTimeSetting(viewModel: performTimeViewModel), sender: self, transition: .navigation)
        }.disposed(by: disposeBag)
        modifyTimeBtn.rx.tap.bind {
            self.habitNameFrameFocus(bool: false)
            let performTimeViewModel = PerformTimeSettingViewModel(performTime: self.timeTF.text)
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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        modifyStartDateLbl.text = formatter.string(from: sender.date)
        formatter.dateFormat = "yyyy-MM-dd"
        requestParam.scheduleDate = formatter.string(from: sender.date)
        formatter.dateFormat = "E"
        notSelectWeek = formatter.string(from: sender.date)
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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy.MM.dd (E)"
//        tfStartDate.text = formatter.string(from: sender.date)
        modifyStartDateLbl.text = formatter.string(from: Date())
        formatter.dateFormat = "yyyy-MM-dd"
//        tfStartDateParam.text = formatter.string(from: sender.date)
        requestParam.scheduleDate = formatter.string(from: Date())
        formatter.dateFormat = "E"
//        startDateWeek = formatter.string(from: sender.date)
        doneValidCheck()
        modifyStartDateView.isHidden = false
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
    
    // 잔소리 알림 선택시 레이아웃 셋
    func pushAlarmSet(isOn: Bool) {
        addTimeView.isHidden = !isOn
//        modifyTimeView.isHidden = !isOn
        if isOn {
            addTimeView.fadeIn()
            backgroundFrame.snp.updateConstraints({
                $0.height.equalTo(UIScreen.main.bounds.height - 60)
            })
        } else {
            modifyAlarmView.isHidden = true
            addTimeView.fadeOut()
            backgroundFrame.snp.updateConstraints({
                $0.height.equalTo(UIScreen.main.bounds.height - 60)
            })
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
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != nil && requestParam.alarmTime != nil {
                    print("알람 있고 카운트 선택 완료 Done")
                    doneBtn.isUserInteractionEnabled = true
                    doneBtn.setTitleColor(Asset.Color.priMain.color, for: .normal)
                } else {
                    doneBtn.isUserInteractionEnabled = false
                    doneBtn.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
                }
            } else { // 요일
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != nil && requestParam.alarmTime != nil {
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
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != nil {
                    print("알람 없이 횟수 선택 완료 Done")
                    doneBtn.isUserInteractionEnabled = true
                    doneBtn.setTitleColor(Asset.Color.priMain.color, for: .normal)
                } else {
                    doneBtn.isUserInteractionEnabled = false
                    doneBtn.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
                }
            } else { // 요일
                if requestParam.scheduleName != "" && !modifyTimeView.isHidden && requestParam.scheduleDate != nil {
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
  
}


extension TodoViewNew: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.habitNameFrameFocus(bool: true)
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.habitNameFrameFocus(bool: false)
        }
        return true
    }
}
