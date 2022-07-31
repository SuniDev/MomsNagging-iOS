//
//  DetailHabitView.swift
//  momsnagging
//
//  Created by suni on 2022/05/06.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa
import RxGesture

class DetailHabitView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: DetailHabitViewModel?
    var navigator: Navigator!
    
    private let cycleCellSpacing: CGFloat = 10.5
    private var cycleCellHeight: CGFloat = 0.0
    private let cycleIdentifier = "CycleCell"
    private let viewAddPushTimeHeight: CGFloat = 40.0
    
    private var weekData: [String] = []
    private var cycleCollectionViewItem: [String] = []
    
    private var collectionViewOb = PublishSubject<Int>()
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    lazy var btnDone = UIButton()
    lazy var btnMore = UIButton().then({
        $0.isHidden = true
        $0.setImage(Asset.Icon.more.image, for: .normal)
    })
    lazy var lblTitle = UILabel().then({
        $0.text = "습관 상세"
    })
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    lazy var bottomSheet = CommonBottomSheet()
    
    var tempName: String = ""
    
    /// 습관 이름
    lazy var detailNameFrame = UIView()
    lazy var viewNameTitle = UIView()
    lazy var viewHintTextField = UIView()
    lazy var tfName = CommonTextField().then({
        $0.placeholder = "어떤 습관 추가할래?"
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
        $0.placeholder = "어떤 시간 혹은 상황에서 할래?"
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.addLeftPadding(width: 2)
    })
    
    var startDateDivider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
    })
    
    /// 시작 날짜
    lazy var detailStartDateFrame = UIView()
    lazy var btnStartDate = UIButton()
    lazy var viewStartDateTitle = UIView()
    lazy var tfStartDate = CommonTextField().then({
        $0.isEnabled = false
        $0.normalBorderColor = .clear
        $0.textColor = Asset.Color.monoDark010.color
        $0.placeholder = "언제부터 시작할래?"
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.addLeftPadding(width: 2)
    })
    lazy var tfStartDateParam = CommonTextField()
    var startDateWeek = ""
    
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
    
    var week: Int = -1
    
    /// 이행 주기
    lazy var cycleFrame = UIView()
    lazy var viewCycleTitle = UIView()
    lazy var viewCycleType = UIView().then({
        $0.addBorder(color: Asset.Color.monoLight020.color, width: 1)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var btnCycleWeek = CommonButton().then({
        $0.layer.cornerRadius = 5
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.selectedBackgroundColor = Asset.Color.priLight010.color
        $0.setTitle("어떤 요일?", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark030.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .selected)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.selectedFont = FontFamily.Pretendard.semiBold.font(size: 14)
        $0.isSelected = true
        
    })
    lazy var btnCycleNumber = CommonButton().then({
        $0.layer.cornerRadius = 5
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.selectedBackgroundColor = Asset.Color.priLight010.color
        $0.setTitle("일주일에 몇 번 이상?", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark030.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .selected)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.selectedFont = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var cycleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: cycleCellLayout())
        collectionView.register(CycleCell.self, forCellWithReuseIdentifier: cycleIdentifier)
        collectionView.backgroundColor = Asset.Color.monoWhite.color
        collectionView.contentInset = .zero
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private func cycleCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cycleCellSpacing
        layout.minimumLineSpacing = .zero
        self.cycleCellHeight = (UIScreen.main.bounds.width - (cycleCellSpacing * 6) - (18 * 2)) / 7
        layout.itemSize = CGSize(width: self.cycleCellHeight, height: self.cycleCellHeight)
        return layout
    }
    
    lazy var divider = UIView()
    
    /// 잔소리 알림
    lazy var detailNaggingPushFrame = UIView()
    lazy var viewDefaultNaggingPush = UIView()
    lazy var viewTimeNaggingPush = UIView()
    lazy var lblTime = UILabel()
    
    lazy var lblPushTitle = UILabel().then({
        $0.text = "잔소리 PUSH 알림"
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
    var toolBarDoneBtn = UIBarButtonItem()
    var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)).then({
        $0.barStyle = .default
    })
    
    /// Common 수정을 하지 않고 진행하기 위해 임의로 수정버튼 숨김을 위한 emptyView
    lazy var hideModifyEmptyView = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
        $0.isHidden = true
    })
    
    // MARK: - init
    init(viewModel: DetailHabitViewModel, navigator: Navigator) {
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
        
        /// 습관 이름
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfName, lblHint: lblHint)
        if viewModel?.modifyPage ?? false {
            viewNameTitle = CommonView.requiredTitleFrame("습관 이름", true)
        } else {
            viewNameTitle = CommonView.requiredTitleFrame("습관 이름", false)
        }
        detailNameFrame = CommonView.detailNameFrame(viewNameTitle: viewNameTitle, viewHintTextField: viewHintTextField)
        
        /// 수행 시간
        if viewModel?.modifyPage ?? false {
            viewTimeTitle = CommonView.requiredTitleFrame("수행 시간", true)
        } else {
            viewTimeTitle = CommonView.requiredTitleFrame("수행 시간", false)
        }
        detailPerformTimeFrame = CommonView.detailPerformTimeFrame(viewTimeTitle: viewTimeTitle, tfTime: tfPerformTime)
        
        /// 시작 날짜
        viewStartDateTitle = CommonView.requiredTitleFrame("시작 날짜", false)
        detailStartDateFrame = CommonView.detailPerformTimeFrame(viewTimeTitle: viewStartDateTitle, tfTime: tfStartDate)
        
        /// 이행 주기
        if viewModel?.modifyPage ?? false {
            viewCycleTitle = CommonView.requiredTitleFrame("이행 주기", true)
        } else {
            viewCycleTitle = CommonView.requiredTitleFrame("이행 주기", false)
        }
        divider = CommonView.divider()
        
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
        viewContents.addSubview(detailStartDateFrame)
        viewContents.addSubview(btnPerformTime)
        viewContents.addSubview(btnStartDate)
        viewContents.addSubview(cycleFrame)
        
        /// 이행 주기
        cycleFrame.addSubview(viewCycleTitle)
        cycleFrame.addSubview(viewCycleType)
        viewCycleType.addSubview(btnCycleWeek)
        viewCycleType.addSubview(btnCycleNumber)
        cycleFrame.addSubview(cycleCollectionView)
        cycleFrame.addSubview(divider)
        
        viewContents.addSubview(detailNaggingPushFrame)
        view.addSubview(datePickerView)
        view.addSubview(datePickerControlBar)
        datePickerControlBar.addSubview(datePickerSelectBtn)
        datePickerView.backgroundColor = .white
        
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
        
        /// 습관 이름
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
        
        /// 시작 날짜
        detailStartDateFrame.snp.makeConstraints({
            $0.height.equalTo(101)
            $0.top.equalTo(detailPerformTimeFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        btnStartDate.snp.makeConstraints({
            $0.edges.equalTo(detailStartDateFrame.snp.edges)
        })
        
        /// 이행 주기
        cycleFrame.snp.makeConstraints({
            $0.height.equalTo(143 + self.cycleCellHeight)
            $0.top.equalTo(detailStartDateFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        viewCycleTitle.snp.makeConstraints({
            $0.top.leading.equalToSuperview()
        })
        
        viewCycleType.snp.makeConstraints({
            $0.height.equalTo(42)
            $0.top.equalTo(viewCycleTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
        })
        
        btnCycleWeek.snp.makeConstraints({
            $0.top.leading.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-3)
        })
        
        btnCycleNumber.snp.makeConstraints({
            $0.width.equalTo(btnCycleWeek)
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalTo(btnCycleWeek.snp.trailing).offset(3)
            $0.bottom.trailing.equalToSuperview().offset(-3)
        })
        
        cycleCollectionView.snp.makeConstraints({
            $0.top.equalTo(viewCycleType.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.cycleCellHeight)
        })
        
        divider.snp.makeConstraints({
            $0.top.equalTo(cycleCollectionView.snp.bottom).offset(32)
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        /// 잔소리 알림
        detailNaggingPushFrame.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(cycleFrame.snp.bottom).offset(20)
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
        view.layoutIfNeeded()
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let backAlertDoneHandler = PublishRelay<Void>()
        let deleteAlertDoneHandler = PublishRelay<Void>()
        
        let input = DetailHabitViewModel.Input(
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
            btnStartDateTapped: self.btnStartDate.rx.tap.asDriverOnErrorJustComplete(),
            textStartDate: self.tfStartDate.rx.observe(String.self, "text").asDriver(onErrorJustReturn: ""),
            startDateParam: self.tfStartDateParam.rx.observe(String.self, "text").asDriver(onErrorJustReturn: ""),
            btnCycleWeekTapped: self.btnCycleWeek.rx.tap.asDriverOnErrorJustComplete(),
            btnCycleNumber: self.btnCycleNumber.rx.tap.asDriverOnErrorJustComplete(),
            cycleModelSelected: self.cycleCollectionView.rx.modelSelected(String.self).asDriverOnErrorJustComplete(),
            cycleModelDeselected: self.cycleCollectionView.rx.modelDeselected(String.self).asDriverOnErrorJustComplete(),
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
        
        /// 작성 모드
        output.isWriting
            .drive(onNext: { isWriting in
                // 헤더 변경
                self.btnMore.isHidden = isWriting
                self.btnDone.isHidden = !isWriting
                
                // 22.07.02 추가
                self.setTextColor(isWriting: isWriting)
                self.tfName.isEnabled = isWriting
                if viewModel.isRecommendHabitBool {
                    self.tfName.isEnabled = false
                    self.tfName.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                }
                // 컨텐츠 변경
                self.btnPerformTime.isEnabled = isWriting
                self.btnCycleWeek.isEnabled = isWriting
                self.btnCycleNumber.isEnabled = isWriting
                self.cycleCollectionView.isUserInteractionEnabled = isWriting
                self.tfPicker.isEnabled = isWriting
                self.switchPush.isEnable = isWriting
                
                // 수정 버튼 숨김
                if isWriting {
                    self.hideModifyEmptyView.isHidden = true
                } else {
                    self.hideModifyEmptyView.isHidden = false
                }
            }).disposed(by: disposeBag)
        
        // 텍스트 필드 수정 가능 여부
//        viewModel.isRecommendHabit.subscribe(onNext: { bool in
//            if bool {
//                self.tfName.isEnabled = bool
//            } else {
//                self.tfName.isEnabled = !bool
//            }
//        }).disposed(by: self.disposeBag)
        
        /// 뒤로 가기
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
                    Log.debug("아이디 확인", "\(self.viewModel?.todoModel?.id ?? 0)")
                    self.viewModel?.requestDeleteRoutine(scheduleId: self.viewModel?.todoModel?.id ?? 0)
                    deleteAlertDoneHandler.accept(())
                })
            }).disposed(by: disposeBag)
        
        /// 습관 이름
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
        
        output.cycleItems
            .bind(to: cycleCollectionView.rx.items(cellIdentifier: cycleIdentifier, cellType: CycleCell.self)) { index, item, cell in
                if item == "일" {
                    cell.normalTitleColor = Asset.Color.error.color
                }
                cell.lblTitle.text = item
                self.collectionViewOb.onNext(index)
            }.disposed(by: disposeBag)
        
        output.selectCycleType
            .drive(onNext: { type in
                self.btnCycleWeek.isSelected = type == .week
                self.btnCycleNumber.isSelected = type == .number
                self.cycleCollectionView.allowsMultipleSelection = type == .week
                let inset = type == .week ? 0 : ((self.cycleCellSpacing + self.cycleCellHeight) / 2)
                self.cycleCollectionView.snp.updateConstraints({
                    $0.leading.trailing.equalToSuperview().inset(inset)
                })
                
                if type == .week {
                    if self.week != -1 {
                        self.disableCycleClick(index: self.week)
                    }
                } else {
                    self.initCycle()
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
        
        output.successDoneAddHabit
            .drive(onNext: {
                self.navigator.pop(sender: self, toRoot: true)
            }).disposed(by: disposeBag)
        
        viewModel.routineInfoOb.subscribe(onNext: { data in
            self.tfName.text = data.scheduleName
            self.tfPerformTime.text = data.scheduleTime
            
            let date = data.scheduleDate?.toDate()
            self.tfStartDate.text = date?.toString()
//            let formatter = DateFormatter()
            let dayOfWeek = date?.toStringE()
            
            if dayOfWeek != "" {
                if dayOfWeek == "월" {
                    self.disableCycleClick(index: 0)
                    self.week = 0
                } else if dayOfWeek == "화" {
                    self.disableCycleClick(index: 1)
                    self.week = 1
                } else if dayOfWeek == "수" {
                    self.disableCycleClick(index: 2)
                    self.week = 2
                } else if dayOfWeek == "목" {
                    self.disableCycleClick(index: 3)
                    self.week = 3
                } else if dayOfWeek == "금" {
                    self.disableCycleClick(index: 4)
                    self.week = 4
                } else if dayOfWeek == "토" {
                    self.disableCycleClick(index: 5)
                    self.week = 5
                } else if dayOfWeek == "일" {
                    self.disableCycleClick(index: 6)
                    self.week = 6
                }
            }
            
            
            if data.mon ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 0]) as? CycleCell
                cell?.select()
            }
            if data.tue ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 1]) as? CycleCell
                cell?.select()
            }
            if data.wed ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 2]) as? CycleCell
                cell?.select()
            }
            if data.thu ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 3]) as? CycleCell
                cell?.select()
            }
            if data.fri ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 4]) as? CycleCell
                cell?.select()
            }
            if data.sat ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 5]) as? CycleCell
                cell?.select()
            }
            if data.sun ?? false {
                let cell = self.cycleCollectionView.cellForItem(at: [0, 6]) as? CycleCell
                cell?.select()
            }
            
            if data.goalCount != 0 && data.goalCount != nil {
                let indexRow: Int = Int(data.goalCount!) - 1
                let cell = self.cycleCollectionView.cellForItem(at: [0, indexRow]) as? CycleCell
                cell?.isSelected = true
            }
            
            if data.alarmTime != "" {
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
            let height = data.alarmTime != "" ? self.viewAddPushTimeHeight : 0
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
        
        collectionViewOb.subscribe(onNext: { i in
            if i == 6 {
                self.disableCycleClick(index: self.week)
            } else {
                self.initCycle()
            }
        }).disposed(by: disposeBag)
        
        viewModel.modifySuccessOb.subscribe(onNext: { _ in
            self.navigator.pop(sender: self)
        }).disposed(by: disposeBag)
        
        output.recommendedName.drive(onNext: { st in
            self.tfName.text = st
            self.tfName.normal()
        }).disposed(by: disposeBag)
        
        viewModel.recommendHabitNameOb.subscribe(onNext: { st in
            self.tfName.text = st
        }).disposed(by: disposeBag)
        
//        if self.tfName.backgroundColor == UIColor(asset: Asset.Color.monoLight010) {
//            self.tfName.isEnabled = false
//        } else {
//            self.tfName.isEnabled = true
//        }
        tfName.rx.text.subscribe(onNext: { text in
            if text?.count ?? 0 > 30 {
                self.tfName.text?.removeLast()
            } else {
                self.textCountLbl.text = "\(text?.count ?? 0)/30"
            }
        }).disposed(by: disposeBag)
        
        btnStartDate.rx.tap.bind {
            self.datePickerView.isHidden = false
            self.datePickerControlBar.isHidden = false
        }.disposed(by: disposeBag)
    }
    
    // MARK: - performTimeViewModel bind
    func bindPerformTime(_ viewModel: PerformTimeSettingViewModel) {
        
        viewModel.perfromTime.skip(1)
            .subscribe(onNext: { text in
                self.tfPerformTime.text = text
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Func
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
    
    func disableCycleClick(index: Int) {
        for i in 0...6 {
            if i == index {
                let cell = self.cycleCollectionView.cellForItem(at: [0, index]) as? CycleCell
                cell?.isUserInteractionEnabled = false
                cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.priLight018Dis)
                cell?.layoutIfNeeded()
            } else {
                let cell = self.cycleCollectionView.cellForItem(at: [0, i]) as? CycleCell
                cell?.isUserInteractionEnabled = true
                cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
                cell?.layoutIfNeeded()
            }
        }
    }
    
    func initCycle() {
        for i in 0...5 {
            let cell = self.cycleCollectionView.cellForItem(at: [0, i]) as? CycleCell
            cell?.isUserInteractionEnabled = true
            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
            cell?.layoutIfNeeded()
        }
    }
    
    @objc
    func toolBarDoneAction() {
        self.view.endEditing(true)
    }
    
    @objc
    func selectDayAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        tfStartDate.text = formatter.string(from: sender.date)
        formatter.dateFormat = "yyyy-MM-dd"
        tfStartDateParam.text = formatter.string(from: sender.date)
        formatter.dateFormat = "E"
        startDateWeek = formatter.string(from: sender.date)
        
        if self.startDateWeek != "" {
            if self.startDateWeek == "월" {
                self.disableCycleClick(index: 0)
                self.week = 0
            } else if self.startDateWeek == "화" {
                self.disableCycleClick(index: 1)
                self.week = 1
            } else if self.startDateWeek == "수" {
                self.disableCycleClick(index: 2)
                self.week = 2
            } else if self.startDateWeek == "목" {
                self.disableCycleClick(index: 3)
                self.week = 3
            } else if self.startDateWeek == "금" {
                self.disableCycleClick(index: 4)
                self.week = 4
            } else if self.startDateWeek == "토" {
                self.disableCycleClick(index: 5)
                self.week = 5
            } else if self.startDateWeek == "일" {
                self.disableCycleClick(index: 6)
                self.week = 6
            }
        }
    }
    @objc
    func selectDateAction() {
        self.view.endEditing(true)
        self.datePickerView.isHidden = true
        self.datePickerControlBar.isHidden = true
    }
}
