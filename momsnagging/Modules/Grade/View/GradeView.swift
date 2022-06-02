//
//  GradeView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

class GradeView: BaseViewController, Navigatable, UIScrollViewDelegate {
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: GradeViewModel!
    var disposedBag = DisposeBag()
    var calendarViewModel = CalendarViewModel()
//    var tableViewOutput: ReportCardViewModel.Output?
//    var statisticsInput = PublishSubject<ReportCardViewModel.Input>()
//    var statisticsOutput: ReportCardViewModel.Output?
//    var todoList: [TodoListModel] = []
    
//    var calendarYear: Int?
//    var calendarMonth: Int?
//    var calendarDay: Int?
    
//    var statisticsYear: Int?
//    var statisticsMonth: Int?
//    var statisticsPrev: Bool? // 이전달(true)로가는지 다음달(false)로가는지 체크
    
    var monthCollectionViewHeight: Int? // 월별로 주(4주~6주)수를 카운팅하여 CollectionView의 높이를 remake하기 위함.
//    var dateCheck: Int = 0 // 현재월 (0)로부터 다음달(1) 이전달 (-1)로 더하거나 빼는 변수
//    var calendarSelectIndex: Int? // 월간달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
//    var selectMonth: Int = 0 // 현재 월(0) 인지 확인 하는 변수
//    var selectDate: String = ""
    // MARK: - UI Properties
    // 헤더
    var noneBtn = UIButton()
    var awardBtn = UIButton()
    var headFrame = UIView()
    
    // 달력
    var calendarBtn = UIButton().then({
        $0.isSelected = true
        $0.setTitle("달력", for: .normal)
    })
    var calendarUnderLine = UIView()
    var calendarTab = UIView()
    
    // 통게
    var statisticsBtn = UIButton().then({
        $0.isSelected = false
        $0.setTitle("통계", for: .normal)
    })
    var statisticsUnderLine = UIView()
    var statisticsTab = UIView()
    
    var divider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
    })
    
    // 캘린더 UI Properties
    var calendarScrollView = UIScrollView()
    var calendarViewContents = UIView()
    var calendarFrame = UIView()
    var calendarHeadFrame = UIView()
