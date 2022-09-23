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
        if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {
            vc.view.addSubview(self.dimView)
            self.dimView.snp.makeConstraints({
                $0.edges.equalTo(vc.view.snp.edges)
                $0.top.equalTo(vc.view.safeAreaLayoutGuide.snp.top)
            })
            vc.view.addSubview(self.sortDimView)
            self.sortDimView.snp.makeConstraints({
                $0.edges.equalTo(vc.view.snp.edges)
                $0.top.equalTo(vc.view.safeAreaLayoutGuide.snp.top)
            })
        }
        self.todoListType.removeAll()
        viewModel.requestTodoListLookUp(date: todoListParam())
//        Log.debug("CommonUser.authorization", "Bearer \(CommonUser.authorization)")
//        CommonView.showAlert(vc: self, type: .oneBtn, message: "키키")
        
//        LoadingHUD.show()
        Log.debug("CommonUser.authorization", "\(CommonUser.authorization ?? "")")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Log.debug("HomeView viewWillAppear")
        
        hiddenAlignment()
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
    var moveListModel: [ScheduleArrayModel] = []
    var checkBtnInteractionEnable = true
    var popOb = PublishSubject<Void>()
    /*
     prefix : head
     Year, Month, Day 홈화면의 Head 타이틀에 들어갈 날짜 연,월,일
     */
    var headYear: Int = 0
    var headMonth: Int = 0
    var headDay: Int = 0
    var selectDayIndex: Int?// 주간달력 달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    var selectDayMonth: Int = 0// 선택한 달의 숫자 현재 월 0 이전으로갈수록 -1 다음달로갈때 +1
    /*
     prefix : calendar
     Year, Month, Day 월간달력의 Lbl에 표시하기 위한 날짜 연, 월, 일
     */
    var calendarYear: Int?
    var calendarMonth: Int?
    var calendarDay: Int?
    
    var weekCalendarYear: Int?
    var weekCalendarMonth: Int?
    var weekCalendarDay: Int?
    
    var monthCollectionViewHeight: Int? // 월별로 주(4주~6주)수를 카운팅하여 CollectionView의 높이를 remake하기 위함.
    var dateCheck: Int = 0 // 현재월 (0)로부터 다음달(1) 이전달 (-1)로 더하거나 빼는 변수
    var calendarSelectIndex: Int? // 월간달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    var selectMonth: Int = 0 // 현재 월(0) 인지 확인 하는 변수
    var selectDate: String = ""
    var dayList: [DateItemModel] = [] // Observable하고있는 dayList의 데이터를 담기위함 (선택한 날짜의 index값을 찾기위함)
    
    enum MonthlyConfirmation { // 주간 달력에서 선택한 일자가 이번달,이전달,다음달 중 속하는곳을 확인
        case previousMonth
        case thisMonth
        case nextMonth
    }
    var monthlyConfirmation: MonthlyConfirmation?
    
    var selectDayDate: Date?
    var weekDaySelectDateString = ""
    
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
    
    // popUp
    var sortPopUp = CommonPopup()
    
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
        collectionView.register(WeekDayCalendarTodayCell.self, forCellWithReuseIdentifier: "WeekDayCalendarTodayCell")
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
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 41 - (9 * 6)) / 7, height: 12)
        return layout
    }
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 셀 레이아웃
    static func dayDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 41 - (9 * 6)) / 7, height: 28)
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
    var listEmptyFrame = UIView()
    
    let dimView = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.black)?.withAlphaComponent(0.34)
        $0.isHidden = true
    })
    let sortDimView = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.black)?.withAlphaComponent(0.30)
        $0.isHidden = true
    })
    
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headTitleLbl.text = calendarViewModel.todayFormatteryyMMdd()
        headFrame = CommonView.dropDownHeadFrame(leftIcBtn: listBtn, headTitle: headTitleLbl, dropDownImageView: headDropDownIc, dropDownBtn: headDropDownBtn, rightIcBtn: diaryBtn)
        listEmptyFrame = listEmptyView()
        listEmptyFrame.isHidden = true
        
        calendarYear = calendarViewModel.getYear()
        calendarMonth = calendarViewModel.getMonth()
        calendarDay = calendarViewModel.getToday()
        weekCalendarYear = calendarViewModel.getYear()
        weekCalendarMonth = calendarViewModel.getMonth()
        weekCalendarDay = calendarViewModel.getToday()

        calendarDateLbl.text = "\(calendarYear ?? 0)년 \(calendarMonth ?? 0)월"
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
        
        calendarViewModel.weekDayListObservable
            .bind(to: self.weekCalendarCollectionView.rx.items) { cv, row, item in
                let indexPath = IndexPath.init(item: row, section: 0)
                if item.isToday ?? false {
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "WeekDayCalendarTodayCell", for: indexPath) as? WeekDayCalendarTodayCell
                    cell?.numberLbl.text = "\(item.day ?? 0)"
                    cell?.weekDayLbl.text = self.calendarViewModel.getWeekDayList()[row]
                    cell?.day = item.day ?? 0
                    cell?.month = item.month ?? 0
                    cell?.year = item.year ?? 0
                    if row == 6 {
                        cell?.weekDayLbl.textColor = UIColor(asset: Asset.Color.error)
                    } else {
                        cell?.weekDayLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                    Log.debug("calendarViewModel Item Month, Year", "\(item.month), \(item.year)")
                    return cell ?? cv.dequeueReusableCell(withReuseIdentifier: "WeekDayCalendarTodayCell", for: indexPath)
                } else {
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "WeekDayCalendarCell", for: indexPath) as? WeekDayCalendarCell
                    cell?.numberLbl.text = "\(item.day ?? 0)"
                    cell?.weekDayLbl.text = self.calendarViewModel.getWeekDayList()[row]
                    cell?.day = item.day ?? 0
                    cell?.month = item.month ?? 0
                    cell?.year = item.year ?? 0
                    if row == 6 {
                        cell?.weekDayLbl.textColor = UIColor(asset: Asset.Color.error)
                        cell?.numberLbl.textColor = UIColor(asset: Asset.Color.error)
                    } else {
                        cell?.weekDayLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        cell?.numberLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                    if item.select ?? false {
                        cell?.selectDayRoundFrame.isHidden = false
                    } else {
                        cell?.selectDayRoundFrame.isHidden = true
                    }
                    Log.debug("calendarViewModel Item Month, Year", "\(item.month), \(item.year)")
                    return cell ?? cv.dequeueReusableCell(withReuseIdentifier: "WeekDayCalendarCell", for: indexPath)
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
            let cellToday = self.weekCalendarCollectionView.cellForItem(at: [0, indexPath.row]) as? WeekDayCalendarTodayCell
            self.headTitleLbl.text = self.calendarViewModel.todayFormatteryyyy()
            var year: Int = cell?.year ?? 0
            var day: Int!
            if cell?.numberLbl.text == nil {
                day = cellToday?.day ?? 0
            } else {
                day = cell?.day ?? 0
            }
            if cell?.year == nil {
                year = cellToday?.year ?? 0
            } else {
                year = cell?.year ?? 0
            }
            var month: Int = cell?.month ?? 0
            if cell?.month == nil {
                month = cellToday?.month ?? 0
            } else {
                month = cell?.month ?? 0
            }
            
            Log.debug("day!__", "\(day), \(month), \(year)")
//            self.ca
            
            self.calendarDateLbl.text = "\(year)년 \(month)월"
            self.calendarMonth = month
            if month < self.calendarViewModel.getMonth() {
                self.monthlyConfirmation = .previousMonth
                Log.debug("달 테스트 : ", "이전달")
            } else if month > self.calendarViewModel.getMonth() {
                self.monthlyConfirmation = .nextMonth
                Log.debug("달 테스트 : ", "다음달")
//                self.calendarDateLbl.text = "\(year)년 \(month)월"
//                self.calendarMonth = month
            } else {
                self.monthlyConfirmation = .thisMonth
//                self.calendarDateLbl.text = "\(year)년 \(month)월"
//                self.calendarMonth = month
//                Log.debug("달 테스트 : ", "이번달")
            }
//            self.calendarDateLbl.text = "\(year)년 \(month)월"
//            self.calendarMonth = month
//            self.dateCheck -= 1
            var yearSt = ""
            var monthSt = ""
            var daySt = ""
            if month < 10 {
                monthSt = "0\(month)"
            } else {
                monthSt = "\(month)"
            }
            if day < 10 {
                daySt = "0\(day ?? 0)"
            } else {
                daySt = "\(day ?? 0)"
            }
            self.weekDaySelectDateString = "\(year)\(monthSt)\(daySt)"
            Log.debug("weekDaySelectDateString", self.weekDaySelectDateString)
            
            Log.debug("monthlyConfirmation Test", "\(self.monthlyConfirmation)")
            
            self.calendarViewModel.reloadDayListNew(currentMonth: month, currentYear: year, selectDateSt: self.weekDaySelectDateString)
            
            for (index, item) in self.dayList.enumerated() where "\(item.day ?? 0)" == "\(day ?? 0)" {
                self.calendarSelectIndex = index
            }

//            if day > self.calendarViewModel.getToday() + 6 { // 이전달의 날짜클릭시 month - 1처리 ex.) 6월첫번째 주 주간달력의 5월31일 선택시.
//                month -= 1
//                if month == 0 {
//                    month = 12
//                    year -= year
//                }
//            } else if day < self.calendarViewModel.getToday() - 6 {
//                Log.debug("흠 얘는 9월달이여~", "")
//                month += 1
//                if month == 13 {
//                    month = 1
//                    year += year
//                }
//            }
            
            if day < 10 {
                if month < 10 {
                    self.selectDate = "\(year)0\(month)0\(day ?? 0)"
                } else {
                    self.selectDate = "\(year)\(month)0\(day ?? 0)"
                }
            } else {
                if month < 10 {
                    self.selectDate = "\(year)0\(month)\(day ?? 0)"
                } else {
                    self.selectDate = "\(year)\(month)\(day ?? 0)"
                }
            }
            
            
            Log.debug("selectDate _ DayCollectionView1 : ", "\(self.selectDate)")
            self.headTitleLbl.text = self.calendarViewModel.getSelectDate(dateString: self.selectDate)
            self.todoListLookUpParam = "20\(self.headTitleLbl.text ?? "")"
            self.todoListLookUpParam = self.todoListLookUpParam.replacingOccurrences(of: ".", with: "-")
            self.todoListType.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            
            self.calendarSelectClear()
            Log.debug("selectDate _ DayCollectionView : ", "\(self.selectDate)")
            self.dayCollectionView.reloadData()
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
        
        calendarViewModel.dayListNew.subscribe(onNext: { list in
            Log.debug("dayList_!", "\(list)")
            self.dayList.removeAll()
            self.dayList = list
        }).disposed(by: disposedBag)
        calendarViewModel.dayListNew // 월 달력 데이터 [String]
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "HomeCalendarCell", cellType: HomeCalendarCell.self)) { index, item, cell in
                Log.debug("dayListNewItem", "\(item.day ?? 0) _ \(item.month ?? 0) _ \(item.year ?? 0)")
                if item.isEmpty ?? false {
                    cell.number.isHidden = false
                    cell.number.text = ""
                    cell.isUserInteractionEnabled = false
                } else {
                    cell.number.isHidden = false
                    cell.number.text = "\(item.day ?? 0)"
                    cell.isUserInteractionEnabled = true
                }
                
                if item.isToday ?? false {
                    cell.number.textColor = UIColor(asset: Asset.Color.monoWhite)
                    cell.todayRoundFrame.isHidden = false
                } else {
                    cell.todayRoundFrame.isHidden = true
                    if (index % 7) == 6 {
                        cell.number.textColor = UIColor(asset: Asset.Color.error)
                    } else {
                        cell.number.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                }
                var daySt = ""
                var monthSt = ""
                let yearSt = item.year ?? 0
                if item.day ?? 0 < 10 {
                    daySt = "0\(item.day ?? 0)"
                } else {
                    daySt = "\(item.day ?? 0)"
                }
                if item.month ?? 0 < 10 {
                    monthSt = "0\(item.month ?? 0)"
                } else {
                    monthSt = "\(item.month ?? 0)"
                }
                
//                if self.weekDaySelectDateString == "\(yearSt)\(monthSt)\(daySt)" {
//                    cell.selectDayRoundFrame.isHidden = false
//                } else {
//                    cell.selectDayRoundFrame.isHidden = true
//                }
                
                if item.select ?? false {
                    cell.selectDayRoundFrame.isHidden = false
                } else {
                    cell.selectDayRoundFrame.isHidden = true
                }
                
                // 새로 추가한 부분
//                if self.calendarSelectIndex != nil {
//                    if self.dateCheck != self.selectDayMonth {
//                        cell.selectDayRoundFrame.isHidden = true
//                    } else {
//                        for i in 0..<37 {
//                            let cell = self.dayCollectionView.cellForItem(at: [0, i]) as? HomeCalendarCell
//                            if i == self.calendarSelectIndex {
//                                cell?.selectDayRoundFrame.isHidden = false
//                            } else {
//                                cell?.selectDayRoundFrame.isHidden = true
//                            }
//                        }
//                    }
//                }
            }.disposed(by: disposedBag)
        
        dayCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.calendarFrame.isHidden = true
            self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
            self.headDropDownBtn.isSelected = false
            self.selectDayMonth = self.dateCheck
            
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
            let year: Int = Int(self.calendarYear!)
            var day: String = cell?.number.text ?? ""
            var month: String = "\(self.calendarMonth ?? 0)"
            if Int(day)! < 10 {
                day = "0\(day)"
            }
            if self.calendarMonth ?? 0 < 10 {
                month = "0\(self.calendarMonth ?? 0)"
            }
            self.selectDate = "\(self.calendarYear ?? 0)\(month)\(day)"
            self.weekDaySelectClear() // 주간 달력 선택 표시 삭제
            
            
            // 주간 달력 변경을 위한 선택날짜 Date저장
            let selectDaySt = "\(year)-\(month)-\(day) 00:00:00"
//            Log.debug("dateString", selectDaySt)
//            Log.debug("dateString_ toDate", selectDaySt.toDate(dateString: selectDaySt))
            self.selectDayDate = selectDaySt.toDate(dateString: selectDaySt)
            self.calendarViewModel.selectWeekDayList(currentMonth: Int(month)!, currentYear: year, selectDate: self.selectDayDate ?? Date(), selectWeekDay: indexPath.row % 7)
            self.calendarViewModel.reloadDayListNew(currentMonth: self.calendarMonth ?? 0, currentYear: year, selectDateSt: self.selectDate)
//            Log.debug("selectIndexPathDayCollectionView", indexPath.row % 7)
            
            self.headTitleLbl.text = self.calendarViewModel.getSelectDate(dateString: self.selectDate)
            self.selectMonth = self.dateCheck
            self.todoListLookUpParam = "20\(self.headTitleLbl.text ?? "")"
            self.todoListLookUpParam = self.todoListLookUpParam.replacingOccurrences(of: ".", with: "-")
            self.todoListType.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            self.weekDayCollectionView.reloadData()
        }).disposed(by: disposedBag)
        
        viewModel.arraySuccessOb.subscribe(onNext: { _ in
            self.moveListModel.removeAll()
            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
            self.headBtnBind(input: input)
            self.collectionViewOutput = self.viewModel.transform(input: input)
            self.todoListTableView.dragInteractionEnabled = false
//            self.todoList.removeAll()
            self.todoListTableView.reloadData()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
        }).disposed(by: disposedBag)
    }
    
    // MARK: - Action Bind _ Input
    func actionBind() {
        guard let viewModel = viewModel else { return }
        // dropDown Ic ClickEvent
        headDropDownBtn.rx.tap.bind(onNext: { _ in
            self.checkBtnInteractionEnable = true
            if self.headDropDownBtn.isSelected {
                self.calendarFrame.isHidden = true
                self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
                self.headDropDownBtn.isSelected = false
            } else {
                // GA - 홈 월간 달력 탭
                CommonAnalytics.logEvent(.tap_home_monthly_calendar)
                
                self.calendarFrame.isHidden = false
                self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronUp)
                self.headDropDownBtn.isSelected = true
                
                // 리스트 정렬 하는 상태 종료
                lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
                self.headBtnBind(input: input)
                self.collectionViewOutput = viewModel.transform(input: input)
                self.todoListTableView.dragInteractionEnabled = false
                self.todoListTableView.reloadData()
            }
            self.dayCollectionView.reloadData()
        }).disposed(by: disposedBag)
        
        // 월간달력 Close Event
        calendarCloseBtn.rx.tap.bind(onNext: { _ in
            self.calendarFrame.isHidden = true
            self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
            self.headDropDownBtn.isSelected = false
        }).disposed(by: disposedBag)
        
        calendarViewModel.monthObservable.subscribe(onNext: { month in
            self.calendarMonth = month
//            self.calendarViewModel.getMonthNew(currentMonth: self.calendarMonth!, currentYear: self.calendarYear!)
        }).disposed(by: disposedBag)
        calendarViewModel.yearObservable.subscribe(onNext: { year in
            self.calendarYear = year
//            self.calendarViewModel.getMonthNew(currentMonth: self.calendarMonth!, currentYear: self.calendarYear!)
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
            // GA - 홈 일기장 탭
            CommonAnalytics.logEvent(.tap_home_diary)
            
            let viewModel = DiaryViewModel(withService: SceneDelegate.appService)
            let vc = self.navigator.get(seque: .diary(viewModel: viewModel))
            self.navigator.show(seque: .diary(viewModel: viewModel), sender: vc, transition: .navigation)
        }.disposed(by: disposedBag)
        // 정렬 ClickEvent
        self.listBtn.rx.tap.bind {
            self.checkBtnInteractionEnable = false
            // 리스트 정렬 클릭시 캘린더 숨김
            self.calendarFrame.isHidden = true
            self.headDropDownIc.image = UIImage(asset: Asset.Icon.chevronDown)
            self.headDropDownBtn.isSelected = false

            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: true)
            self.headBtnBind(input: input)
            self.collectionViewOutput = viewModel.transform(input: input)
            self.todoListTableView.dragInteractionEnabled = true
            self.todoListTableView.reloadData()
            Log.debug("클릭", "정렬버튼")
            if UserDefaults.standard.string(forKey: "sortListPopUp") == nil {
                self.sortListPopUp()
                self.sortDimView.isHidden = false
            }
        }.disposed(by: disposedBag)
        self.headCancel.rx.tap.bind {
            self.moveListModel.removeAll()
            self.checkBtnInteractionEnable = true
            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
            self.headBtnBind(input: input)
            self.collectionViewOutput = viewModel.transform(input: input)
            self.todoListTableView.dragInteractionEnabled = false
            self.todoListTableView.reloadData()
        }.disposed(by: disposedBag)
        self.headSave.rx.tap.bind {
            self.checkBtnInteractionEnable = true
            if self.moveListModel.count != 0 {
                self.viewModel.requestArray(param: self.moveListModel)
            } else {
                lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
                self.headBtnBind(input: input)
                self.collectionViewOutput = viewModel.transform(input: input)
                self.todoListTableView.dragInteractionEnabled = false
                self.todoListTableView.reloadData()
            }
            self.moveListModel.removeAll()
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
    
    func listEmptyView() -> UIView {
        let view = UIView().then({
            $0.backgroundColor = .clear
        })
        let image = UIImageView().then({
            $0.image = UIImage(asset: Asset.Assets.mainEmptyImage)
        })
        view.addSubview(image)
        image.snp.makeConstraints({
            $0.width.equalTo(216)
            $0.height.equalTo(228)
            $0.center.equalTo(view.snp.center)
        })
        return view
    }
    
    func hiddenAlignment() {
        self.checkBtnInteractionEnable = true
        lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, listBtnAction: false)
        self.headBtnBind(input: input)
        self.collectionViewOutput = viewModel.transform(input: input)
        self.todoListTableView.dragInteractionEnabled = false
        self.todoListTableView.reloadData()
    }
    
    func sortListPopUp() {
        self.sortPopUp.setUI(popupType: .sortList)
        self.sortPopUp.showAnim(vc: self, parentAddView: self.view)
        self.sortPopUp.btnLeft.rx.tap.bind {
            print("왼쪽버튼")
            UserDefaults.standard.set("", forKey: "sortListPopUp")
            self.sortPopUp.hideAnim()
            self.sortDimView.isHidden = true
        }.disposed(by: disposedBag)
        self.sortPopUp.btnRight.rx.tap.bind {
            print("오른쪽버튼")
            self.sortPopUp.hideAnim()
            self.sortDimView.isHidden = true
        }
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
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(12)
        })
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(16)
            $0.leading.equalTo(calendarView.snp.leading).offset(20)
            $0.trailing.equalTo(calendarView.snp.trailing).offset(-20)
            $0.height.equalTo(38 * 7)
        })
        
        return view
    }
    
}
