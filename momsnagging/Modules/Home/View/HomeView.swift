//
//  HomeView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import UIKit
import Then
import SnapKit
import RxSwift
/*
 - 참고 사항 -> 월간달력 새로운 파일로 뷰를 생성하여 표시하는게 아닌 Hidden 상태를 True, False로 컨트롤 하고있습니다 :)
        by) tavi
 */
class HomeView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBind()
        setTodoTableView()
        setHomeCalendarView()
        setFloatingBtn()
        self.todoListType.removeAll()
        viewModel.requestTodoListLookUp(date: todoListParam())
        Log.debug("CommonUser.authorization", "Bearer \(CommonUser.authorization)")
    }
    // MARK: - Temp
    // MARK: - Init
    init(viewModel: HomeViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Param
    var todoListLookUpParam: String = ""
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: HomeViewModel!
    var calendarViewModel = CalendarViewModel()
    var disposedBag = DisposeBag()
    var collectionViewOutput: HomeViewModel.Output?
    var todoList: [TodoListModel] = []
    var todoListType: [Int] = []
    var moveList: [TodoListModel] = []
    var moveListModel:[ScheduleArrayModel] = []
    /*
     prefix : head
     Year, Month, Day 홈화면의 Head 타이틀에 들어갈 날짜 연,월,일
     */
    var headYear: Int = 0
    var headMonth: Int = 0
    var headDay: Int = 0
    var selectDayIndex: Int?// 주간달력 달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    /*
     prefix : calendar
     Year, Month, Day 월간달력의 Lbl에 표시하기 위한 날짜 연, 월, 일
     */
    var calendarYear: Int?
    var calendarMonth: Int?
    var calendarDay: Int?
    
    var monthCollectionViewHeight: Int? // 월별로 주(4주~6주)수를 카운팅하여 CollectionView의 높이를 remake하기 위함.
    var dateCheck: Int = 0 // 현재월 (0)로부터 다음달(1) 이전달 (-1)로 더하거나 빼는 변수
    var calendarSelectIndex: Int? // 월간달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    var selectMonth: Int = 0 // 현재 월(0) 인지 확인 하는 변수
    var selectDate: String = ""
    // MARK: - UI Properties
    // 헤드프레임 UI Properties
    var listBtn = UIButton()
    var headTitleLbl = UILabel()
    var headDropDownBtn = UIButton()
    var headDropDownIc = UIImageView()
    var diaryBtn = UIButton()
    var headFrame = UIView()
    
    var headCancel = UIButton().then({
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(UIColor(asset: Asset.Color.black), for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 18)
        $0.tag = 0
        $0.isHidden = true
    })
    var headSave = UIButton().then({
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(UIColor(asset: Asset.Color.success), for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 18)
        $0.tag = 1
        $0.isHidden = true
    })
    
    // 캘린더 UI Properties
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
        collectionView.register(HomeCalendarCell.self, forCellWithReuseIdentifier: "HomeCalendarCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    /// 주간달력 컬렉션뷰
    var weekCalendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekCalendarDayCellLayout())
        collectionView.register(WeekDayCalendarCell.self, forCellWithReuseIdentifier: "WeekDayCalendarCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    /// 홈화면의 주간 달력의 셀 레이아웃
    static func weekCalendarDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 21 - (10 * 6)) / 7, height: 56)
        return layout
    }
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
    
    var floatingBackgroundView = UIView()
    var habitItem = UIView()
    var todoItem = UIView()
    var floatingBtnView = UIView()
    let floatingBtnIc = UIImageView()
    var floatingBtn = UIButton() // 플로팅 버튼
    var addHabitBtn = UIButton() // 플로팅 아이템 버튼
    var addTodoBtn = UIButton() // 플로팅 아이템 버튼
    
    var tableViewTopDivider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight020)
    })
    var todoListTableView = UITableView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.separatorStyle = .none
        $0.register(HomeTodoListCell.self, forCellReuseIdentifier: "HomeTodoListCell")
        $0.register(RoutineCell.self, forCellReuseIdentifier: "RoutineCell")
        $0.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        $0.register(RoutineCountCell.self, forCellReuseIdentifier: "RoutineCountCell")
    })
    
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headTitleLbl.text = calendarViewModel.todayFormatteryyMMdd()
        headFrame = CommonView.dropDownHeadFrame(leftIcBtn: listBtn, headTitle: headTitleLbl, dropDownImageView: headDropDownIc, dropDownBtn: headDropDownBtn, rightIcBtn: diaryBtn)
        
        calendarYear = calendarViewModel.getYear()
        calendarMonth = calendarViewModel.getMonth()
        calendarDay = calendarViewModel.getToday()
        calendarDateLbl.text = "\(calendarYear ?? 0)년 \(calendarMonth ?? 0)월"
        monthCollectionViewHeight = 7
        calendarFrame = homeCalendarView()
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(headCancel)
        view.addSubview(headSave)
        view.addSubview(weekCalendarCollectionView)
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(76)
        })
        weekCalendarCollectionView.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom)
            $0.leading.equalTo(view.snp.leading).offset(10.5)
            $0.trailing.equalTo(view.snp.trailing).offset(-10.5)
            $0.height.equalTo(68)
        })
        headCancel.snp.makeConstraints({
            $0.centerY.equalTo(headFrame.snp.centerY)
            $0.leading.equalTo(headFrame.snp.leading).offset(20)
        })
        headSave.snp.makeConstraints({
            $0.centerY.equalTo(headFrame.snp.centerY)
            $0.trailing.equalTo(headFrame.snp.trailing).offset(-20)
        })
    }
    // MARK: - Bind _ Output
    override func bind() {
//        headTitleLbl.rx.text
        calendarViewModel.monthObservable.subscribe( onNext: { [weak self] in
            self?.calendarMonth = $0
            self?.calendarDateLbl.text = "\(self?.calendarYear ?? 0)년 \($0)월"
        }).disposed(by: disposedBag)
        calendarViewModel.yearObservable.subscribe( onNext: { [weak self] in
            self?.calendarYear = $0
            self?.calendarDateLbl.text = "\($0)년 \(self?.calendarMonth ?? 0)월"
        }).disposed(by: disposedBag)
        
        calendarViewModel.weekDayListObservable // 주달력 데이터 [String]
            .bind(to: self.weekCalendarCollectionView.rx.items(cellIdentifier: "WeekDayCalendarCell", cellType: WeekDayCalendarCell.self)) { index, item, cell in
                cell.weekDayLbl.text = self.calendarViewModel.getWeekDayList()[index]
                cell.numberLbl.text = "\(item)"
                if ("\(item)" == self.calendarViewModel.todaydd()) || "0\(item)" == self.calendarViewModel.todaydd() {
                    cell.isToday = true
                    cell.numberLbl.textColor = UIColor(asset: Asset.Color.monoWhite)
                } else {
                    cell.isToday = false
                    cell.numberLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                }
            }.disposed(by: disposedBag)
        calendarViewModel.monthObservable.subscribe { self.headMonth = $0 }.disposed(by: disposedBag)
        calendarViewModel.yearObservable.subscribe { self.headYear = $0 }.disposed(by: disposedBag)
        monthCollectionViewHeight = calendarViewModel.rowCount(currentMonth: self.headMonth, currentYear: self.headYear)
        calendarViewModel.weekDayList(currentMonth: headMonth, currentYear: headYear)
        
        weekCalendarCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            for i in 0..<7 {
                let cell = self.weekCalendarCollectionView.cellForItem(at: [0, i]) as? WeekDayCalendarCell
                if i == indexPath.row {
                    cell?.selectDayRoundFrame.isHidden = false
                } else {
                    cell?.selectDayRoundFrame.isHidden = true
                }
            }
            let cell = self.weekCalendarCollectionView.cellForItem(at: [0, indexPath.row]) as? WeekDayCalendarCell
            self.headTitleLbl.text = self.calendarViewModel.todayFormatteryyyyMM()
            var day: String = cell?.numberLbl.text ?? ""
            var month: String = "\(self.calendarMonth ?? 0)"
            var calendarMonth: Int = Int(exactly: self.calendarMonth ?? 0)!
            if Int(month)! < 10 {
                month = "0\(month)"
            }
            if Int(day)! < 10 {
                day = "0\(day)"
            }
            self.selectDate = "\(self.headTitleLbl.text ?? "")\(day)"
            self.headTitleLbl.text = self.calendarViewModel.getSelectDate(dateString: self.selectDate)
            self.todoListLookUpParam = "20\(self.headTitleLbl.text ?? "")"
            self.todoListLookUpParam = self.todoListLookUpParam.replacingOccurrences(of: ".", with: "-")
            self.todoListType.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            
            let currentYearMonth = self.calendarViewModel.todayFormatteryyyyMM()
            let calendarYearMonth = "\(self.calendarYear ?? 0)\(month)"
            print("__\(calendarYearMonth)__\(currentYearMonth)")
            if calendarYearMonth == "\(currentYearMonth)" {
                print("이번달!")
                for i in 0..<37 {
                    let cell = self.dayCollectionView.cellForItem(at: [0, i]) as? HomeCalendarCell
                    if cell?.number.text == day {
                        cell?.selectDayRoundFrame.isHidden = false
                    } else {
                        cell?.selectDayRoundFrame.isHidden = true
                    }
                }
            }
            
        }).disposed(by: disposedBag)
        
        calendarViewModel.weekDay // 월 ~ 일
            .bind(to: self.weekDayCollectionView.rx.items(cellIdentifier: "CalendarWeekDayCell", cellType: CalendarWeekDayCell.self)) { index, item, cell in
                if (index % 7) == 6 {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.error)
                } else {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.monoDark010)
                }
                cell.dayWeekLabel.text = item
            }.disposed(by: disposedBag)
        
        calendarViewModel.collectionViewHeight.subscribe { self.dayCollectionViewRemakeConstraint(count: $0) }.disposed(by: disposedBag)
        
        calendarViewModel.daylist // 월 달력 데이터 [String]
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "HomeCalendarCell", cellType: HomeCalendarCell.self)) { index, item, cell in
                if item == "emptyCell" {
                    cell.number.isHidden = false
                    cell.number.text = ""
                    cell.isUserInteractionEnabled = false
                } else {
                    cell.number.isHidden = false
                    cell.number.text = item
                    cell.isUserInteractionEnabled = true
                }
                if self.dateCheck == 0 && (("\(item)" == self.calendarViewModel.todaydd()) || "0\(item)" == self.calendarViewModel.todaydd()) {
                    cell.isToday = true
                    cell.number.textColor = UIColor(asset: Asset.Color.monoWhite)
                } else {
                    cell.isToday = false
                    if (index % 7) == 6 {
                        cell.number.textColor = UIColor(asset: Asset.Color.error)
                    } else {
                        cell.number.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                }
                
                if self.calendarSelectIndex != nil {
                    if self.dateCheck == self.selectMonth && self.calendarSelectIndex == index {
                        cell.selectDayRoundFrame.isHidden = false
                    } else {
                        cell.selectDayRoundFrame.isHidden = true
                    }
                }
                
            }.disposed(by: disposedBag)
        
        dayCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.calendarSelectIndex = indexPath.row
            for i in 0..<37 {
                let cell = self.dayCollectionView.cellForItem(at: [0, i]) as? HomeCalendarCell
                if i == indexPath.row {
                    cell?.selectDayRoundFrame.isHidden = false
                } else {
                    cell?.selectDayRoundFrame.isHidden = true
                }
            }
            let cell = self.dayCollectionView.cellForItem(at: [0, indexPath.row]) as? HomeCalendarCell
            var day: String = cell?.number.text ?? ""
            var month: String = "\(self.calendarMonth ?? 0)"
            if Int(day)! < 10 {
                day = "0\(day)"
            }
            if self.calendarMonth ?? 0 < 10 {
                month = "0\(self.calendarMonth ?? 0)"
            }
            self.selectDate = "\(self.calendarYear ?? 0)\(month)\(day)"
            if self.calendarViewModel.todayFormatteryyyyMM() == "\(self.calendarYear ?? 0)\(month)" {
                for i in 0..<7 {
                    let cell = self.weekCalendarCollectionView.cellForItem(at: [0, i]) as? WeekDayCalendarCell
                    if cell?.numberLbl.text == day {
                        cell?.selectDayRoundFrame.isHidden = false
                    } else {
                        cell?.selectDayRoundFrame.isHidden = true
                    }
                }
            } else {
                self.weekDaySelectClear()
            }
            self.headTitleLbl.text = self.calendarViewModel.getSelectDate(dateString: self.selectDate)
            self.selectMonth = self.dateCheck
            self.todoListLookUpParam = "20\(self.headTitleLbl.text ?? "")"
            self.todoListLookUpParam = self.todoListLookUpParam.replacingOccurrences(of: ".", with: "-")
            self.todoListType.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
        }).disposed(by: disposedBag)
        
        viewModel.arraySuccessOb.subscribe(onNext: { _ in
            self.moveListModel.removeAll()
            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
            self.headBtnBind(input: input)
            self.collectionViewOutput = self.viewModel.transform(input: input)
            self.todoListTableView.dragInteractionEnabled = false
            self.todoList.removeAll()
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
    }
    
    // MARK: - Action Bind _ Input
    func actionBind() {
        guard let viewModel = viewModel else { return }
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
        }).disposed(by: disposedBag)
        
        // 월간달력 Close Event
        calendarCloseBtn.rx.tap.bind(onNext: { _ in
            self.calendarFrame.isHidden = true
            self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
            self.headDropDownBtn.isSelected = false
        }).disposed(by: disposedBag)
        
        // 월 달력 이전달 ClickEvent
        self.btnPrev.rx.tap.bind {
            self.dateCheck -= 1
            self.calendarViewModel.getLastMonth(currentMonth: self.calendarMonth!, currentYear: self.calendarYear!)
        }.disposed(by: disposedBag)
        // 월 달력 다음달 ClickEvent
        self.btnNext.rx.tap.bind {
            self.dateCheck += 1
            self.calendarViewModel.getNextMonth(currentMonth: self.calendarMonth!, currentYear: self.calendarYear!)
        }.disposed(by: disposedBag)
        
        // 일기장 ClickEvent
        self.diaryBtn.rx.tap.bind {
            // TODO: service 
            let viewModel = DiaryViewModel(withService: SceneDelegate.appService)
            let vc = self.navigator.get(seque: .diary(viewModel: viewModel))
            self.navigator.show(seque: .diary(viewModel: viewModel), sender: vc, transition: .navigation)
        }.disposed(by: disposedBag)
        // 정렬 ClickEvent
        self.listBtn.rx.tap.bind {
            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: true)