//    var calendarView = UIView().then({
//        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
//    })
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
    var calendarDivider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight020)
    })
    /// 월간달력의 월~ 일 컬렉션뷰
    var weekDayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekDayCellLayout())
        collectionView.register(GradeWeekDayCell.self, forCellWithReuseIdentifier: "GradeWeekDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 컬렉션뷰
    var dayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(GradeCalendarCell.self, forCellWithReuseIdentifier: "GradeCalendarCell")
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
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 32) / 7, height: 12)
        return layout
    }
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 셀 레이아웃
    static func dayDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 32) / 7, height: 58)
        return layout
    }
    
    var todoListTableView = UITableView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.separatorStyle = .none
        $0.register(GradeTodoCell.self, forCellReuseIdentifier: "GradeTodoCell")
    })
    
    // 통계 UI Properties
    var statisticsScrollView = UIScrollView().then({
        $0.isHidden = true
    })
    var statisticsBackgroundFrame = UIView()

    var dayCountLblPre = UILabel().then({
        $0.text = "엄마와 함께한지"
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 20)
    })
    var dayCoundLbl = UILabel().then({
        $0.text = "D+123"
        $0.textColor = UIColor(asset: Asset.Color.priMain)
        $0.font = FontFamily.Pretendard.bold.font(size: 20)
    })
    var dayCountLblSuf = UILabel().then({
        $0.text = "일"
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 20)
    })
    var statisticsCalendarFrame = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor(asset: Asset.Color.monoDark010)?.cgColor
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 6
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowPath = nil
    })
    var statisticsPrevBtn = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.chevronLeft), for: .normal)
    })
    var statisticsNextBtn = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.chevronRight), for: .normal)
    })
    var statisticsDateLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    var statisticsRatingTableView = UITableView().then({
        $0.register(StatisticsCalendarCell.self, forCellReuseIdentifier: "StatisticsCalendarCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.isScrollEnabled = false
        $0.tag = 1
    })
    var statisticsPerformTableView = UITableView().then({
        $0.register(StatisticsPerformRateCell.self, forCellReuseIdentifier: "StatisticsPerformRateCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.isScrollEnabled = false
        $0.tag = 2
    })
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    // MARK: - Init
    init(viewModel: GradeViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: noneBtn, headTitle: "성적표", rightIcBtn: awardBtn)
        noneBtn.setImage(nil, for: .normal)
        awardBtn.setImage(UIImage(asset: Asset.Icon.medal), for: .normal)
        calendarTab = tabView(btn: calendarBtn, underLine: calendarUnderLine)
        statisticsTab = tabView(btn: statisticsBtn, underLine: statisticsUnderLine)
        
        monthCollectionViewHeight = 7
        calendarScrollView = CommonView.scrollView(viewContents: calendarViewContents, bounces: false)
        
//        calendarFrame = gradeCalendarView()
        
//        statisticsYear = calendarViewModel.getYear()
//        statisticsMonth = calendarViewModel.getMonth()
//        statisticsDateLbl.text = "\(calendarViewModel.getYear())년 \(calendarViewModel.getMonth())월"
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        // 헤더
        view.addSubview(headFrame)
        view.addSubview(divider)
        view.addSubview(calendarTab)
        view.addSubview(statisticsTab)
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        calendarTab.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.centerX)
            $0.height.equalTo(40)
        })
        statisticsTab.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom)
            $0.leading.equalTo(view.snp.centerX)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(40)
        })
        divider.snp.makeConstraints({
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(calendarTab.snp.bottom)
            $0.height.equalTo(1)
        })
        
        // 캘린더
        view.addSubview(calendarScrollView)
        calendarScrollView.snp.makeConstraints({
            $0.top.equalTo(divider.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        calendarViewContents.addSubview(calendarFrame)
        calendarFrame.snp.makeConstraints({
            $0.height.equalTo(505)
            $0.top.leading.trailing.equalToSuperview()
            
        })
        
        calendarFrame.addSubview(calendarHeadFrame)
        calendarHeadFrame.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
            $0.top.equalToSuperview().offset(20)
        })
        
        calendarHeadFrame.addSubview(calendarDateLbl)
        calendarHeadFrame.addSubview(btnPrev)
        calendarHeadFrame.addSubview(btnNext)
        calendarDateLbl.snp.makeConstraints({
            $0.center.equalToSuperview()
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
        
        calendarFrame.addSubview(weekDayCollectionView)
        weekDayCollectionView.snp.makeConstraints({
            $0.height.equalTo(12)
            $0.top.equalTo(calendarHeadFrame.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        calendarFrame.addSubview(dayCollectionView)
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(398)
        })
        
        calendarViewContents.addSubview(calendarDivider)
        calendarDivider.snp.makeConstraints({
            $0.top.equalTo(calendarFrame.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        })
        
        calendarViewContents.addSubview(todoListTableView)
        todoListTableView.snp.makeConstraints({
            $0.top.equalTo(calendarDivider.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(120)
        })
//
        // 통계
        view.addSubview(statisticsScrollView)
        statisticsScrollView.addSubview(statisticsBackgroundFrame)
        statisticsBackgroundFrame.addSubview(dayCountLblPre)
        statisticsBackgroundFrame.addSubview(dayCoundLbl)
        statisticsBackgroundFrame.addSubview(dayCountLblSuf)
        statisticsBackgroundFrame.addSubview(statisticsCalendarFrame)
        statisticsCalendarFrame.addSubview(statisticsPrevBtn)
        statisticsCalendarFrame.addSubview(statisticsNextBtn)
        statisticsCalendarFrame.addSubview(statisticsDateLbl)
        statisticsCalendarFrame.addSubview(statisticsRatingTableView)
        statisticsBackgroundFrame.addSubview(statisticsPerformTableView)
        
        statisticsScrollView.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom).offset(40)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        statisticsBackgroundFrame.snp.makeConstraints({
            $0.top.equalTo(statisticsScrollView.snp.top)
            $0.leading.equalTo(statisticsScrollView.snp.leading)
            $0.trailing.equalTo(statisticsScrollView.snp.trailing)
            $0.bottom.equalTo(statisticsScrollView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
        })
        dayCountLblPre.snp.makeConstraints({
            $0.top.equalTo(statisticsBackgroundFrame.snp.top).offset(24)
            $0.leading.equalTo(statisticsBackgroundFrame.snp.leading).offset(22)
        })
        dayCoundLbl.snp.makeConstraints({
            $0.centerY.equalTo(dayCountLblPre.snp.centerY)
            $0.leading.equalTo(dayCountLblPre.snp.trailing).offset(8)
        })
        dayCountLblSuf.snp.makeConstraints({
            $0.centerY.equalTo(dayCountLblPre.snp.centerY)
            $0.leading.equalTo(dayCoundLbl.snp.trailing).offset(8)
        })
        statisticsCalendarFrame.snp.makeConstraints({
            $0.top.equalTo(dayCountLblPre.snp.bottom).offset(24)
            $0.leading.equalTo(statisticsBackgroundFrame.snp.leading).offset(48)
            $0.trailing.equalTo(statisticsBackgroundFrame.snp.trailing).offset(-48)
            $0.height.equalTo(284)
        })
        statisticsDateLbl.snp.makeConstraints({
            $0.centerX.equalTo(statisticsCalendarFrame.snp.centerX)
            $0.top.equalTo(statisticsCalendarFrame.snp.top).offset(20)
        })
        statisticsPrevBtn.snp.makeConstraints({
            $0.trailing.equalTo(statisticsDateLbl.snp.leading).offset(-20)
            $0.centerY.equalTo(statisticsDateLbl.snp.centerY)
            $0.width.height.equalTo(24)
        })
        statisticsNextBtn.snp.makeConstraints({
            $0.leading.equalTo(statisticsDateLbl.snp.trailing).offset(20)
            $0.centerY.equalTo(statisticsDateLbl.snp.centerY)
            $0.width.height.equalTo(24)
        })
        statisticsRatingTableView.snp.makeConstraints({
            $0.top.equalTo(statisticsDateLbl.snp.bottom).offset(35)
            $0.leading.equalTo(statisticsCalendarFrame.snp.leading)
            $0.trailing.equalTo(statisticsCalendarFrame.snp.trailing)
            $0.bottom.equalTo(statisticsCalendarFrame.snp.bottom)
        })
        statisticsPerformTableView.snp.makeConstraints({
            $0.top.equalTo(statisticsCalendarFrame.snp.bottom).offset(40)
            $0.height.equalTo(48 * 6)
            $0.leading.equalTo(statisticsScrollView.snp.leading).offset(48)
            $0.trailing.equalTo(statisticsScrollView.snp.trailing).offset(-48)
            $0.bottom.equalTo(statisticsScrollView.snp.bottom).offset(-48)
        })
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = GradeViewModel.Input(
            loadCalendar: Observable.just(CalendarDate(year: self.calendarViewModel.getYear(),
                                                       month: self.calendarViewModel.getMonth(),
                                                       day: self.calendarViewModel.getToday())).asDriverOnErrorJustComplete(),
            setCalendarMonth: self.calendarViewModel.monthObservable.asDriverOnErrorJustComplete(),
            setCalendarYear: self.calendarViewModel.yearObservable.asDriverOnErrorJustComplete(),
            loadDayList: self.calendarViewModel.daylist.asDriverOnErrorJustComplete(),
            loadWeekDay: self.calendarViewModel.weekDay.asDriverOnErrorJustComplete(),
            dayModelSelected: self.dayCollectionView.rx.modelSelected(GradeDayItem.self).asDriverOnErrorJustComplete(),
            btnPrevTapped: self.btnPrev.rx.tap.mapToVoid().asDriverOnErrorJustComplete(),
            btnNextTapped: self.btnNext.rx.tap.mapToVoid().asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.setCalendarDate
            .drive(onNext: { date in
                self.calendarDateLbl.text = "\(date.year)년 \(date.month)월"
            }).disposed(by: disposedBag)
        
        output.dayItems
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "GradeCalendarCell", cellType: GradeCalendarCell.self)) { index, item, cell in
                cell.number.text = item.strDay
                cell.isToday = item.isToday
                cell.isSunday = (index % 7) == 6
                cell.avg = item.day?.avg ?? 100
                cell.isEnabled = item.isThisMonth
                cell.configure()
            }.disposed(by: disposedBag)
        
        output.weekItems
            .bind(to: self.weekDayCollectionView.rx.items(cellIdentifier: "GradeWeekDayCell", cellType: GradeWeekDayCell.self)) { index, item, cell in
                if (index % 7) == 6 {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.error)
                } else {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.monoDark010)
                }
                cell.dayWeekLabel.text = item
            }.disposed(by: disposedBag)
        
        output.setLastMonth
            .drive(onNext: { date in
                self.calendarViewModel.getLastMonth(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposedBag)
        
        output.setNextMonth
            .drive(onNext: { date in
                self.calendarViewModel.getNextMonth(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposedBag)
        
        output.countDayItems
            .drive(onNext: { cnt in
                var row = Int(cnt / 7)
                if cnt % 7 != 0 {
                    row += 1
                }
                let height = ( row * 58 ) + ( 10 * ( row - 1 ))
                Log.debug(row)
                self.dayCollectionView.snp.updateConstraints({
                    $0.height.equalTo(height)
                })
                
                self.calendarFrame.snp.updateConstraints({
                    $0.height.equalTo(height + 107)
                })
            }).disposed(by: disposedBag)
        
        output.todoItems
            .bind(to: self.todoListTableView.rx.items(cellIdentifier: "GradeTodoCell", cellType: GradeTodoCell.self)) {  _, item, cell in
                
                cell.lblTitle.text = item.scheduleName ?? ""
                cell.btnTime.setTitle(item.scheduleTime ?? "", for: .normal)
                
                var scheduleType = ScheduleType.todo
                switch item.scheduleType {
                case ScheduleType.todo.rawValue : scheduleType = .todo
                case ScheduleType.routine.rawValue : scheduleType = .routine
                default: break
                }
                
                switch item.status {
                case ScheduleSatus.unperform.rawValue:
                    cell.unperform(scheduleType: scheduleType, goalCount: item.goalCount)
                case ScheduleSatus.complete.rawValue:
                    cell.complete(scheduleType: scheduleType, goalCount: item.goalCount)
                case ScheduleSatus.skip.rawValue:
                    cell.skip(scheduleType: scheduleType, goalCount: item.goalCount)
                default: break
                }
                
            }.disposed(by: disposedBag)
        
        output.countTodoItems
            .drive(onNext: { cnt in
                let height = cnt * 60
                self.todoListTableView.snp.updateConstraints({
                    $0.height.equalTo(height)
                })
            }).disposed(by: disposedBag)
        
        todoListTableView.rx.setDelegate(self).disposed(by: disposedBag)
    }
}
    
// MARK: = UI
extension GradeView {

    func tabView(btn: UIButton, underLine: UIView) -> UIView {
        let view = UIView()
            underLine.backgroundColor = UIColor(asset: Asset.Color.priMain)
        if btn.isSelected {
            btn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
            btn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
            underLine.isHidden = false
        } else {
            btn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
            btn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
            underLine.isHidden = true
        }
        view.addSubview(btn)
        view.addSubview(underLine)
        btn.snp.makeConstraints({
            $0.edges.equalTo(view.snp.edges)
        })
        underLine.snp.makeConstraints({
            $0.bottom.equalTo(view.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(2)
        })
        return view
    }
}

//    func statisticsBind() {
//        guard let viewModel = viewModel else { return }
//        let input = ReportCardViewModel.Input(tabAction: nil, statisticsPrev: self.statisticsPrevBtn.rx.tap.asDriverOnErrorJustComplete(), statisticsNext: self.statisticsNextBtn.rx.tap.asDriverOnErrorJustComplete(), currentMonth: self.statisticsMonth!, currentYear: self.statisticsYear!, awardTap: self.awardBtn.rx.tap.asDriverOnErrorJustComplete())
//        tableViewOutput = viewModel.transform(input: input)
//        tableViewOutput?.reportListData?.drive { list in
//            list.bind(to: self.statisticsRatingTableView.rx.items(cellIdentifier: "StatisticsCalendarCell", cellType: StatisticsCalendarCell.self)) { _, item, cell in
//                cell.weekLbl.text = "첫째주"
//                cell.reportLbl.text = item.rating ?? ""
//            }
//        }.disposed(by: disposedBag)
//        statisticsRatingTableView.rx.setDelegate(self).disposed(by: disposedBag)
//
//        tableViewOutput?.reportBottomData?.drive { list in
//            list.bind(to: self.statisticsPerformTableView.rx.items(cellIdentifier: "StatisticsPerformRateCell", cellType: StatisticsPerformRateCell.self)) { index, item, cell in
//                if index == 0 {
//                    cell.titleLbl.text = "전체 수행"
//                    cell.dataLbl.text = "\(item.days ?? 0)"
//                    cell.suffixLbl.text = "일"
//                } else if index == 1 {
//                    cell.titleLbl.text = "일부 수행"
//                    cell.dataLbl.text = "\(item.days ?? 0)"
//                    cell.suffixLbl.text = "일"
//                } else if index == 2 {
//                    cell.titleLbl.text = "습관 수행"
//                    cell.dataLbl.text = "\(item.days ?? 0)"
//                    cell.suffixLbl.text = "일"
//                } else if index == 3 {
//                    cell.titleLbl.text = "할일 수행"
//                    cell.dataLbl.text = "\(item.days ?? 0)"
//                    cell.suffixLbl.text = "일"
//                } else if index == 4 {
//                    cell.titleLbl.text = "회고 작성"
//                    cell.dataLbl.text = "\(item.count ?? 0)"
//                    cell.suffixLbl.text = "번"
//                } else {
//                    cell.titleLbl.text = "평균 수행률"
//                    cell.dataLbl.text = "\(item.percent ?? 0)"
//                    cell.suffixLbl.text = "%"
//                }
//                cell.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
//            }
//        }.disposed(by: disposedBag)
//        statisticsPerformTableView.rx.setDelegate(self).disposed(by: disposedBag)
//
//        // 통계 이전달 다음달
//        guard let viewModel = self.viewModel else { return }
//        let output = viewModel.transform(input: input)
//        output.statisticsPrev.drive(onNext: {
//            let data = viewModel.statisticsPrevMonth(month: self.statisticsMonth!, year: self.statisticsYear!)
//            self.statisticsDateLbl.text = data[0]
//            self.statisticsMonth = Int(data[1])
//            self.statisticsYear = Int(data[2])
//        }).disposed(by: disposedBag)
//        output.statisticsNext.drive(onNext: {
//            let data = viewModel.statisticsNextMonth(month: self.statisticsMonth!, year: self.statisticsYear!)
//            self.statisticsDateLbl.text = data[0]
//            self.statisticsMonth = Int(data[1])
//            self.statisticsYear = Int(data[2])
//        }).disposed(by: disposedBag)
//
//        output.awardTap.drive(onNext: {
//            let mainvc = MainContainerView(viewModel: MainContainerViewModel(), navigator: self.navigator)
//            mainvc.setReportCardView()
//            let vc = self.navigator.get(seque: .awardViewModel(viewModel: AwardViewModel()))
//            let navController = UINavigationController(rootViewController: vc!)
//            navController.modalPresentationStyle = .overFullScreen
//            navController.modalTransitionStyle = .crossDissolve
//            navController.setNavigationBarHidden(true, animated: false)
//            self.present(navController, animated: true, completion: nil)
//        }).disposed(by: disposedBag)
//    }
//    // MARK: - Action
//    func action() {
//        calendarBtn.rx.tap.bind {
//            self.calendarBtn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
//            self.calendarBtn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
//            self.statisticsBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
//            self.statisticsBtn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
//            self.calendarUnderLine.isHidden = false
//            self.statisticsUnderLine.isHidden = true
//            self.hidestatistics()
//        }.disposed(by: disposedBag)
//        statisticsBtn.rx.tap.bind {
//            self.statisticsBtn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
//            self.statisticsBtn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
//            self.calendarBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
//            self.calendarBtn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
//            self.calendarUnderLine.isHidden = true
//            self.statisticsUnderLine.isHidden = false
//            self.hideCalendar()
//        }.disposed(by: disposedBag)
//
//    }
//    func todoListRemakeConstraints(count: Int) {
//        todoListTableView.snp.remakeConstraints({
//            $0.top.equalTo(calendarDivider.snp.bottom)
//            $0.leading.equalTo(calendarScrollView.snp.leading)
//            $0.trailing.equalTo(calendarScrollView.snp.trailing)
//            $0.bottom.equalTo(calendarScrollView.snp.bottom)
//            $0.height.equalTo(60 * (count + 1))
//        })
//    }
//
//    func hideCalendar() {
//        self.calendarScrollView.isHidden = true
//        self.statisticsScrollView.isHidden = false
//    }
//    func hidestatistics() {
//        self.calendarScrollView.isHidden = false
//        self.statisticsScrollView.isHidden = true
//    }
//}

extension GradeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 48
        } else if tableView.tag == 2 {
            return 48
        } else {
            return 60
        }
    }
}
