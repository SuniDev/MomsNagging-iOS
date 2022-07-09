//
//  DetailTodoView.swift
//  momsnagging
//
//  Created by suni on 2022/05/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa
import RxGesture

class DetailTodoView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: DetailTodoViewModel?
    var navigator: Navigator!
    
    private let viewAddPushTimeHeight: CGFloat = 40.0
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    lazy var btnDone = UIButton()
    lazy var btnMore = UIButton().then({
        $0.isHidden = true
        $0.setImage(Asset.Icon.more.image, for: .normal)
    })
    lazy var lblTitle = UILabel().then({
        $0.text = "할일 상세"
    })
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    lazy var bottomSheet = CommonBottomSheet()
    
    /// 할일 이름
    lazy var detailNameFrame = UIView()
    lazy var viewNameTitle = UIView()
    lazy var viewHintTextField = UIView()
    lazy var tfName = CommonTextField().then({
        $0.placeholder = "어떤 할일 추가할래?"
        $0.returnKeyType = .done
    })
    lazy var lblHint = CommonHintLabel()
    
    var textCountLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.text = "0/30"
    })
    
    /// 수행 시간
    lazy var detailPerformTimeFrame = UIView()
    lazy var btnPerformTime = UIButton()
    lazy var viewTimeTitle = UIView()
    lazy var tfPerformTime = CommonTextField().then({
        $0.isEnabled = false
        $0.normalBorderColor = .clear
        $0.textColor = Asset.Color.monoDark010.color
        $0.placeholder = "아직 정해지지 않았단다"
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.addLeftPadding(width: 2)
    })
    
    /// 잔소리 알림
    lazy var detailNaggingPushFrame = UIView()
    lazy var viewDefaultNaggingPush = UIView()
    lazy var viewTimeNaggingPush = UIView()
    lazy var lblTime = UILabel()
    
    lazy var lblPushTitle = UILabel().then({
        $0.text = "잔소리 알림"
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = Asset.Color.monoDark010.color
    })
    lazy var switchPush = CommonSwitch()
    lazy var viewAddPushTime = UIView()
    lazy var tfPicker = UITextField().then({
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
    /// Common 수정을 하지 않고 진행하기 위해 임의로 수정버튼 숨김을 위한 emptyView
    lazy var hideModifyEmptyView = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
        $0.isHidden = true
    })
    
    var toolBarDoneBtn = UIBarButtonItem()
    var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)).then({
        $0.barStyle = .default
    })
    
    // MARK: - init
    init(viewModel: DetailTodoViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// ScrollView TapGesture로 키보드 내리기.
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
        viewHeader = CommonView.detailHeadFrame(btnBack: btnBack, lblTitle: lblTitle, btnDone: btnDone)
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: true)
        
        /// 잔소리 알림
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfName, lblHint: lblHint)
        if viewModel?.modifyPage ?? false {
            viewNameTitle = CommonView.requiredTitleFrame("할일 이름", true)
        } else {
            viewNameTitle = CommonView.requiredTitleFrame("할일 이름", false)
        }
        detailNameFrame = CommonView.detailNameFrame(viewNameTitle: viewNameTitle, viewHintTextField: viewHintTextField)
        
        /// 수행 시간
        if viewModel?.modifyPage ?? false {
            viewTimeTitle = CommonView.requiredTitleFrame("수행 시간", true)
        } else {
            viewTimeTitle = CommonView.requiredTitleFrame("수행 시간", false)
        }
        detailPerformTimeFrame = CommonView.detailPerformTimeFrame(viewTimeTitle: viewTimeTitle, tfTime: tfPerformTime)
        
        /// 잔소리 알림
        tfPicker.inputView = timePicker
        viewAddPushTime = CommonView.detailAddPushTimeFrame(tfPicker: tfPicker, defaultView: viewDefaultNaggingPush, timeView: viewTimeNaggingPush, lblTime: lblTime)
        viewAddPushTime.isHidden = true
        detailNaggingPushFrame = CommonView.detailNaggingPushFrame(lblTitle: lblPushTitle, switchPush: switchPush, viewAddPushTime: viewAddPushTime)
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        viewHeader.addSubview(btnMore)
        
        view.addSubview(scrollView)
        
        viewContents.addSubview(detailNameFrame)
        viewContents.addSubview(textCountLbl)
        viewContents.addSubview(detailPerformTimeFrame)
        viewContents.addSubview(btnPerformTime)
        viewContents.addSubview(detailNaggingPushFrame)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        btnMore.snp.makeConstraints({
            $0.height.width.equalTo(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        /// 할일 이름
        detailNameFrame.snp.makeConstraints({
            $0.height.equalTo(134)
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        textCountLbl.snp.makeConstraints({
            $0.top.equalTo(tfName.snp.bottom).offset(8)
            $0.trailing.equalTo(tfName.snp.trailing)
            $0.height.equalTo(20)
        })
        
        /// 수행 시간
        detailPerformTimeFrame.snp.makeConstraints({
            $0.height.equalTo(101)
            $0.top.equalTo(detailNameFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        btnPerformTime.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(detailPerformTimeFrame)
        })
        
        /// 잔소리 알림
        detailNaggingPushFrame.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(detailPerformTimeFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-20)
        })
        
        view.addSubview(hideModifyEmptyView)
        hideModifyEmptyView.snp.makeConstraints({
            $0.top.equalTo(viewAddPushTime.snp.top)
            $0.trailing.equalTo(viewAddPushTime.snp.trailing).offset(-7)
            $0.bottom.equalTo(viewAddPushTime.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
        })
        
        toolbarSet()
        
        view.layoutIfNeeded()
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let backAlertDoneHandler = PublishRelay<Void>()
        let deleteAlertDoneHandler = PublishRelay<Void>()
        
        let input = DetailTodoViewModel.Input(
            btnMoreTapped: self.btnMore.rx.tap.asDriverOnErrorJustComplete(),
            dimViewTapped: self.bottomSheet.dimView.rx.tapGesture().when(.recognized).mapToVoid().asDriverOnErrorJustComplete(),
            btnModifyTapped: self.bottomSheet.btnModify.rx.tap.asDriverOnErrorJustComplete(),
            btnDeleteTapped: self.bottomSheet.btnDelete.rx.tap.asDriverOnErrorJustComplete(),
            btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
            backAlertDoneHandler: backAlertDoneHandler.asDriverOnErrorJustComplete(),
            deleteAlertDoneHandler: deleteAlertDoneHandler.asDriverOnErrorJustComplete(),
            textName: self.tfName.rx.text.orEmpty.distinctUntilChanged().asDriverOnErrorJustComplete(),
            editingDidBeginName: self.tfName.rx.controlEvent(.editingDidBegin).asDriverOnErrorJustComplete(),
            editingDidEndName: self.tfName.rx.controlEvent(.editingDidEnd).asDriverOnErrorJustComplete(),
            btnPerformTimeTapped: self.btnPerformTime.rx.tap.asDriverOnErrorJustComplete(),
            textPerformTime: self.tfPerformTime.rx.observe(String.self, "text").asDriver(onErrorJustReturn: ""),
            valueChangedPush: self.switchPush.rx.controlEvent(.valueChanged).withLatestFrom(self.switchPush.rx.value).asDriverOnErrorJustComplete(),
            valueChangedTimePicker: self.timePicker.rx.controlEvent(.valueChanged).withLatestFrom(self.timePicker.rx.value).asDriverOnErrorJustComplete(),
            btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.showBottomSheet
            .drive(onNext: {
                self.bottomSheet.showAnim(vc: self, parentAddView: self.view)
            }).disposed(by: disposeBag)
        
        output.hideBottomSheet
            .drive(onNext: {
                self.bottomSheet.hideAnim()
            }).disposed(by: disposeBag)
        
        output.isWriting
            .drive(onNext: { isWriting in
                self.setTextColor(isWriting: isWriting)
                // 헤더 변경
                self.btnMore.isHidden = isWriting
                self.btnDone.isHidden = !isWriting
                
                // 컨텐츠 변경
                self.tfName.isEnabled = isWriting
                self.btnPerformTime.isEnabled = isWriting
                self.tfPicker.isEnabled = isWriting
                self.switchPush.isEnable = isWriting
                
                // 수정 버튼 숨김
                if isWriting {
                    self.hideModifyEmptyView.isHidden = true
                } else {
                    self.hideModifyEmptyView.isHidden = false
                }
            }).disposed(by: disposeBag)
        
        output.showBackAlert
            .drive(onNext: { message in
                CommonView.showAlert(vc: self, type: .twoBtn, title: "", message: message, doneHandler: {
                    backAlertDoneHandler.accept(())
                })
            }).disposed(by: disposeBag)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
        
        /// 삭제 하기
        output.showDeleteAlert
            .drive(onNext: { message in
                CommonView.showAlert(vc: self, title: "", message: message, cancelTitle: STR_NO, destructiveTitle: STR_DELETE, destructiveHandler: {
                    deleteAlertDoneHandler.accept(())
                })
            }).disposed(by: disposeBag)
        
        /// 할일 이름
        output.isEditingName
            .drive(onNext: { isEditing in
                if isEditing {
                    self.tfName.edit()
                } else {
                    self.tfName.normal()
                }
            }).disposed(by: disposeBag)
        
        output.textHint
            .drive(onNext: { type in
                switch type {
                case .none:
                    self.lblHint.normal()
                case .invalid, .empty:
                    self.lblHint.error(type.rawValue)
                    self.lblHint.text = type.rawValue
                    self.tfName.error()
                    self.tfName.placeholder = ""
                }
            }).disposed(by: disposeBag)
        
        output.isNaggingPush
            .drive(onNext: { isNaggingPush in
                if isNaggingPush {
                    self.viewAddPushTime.fadeIn()
                } else {
                    self.viewAddPushTime.fadeOut()
                }
                let height = isNaggingPush ? self.viewAddPushTimeHeight : 0
                
                self.viewAddPushTime.snp.updateConstraints({
                    $0.height.equalTo(height)
                })
                self.detailNaggingPushFrame.snp.updateConstraints({
                    $0.height.equalTo(65 + height)
                })
                
                UIView.animate(withDuration: 0.15) {
                    self.view.layoutIfNeeded()
                }
                
            }).disposed(by: disposeBag)
        
        output.goToPerformTimeSetting
            .drive(onNext: {
                let performTimeViewModel = PerformTimeSettingViewModel(performTime: self.tfPerformTime.text)
                self.bindPerformTime(performTimeViewModel)
                self.navigator.show(seque: .performTimeSetting(viewModel: performTimeViewModel), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { height in
                let margin = height + 10
                self.scrollView.snp.updateConstraints({
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-margin)
                })
            }).disposed(by: disposeBag)
        
        output.setTimeNaggingPush
            .drive(onNext: { date in
                if let date = date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .short
                    dateFormatter.dateFormat = "hh:mm a"
                    self.lblTime.text = dateFormatter.string(from: date)

                    if !self.viewDefaultNaggingPush.isHidden {
                        self.viewDefaultNaggingPush.fadeOut()
                        self.viewTimeNaggingPush.fadeIn()
                    }
                } else {
                    self.viewDefaultNaggingPush.fadeIn()
                    self.viewTimeNaggingPush.fadeOut()
                }
            }).disposed(by: disposeBag)
        
        output.canBeDone
            .drive(onNext: { isEnabled in
                self.btnDone.isEnabled = isEnabled
            }).disposed(by: disposeBag)
        
        output.successDoneAddTodo
            .drive(onNext: {
                self.navigator.pop(sender: self, toRoot: true)
            }).disposed(by: disposeBag)
        
        viewModel.todoInfoOb.subscribe(onNext: { data in
            self.tfName.text = data.scheduleName
            self.tfPerformTime.text = data.scheduleTime
            if data.alarmTime != nil {
                self.switchPush.isOn = true
                self.viewAddPushTime.fadeIn()
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = "hh:mm a"
                self.viewTimeNaggingPush.fadeIn()

            } else {
                self.switchPush.isOn = false
                self.viewAddPushTime.fadeOut()
            }
            
            let height = data.alarmTime != nil ? self.viewAddPushTimeHeight : 0
            self.viewAddPushTime.snp.updateConstraints({
                $0.height.equalTo(height)
            })
            self.detailNaggingPushFrame.snp.updateConstraints({
                $0.height.equalTo(65 + height)
            })
            
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
            }
            
            self.lblTime.text = TaviCommon.alarmTimeStringToDateToString(stringData: data.alarmTime ?? "")
        }).disposed(by: disposeBag)
        
        tfName.rx.text.subscribe(onNext: { text in
            if text?.count ?? 0 > 30 {
                self.tfName.text?.removeLast()
            } else {
                self.textCountLbl.text = "\(text?.count ?? 0)/30"
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - performTimeViewModel bind
    func bindPerformTime(_ viewModel: PerformTimeSettingViewModel) {
        
        viewModel.perfromTime.skip(1)
            .subscribe(onNext: { text in
                self.tfPerformTime.text = text
            }).disposed(by: disposeBag)
    }
    
    func setTextColor(isWriting: Bool) {
        if isWriting {
            tfName.textColor = UIColor(asset: Asset.Color.black)
            tfPerformTime.textColor = UIColor(asset: Asset.Color.black)
            tfPicker.textColor = UIColor(asset: Asset.Color.black)
            
            lblTime.textColor = UIColor(asset: Asset.Color.black)
            lblPushTitle.textColor = UIColor(asset: Asset.Color.black)
            
        } else {
            tfName.textColor = UIColor(asset: Asset.Color.monoDark020)
            tfPerformTime.textColor = UIColor(asset: Asset.Color.monoDark020)
            tfPicker.textColor = UIColor(asset: Asset.Color.monoDark020)
            lblTime.textColor = UIColor(asset: Asset.Color.monoDark020)
            lblPushTitle.textColor = UIColor(asset: Asset.Color.monoDark020)
        }
    }
    
    func toolbarSet() {
        toolBarDoneBtn = UIBarButtonItem()
        toolBarDoneBtn.target = self
        toolBarDoneBtn.title = "완료"
        toolBarDoneBtn.action = #selector(toolBarDoneAction)
        let spaceFrmaeItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceFrmaeItem, toolBarDoneBtn], animated: true)
        tfPicker.inputAccessoryView = toolbar
    }
    
    @objc
    func toolBarDoneAction() {
        self.view.endEditing(true)
    }
}