//            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: true, sourceIndex: nil, destinationIndex: nil, scheduleType: nil)
            self.headBtnBind(input: input)
            self.collectionViewOutput = viewModel.transform(input: input)
            self.todoListTableView.dragInteractionEnabled = true
            self.todoList.removeAll()
            self.todoListTableView.reloadData()
        }.disposed(by: disposedBag)
        self.headCancel.rx.tap.bind {
            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
            self.headBtnBind(input: input)
            self.collectionViewOutput = viewModel.transform(input: input)
            self.todoListTableView.dragInteractionEnabled = false
            self.todoList.removeAll()
            self.todoListTableView.reloadData()
        }.disposed(by: disposedBag)
        self.headSave.rx.tap.bind {
            if self.moveListModel.count != 0 {
                self.viewModel.requestArray(param: self.moveListModel)
            } else {
                lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
                self.headBtnBind(input: input)
                self.collectionViewOutput = viewModel.transform(input: input)
                self.todoListTableView.dragInteractionEnabled = false
                self.todoList.removeAll()
                self.todoListTableView.reloadData()
            }
        }.disposed(by: disposedBag)
    }
    // MARK: - Other
    func headBtnBind(input: HomeViewModel.Input) {
        lazy var output = viewModel.transform(input: input)
        output.diaryBtnStatus?.drive { bool in
            self.diaryBtn.isHidden = bool
        }.disposed(by: self.disposedBag)
        output.listBtnStatus?.drive { bool in
            self.listBtn.isHidden = bool
        }.disposed(by: self.disposedBag)
        output.cancelBtnStatus?.drive { bool in
            self.headCancel.isHidden = bool
        }.disposed(by: self.disposedBag)
        output.saveBtnStatus?.drive { bool in
            self.headSave.isHidden = bool
        }.disposed(by: self.disposedBag)
    }
    func cellSelectInit() {
        for i in 0..<37 {
            let cell = self.dayCollectionView.cellForItem(at: [0, i]) as? HomeCalendarCell
            cell?.selectDayRoundFrame.isHidden = true
        }
    }
    func weekDaySelectClear() {
        for i in 0..<7 {
            let cell = self.weekCalendarCollectionView.cellForItem(at: [0, i]) as? WeekDayCalendarCell
            cell?.selectDayRoundFrame.isHidden = true
        }
    }
    func calendarSelectClear() {
        for i in 0..<37 {
            let cell = self.dayCollectionView.cellForItem(at: [0, i]) as? HomeCalendarCell
            cell?.selectDayRoundFrame.isHidden = true
        }
    }
    
    func todoListParam() -> String {
        var month = ""
        var day = ""
        if calendarMonth! < 10 {
            month = "0\(calendarMonth!)"
        } else {
            month = "\(calendarMonth!)"
        }
        if calendarDay! < 10 {
            day = "0\(calendarDay!)"
        } else {
            day = "\(calendarDay!)"
        }
        todoListLookUpParam = "\(calendarYear!)-\(month)-\(day)"
        return "\(calendarYear!)-\(month)-\(day)"
    }
    
}

extension HomeView {
    func setHomeCalendarView() {
        view.addSubview(calendarFrame)
        calendarFrame.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
    }
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
    
    // MARK: - Other
    /// 일(1 ~ 28,29,30,31)표시 컬렉션뷰를 주(4주~6주)수에 따라 컬렉션뷰 레이아웃 재설정 함수
    func dayCollectionViewRemakeConstraint(count: Int) {
        dayCollectionView.snp.remakeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(16)
            $0.leading.equalTo(calendarView.snp.leading).offset(20)
            $0.trailing.equalTo(calendarView.snp.trailing).offset(-20)
            $0.height.equalTo(38 * count)
        })
    }
    
}
