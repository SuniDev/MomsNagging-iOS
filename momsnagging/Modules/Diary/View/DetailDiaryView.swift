//
//  DetailDiaryView.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa

class DetailDiaryView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: DetailDiaryViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var dimView = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
        $0.isHidden = true
    })
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    lazy var btnDone = UIButton()
    
    lazy var btnMore = UIButton().then({
        $0.isHidden = true
        $0.setImage(Asset.Icon.more.image, for: .normal)
    })
    lazy var bottomSheet = CommonBottomSheet()
    
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var tfTitle = CommonTextField().then({
        $0.normalBorderColor = .clear
        $0.placeholder = "제목"
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.contentVerticalAlignment = .center
        $0.borderStyle = .none
        $0.returnKeyType = .next
    })
    
    lazy var tvContents = UITextView().then({
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark010.color
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    })
    
    // MARK: - 캘린더 UI: Properties & Variable & UI Properties
    var calendarViewModel = CalendarViewModel()
    /*
     prefix : head
     Year, Month, Day 홈화면의 Head 타이틀에 들어갈 날짜 연,월,일
     */
//    var headYear: Int = 0
//    var headMonth: Int = 0
//    var headDay: Int = 0
//    var selectDayIndex: Int?// 주간달력 달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    /*
     prefix : calendar
     Year, Month, Day 월간달력의 Lbl에 표시하기 위한 날짜 연, 월, 일
     */
//    var calendarYear: Int?
//    var calendarMonth: Int?
//    var calendarDay: Int?
    
    var monthCollectionViewHeight: Int? // 월별로 주(4주~6주)수를 카운팅하여 CollectionView의 높이를 remake하기 위함.
//    var dateCheck: Int = 0 // 현재월 (0)로부터 다음달(1) 이전달 (-1)로 더하거나 빼는 변수
//    var calendarSelectIndex: Int? // 월간달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
//    var selectMonth: Int = 0 // 현재 월(0) 인지 확인 하는 변수
//    var selectDate: String = ""
    
    lazy var headTitleLbl = UILabel()
    lazy var headDropDownIc = UIImageView().then({
        $0.image = Asset.Icon.chevronDown.image
    })
    lazy var headDropDownBtn = UIButton().then({
        $0.backgroundColor = .clear
    })
    var calendarFrame = UIView()
    var calendarView = UIView().then({
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
    })
    var calendarCloseBtn = UIButton()
    var calendarDateLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    var btnPrev = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.chevronLeft), for: .normal)
    })
    var btnNext = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.chevronRight), for: .normal)
    })
    /// 월간달력의 월~ 일 컬렉션뷰
    var weekDayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekDayCellLayout())
        collectionView.register(CalendarWeekDayCell.self, forCellWithReuseIdentifier: "CalendarWeekDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 컬렉션뷰
    var dayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(DetailDiaryCalendarCell.self, forCellWithReuseIdentifier: "DetailDiaryCalendarCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    /// 월~일 에 해당하는 셀 레이아웃
    static func weekDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 32.83
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 52 - (32.83 * 6)) / 7, height: 18)
        return layout
    }
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 셀 레이아웃
    static func dayDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 23
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 42 - (23 * 6)) / 7, height: 28)
        return layout
    }
    
    // MARK: - init
    init(viewModel: DetailDiaryViewModel, navigator: Navigator) {
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

        // Do any additional setup after loading the view.
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
        // MARK: - 캘린더 UI: initUI
        headTitleLbl.text = calendarViewModel.todayFormatteryyMMdd()
        viewHeader = CommonView.detailHeadFrame(btnBack: btnBack, lblTitle: headTitleLbl, btnDone: btnDone)
        monthCollectionViewHeight = 7
        calendarFrame = homeCalendarView()
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        viewHeader.addSubview(btnMore)
        
        view.addSubview(viewBackground)
        viewBackground.addSubview(tfTitle)
        viewBackground.addSubview(tvContents)
        view.addSubview(dimView)
        
        dimView.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        viewHeader.snp.makeConstraints({
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        })
        
        btnMore.snp.makeConstraints({
            $0.height.width.equalTo(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        })
        
        viewBackground.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        tfTitle.snp.makeConstraints({
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        tvContents.snp.makeConstraints({
            $0.top.equalTo(tfTitle.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-24)
        })
        
        // MARK: - 캘린더 UI: layoutSetting
        viewHeader.addSubview(headDropDownIc)
        viewHeader.addSubview(headDropDownBtn)
        view.addSubview(calendarFrame)
        headDropDownIc.snp.makeConstraints({
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(headTitleLbl.snp.trailing).offset(9)
        })
        
        headDropDownBtn.snp.makeConstraints({
            $0.top.leading.equalTo(headTitleLbl).offset(-5)
            $0.trailing.equalTo(headDropDownIc).offset(5)
            $0.bottom.equalTo(headTitleLbl).offset(5)
        })
        calendarFrame.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let dateChangeAlertHandler = PublishRelay<Bool>()
        let doneAlertDoneHandler = PublishRelay<Void>()
        let backAlertDoneHandler = PublishRelay<Void>()
        let deleteAlertDoneHandler = PublishRelay<Void>()
        
        let input = DetailDiaryViewModel
            .Input(
                willAppearDetailDiary: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
                loadCalendar: Observable.just(CalendarDate(year: self.calendarViewModel.getYear(),
                                                           month: self.calendarViewModel.getMonth(),
                                                           day: self.calendarViewModel.getToday())).asDriverOnErrorJustComplete(),
                setCalendarMonth: self.calendarViewModel.monthObservable.asDriverOnErrorJustComplete(),
                setCalendarYear: self.calendarViewModel.yearObservable.asDriverOnErrorJustComplete(),
                loadDayList: self.calendarViewModel.daylist.asDriverOnErrorJustComplete(),
                loadWeekDay: self.calendarViewModel.weekDay.asDriverOnErrorJustComplete(),
//                dayModelSelected: self.dayCollectionView.rx.modelSelected(DetailDiaryDayItem.self).asDriverOnErrorJustComplete(),
                dayItemsSelected: self.dayCollectionView.rx.itemSelected.asDriverOnErrorJustComplete(),
                btnPrevTapped: self.btnPrev.rx.tap.mapToVoid().asDriverOnErrorJustComplete(),
                btnNextTapped: self.btnNext.rx.tap.mapToVoid().asDriverOnErrorJustComplete(),
                dateChangeAlertHandler: dateChangeAlertHandler.asDriverOnErrorJustComplete(),
                btnMoreTapped: self.btnMore.rx.tap.asDriverOnErrorJustComplete(),
                dimViewTapped: self.bottomSheet.dimView.rx.tapGesture().when(.recognized).mapToVoid().asDriverOnErrorJustComplete(),
                btnModifyTapped: self.bottomSheet.btnModify.rx.tap.asDriverOnErrorJustComplete(),
                btnDeleteTapped: self.bottomSheet.btnDelete.rx.tap.asDriverOnErrorJustComplete(),
                btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
                backAlertDoneHandler: backAlertDoneHandler.asDriverOnErrorJustComplete(),
                deleteAlertDoneHandler: deleteAlertDoneHandler.asDriverOnErrorJustComplete(),
                textTitle: self.tfTitle.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                textContents: self.tvContents.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidEndOnExitTitle: self.tfTitle.rx.controlEvent(.editingDidEndOnExit).asDriverOnErrorJustComplete(),
                didBeginContents: self.tvContents.rx.didBeginEditing.asDriverOnErrorJustComplete(),
                didEndEditingContents: self.tvContents.rx.didEndEditing.asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete(),
                doneAlertDoneHandler: doneAlertDoneHandler.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        /// 캘린더
        output.setCalendarDate
            .drive(onNext: { date in
                self.calendarDateLbl.text = "\(date.year)년 \(date.month)월"
                self.monthCollectionViewHeight = self.calendarViewModel.rowCount(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposeBag)
        
        output.setTitleDate
            .drive(onNext: { date in
                Log.debug("setTitleDate", date)
                self.headTitleLbl.text = date
            }).disposed(by: disposeBag)
        
        output.dayItems
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "DetailDiaryCalendarCell", cellType: DetailDiaryCalendarCell.self)) { index, item, cell in
                cell.number.text = item.strDay
                cell.isToday = item.isToday
                cell.isSunday = (index % 7) == 6
                cell.isEnabled = item.isThisMonth
                cell.configure()
            }.disposed(by: disposeBag)
        
        output.weekItems
            .bind(to: self.weekDayCollectionView.rx.items(cellIdentifier: "CalendarWeekDayCell", cellType: CalendarWeekDayCell.self)) { index, item, cell in
                if (index % 7) == 6 {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.error)
                } else {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.monoDark010)
                }
                cell.dayWeekLabel.text = item
            }.disposed(by: disposeBag)
        
        output.setLastMonth
            .drive(onNext: { date in
                self.calendarViewModel.getLastMonth(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposeBag)
        
        output.setNextMonth
            .drive(onNext: { date in
                self.calendarViewModel.getNextMonth(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposeBag)
        
        output.selectedDayIndex
            .drive(onNext: { index in
//                let cell = self.dayCollectionView.cellForItem(at: [0, index]) as? DetailDiaryCalendarCell

                self.dayCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
            }).disposed(by: disposeBag)

        /// 바텀 시트
        output.showBottomSheet
            .drive(onNext: {
                self.bottomSheet.showAnim(vc: self, parentAddView: self.view)
            }).disposed(by: disposeBag)
        
        output.hideBottomSheet
            .drive(onNext: {
                self.bottomSheet.hideAnim()
            }).disposed(by: disposeBag)
        
        /// 날짜 이동
        output.showDateChangeAlert
            .drive(onNext: { message in
                CommonView.showAlert(vc: self, title: "", message: message, cancelHandler: {
                    dateChangeAlertHandler.accept(false)
                }, destructiveHandler: {
                    dateChangeAlertHandler.accept(true)
                })
            }).disposed(by: disposeBag)
                        
        /// 작성 모드
        output.isWriting
            .drive(onNext: { isWriting in
                // 헤더 변경
                self.btnMore.isHidden = isWriting
                self.btnDone.isHidden = !isWriting
                
                self.tfTitle.isEnabled = isWriting
                self.tfTitle.textColor = isWriting ? Asset.Color.monoDark010.color : Asset.Color.monoDark020.color
                
                self.tvContents.isEditable = isWriting
//                self.tvContents.textColor = isWriting ? Asset.Color.monoDark010.color : Asset.Color.monoDark020.color
            }).disposed(by: disposeBag)
        
        /// 뒤로 가기
        output.showBackAlert
            .drive(onNext: { message in
                CommonView.showAlert(vc: self, title: "", message: message, destructiveHandler: {
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
        
        /// 일기작 작성
        output.setTextTitle
            .drive(onNext: { text in
                self.tfTitle.text = text
            }).disposed(by: disposeBag)
        
        output.lengthExceededTitle
            .drive(onNext: {
                self.tfTitle.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        output.setTextContents
            .drive(onNext: { text in
                self.tvContents.text = text
            }).disposed(by: disposeBag)
        
        output.lengthExceededContents
            .drive(onNext: {
                self.tvContents.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        output.endEditingTitle
            .drive(onNext: {
                self.tfTitle.resignFirstResponder()
                self.tvContents.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        output.setContentsPlaceholder
            .drive(onNext: { text in
                self.tvContents.text = text
                self.tvContents.textColor = text.isEmpty ? Asset.Color.monoDark010.color : Asset.Color.monoDark030.color
            }).disposed(by: disposeBag)
        
        output.canBeDone
            .drive(onNext: { isEnabled in
                self.btnDone.isEnabled = isEnabled
            }).disposed(by: disposeBag)
        
        output.successDoneDiary
            .drive(onNext: { title in
                self.view.endEditing(true)
                self.dimView.fadeIn(alpha: 0.5)
                CommonView.showAlert(vc: self, type: .oneBtn, title: title, message: "", doneTitle: STR_DONE, doneHandler: {
                    self.dimView.fadeOut()
                    doneAlertDoneHandler.accept(())
                })
            }).disposed(by: disposeBag)
                
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { height in
                let margin = height + 16
                self.tvContents.snp.updateConstraints({
                    $0.bottom.equalToSuperview().offset(-margin)
                })
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        // MARK: - 캘린더 UI: bind
//        dayCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
//            let cell = self.dayCollectionView.cellForItem(at: [0, indexPath.row]) as? HomeCalendarCell
//            var day: String = cell?.number.text ?? ""
//            var month: String = "\(self.calendarMonth ?? 0)"
//            if Int(day)! < 10 {
//                day = "0\(day)"
//            }
//            if self.calendarMonth ?? 0 < 10 {
//                month = "0\(self.calendarMonth ?? 0)"
//            }
//            self.selectDate = "\(self.calendarYear ?? 0)\(month)\(day)"
//            self.headTitleLbl.text = self.calendarViewModel.getSelectDate(dateString: self.selectDate)
//            self.selectMonth = self.dateCheck
//        }).disposed(by: disposeBag)
        
        // MARK: - 캘린더 UI: Action Bind
        // dropDown Ic ClickEvent
        headDropDownBtn.rx.tap.bind(onNext: { _ in
            if self.headDropDownBtn.isSelected {
                self.calendarFrame.isHidden = true
                self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
                self.headDropDownBtn.isSelected = false
            } else {
                self.calendarFrame.isHidden = false
                self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronUp)
                self.headDropDownBtn.isSelected = true
            }
        }).disposed(by: disposeBag)
        
        // 월간달력 Close Event
        calendarCloseBtn.rx.tap.bind(onNext: { _ in
            self.calendarFrame.isHidden = true
            self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
            self.headDropDownBtn.isSelected = false
        }).disposed(by: disposeBag)
    }
}
extension DetailDiaryView {
    
    // MARK: - 캘린더 UI: homeCalendarView
    /**
     # homeCalendarView
     - Authors: tavi
     - returns: UIView
     - Note: 홈의 월캘린더를 UIView로 리턴하는 함수
     */
    func homeCalendarView() -> UIView {
        let view = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoDark010)?.withAlphaComponent(0.5)
            $0.isHidden = true
        })
        
        view.addSubview(calendarView)
        calendarView.addSubview(btnPrev)
        calendarView.addSubview(btnNext)
        calendarView.addSubview(calendarDateLbl)
        calendarView.addSubview(weekDayCollectionView)
        calendarView.addSubview(dayCollectionView)
        view.addSubview(calendarCloseBtn)
        
        calendarView.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(-20)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.top).offset(340)
        })
        calendarDateLbl.snp.makeConstraints({
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.snp.top).offset(16)
        })
        btnPrev.snp.makeConstraints({
            $0.centerY.equalTo(calendarDateLbl.snp.centerY)
            $0.trailing.equalTo(calendarDateLbl.snp.leading).offset(-29)
            $0.width.height.equalTo(24)
        })
        btnNext.snp.makeConstraints({
            $0.centerY.equalTo(calendarDateLbl.snp.centerY)
            $0.leading.equalTo(calendarDateLbl.snp.trailing).offset(29)
            $0.width.height.equalTo(24)
        })
        calendarCloseBtn.snp.makeConstraints({
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
        weekDayCollectionView.snp.makeConstraints({
            $0.top.equalTo(calendarDateLbl.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(26)
            $0.trailing.equalTo(view.snp.trailing).offset(-26)
            $0.height.equalTo(12)
        })
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(16)
            $0.leading.equalTo(calendarView.snp.leading).offset(20)
            $0.trailing.equalTo(calendarView.snp.trailing).offset(-20)
            $0.height.equalTo(38 * monthCollectionViewHeight!)
        })
        
        return view
    }
}
