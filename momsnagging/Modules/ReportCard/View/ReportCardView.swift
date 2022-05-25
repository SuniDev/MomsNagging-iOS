//
//  ReportCardView.swift
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

class ReportCardView: BaseViewController, Navigatable, UIScrollViewDelegate {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        action()
        todoBind()
        statisticsBind()
        statisticsLayout()
    }
    // MARK: - Temp
    // MARK: - Init
    init(viewModel: ReportCardViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: ReportCardViewModel!
    var disposedBag = DisposeBag()
    var calendarViewModel = CalendarViewModel()
    var tableViewOutput: ReportCardViewModel.Output?
    var statisticsInput = PublishSubject<ReportCardViewModel.Input>()
    var statisticsOutput: ReportCardViewModel.Output?
    var todoList: [TodoListModel] = []
    
    var calendarYear: Int?
    var calendarMonth: Int?
    var calendarDay: Int?
    
    var statisticsYear: Int?
    var statisticsMonth: Int?
    var statisticsPrev: Bool? //이전달(true)로가는지 다음달(false)로가는지 체크
    
    var monthCollectionViewHeight: Int? // 월별로 주(4주~6주)수를 카운팅하여 CollectionView의 높이를 remake하기 위함.
    var dateCheck: Int = 0 // 현재월 (0)로부터 다음달(1) 이전달 (-1)로 더하거나 빼는 변수
    var calendarSelectIndex: Int? // 월간달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    var selectMonth: Int = 0 // 현재 월(0) 인지 확인 하는 변수
    var selectDate: String = ""
    // MARK: - UI Properties
    var noneBtn = UIButton()
    var awardBtn = UIButton()
    var headFrame = UIView()
    var calendarBtn = UIButton().then({
        $0.isSelected = true
        $0.setTitle("달력", for: .normal)
    })
    var calendarUnderLine = UIView()
    var calendarTab = UIView()
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
    var calendarFrame = UIView()
    var calendarView = UIView().then({
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
    var calendarDivider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight020)
    })
    /// 월간달력의 월~ 일 컬렉션뷰
    var weekDayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekDayCellLayout())
        collectionView.register(ReportWeekDayCell.self, forCellWithReuseIdentifier: "ReportWeekDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 컬렉션뷰
    var dayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(ReportCardCell.self, forCellWithReuseIdentifier: "ReportCardCell")
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
        $0.register(ReportCardTodoCell.self, forCellReuseIdentifier: "ReportCardTodoCell")
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
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: noneBtn, headTitle: "성적표", rightIcBtn: awardBtn)
        noneBtn.setImage(nil, for: .normal)
        awardBtn.setImage(UIImage(asset: Asset.Icon.medal), for: .normal)
        calendarTab = tabView(btn: calendarBtn, underLine: calendarUnderLine)
        statisticsTab = tabView(btn: statisticsBtn, underLine: statisticsUnderLine)
        
        calendarYear = calendarViewModel.getYear()
        calendarMonth = calendarViewModel.getMonth()
        calendarDay = calendarViewModel.getToday()
        calendarDateLbl.text = "\(calendarYear ?? 0)년 \(calendarMonth ?? 0)월"
        monthCollectionViewHeight = 7
        calendarFrame = reportCardCalendarView()
        
        statisticsYear = calendarViewModel.getYear()
        statisticsMonth = calendarViewModel.getMonth()
        statisticsDateLbl.text = "\(calendarViewModel.getYear())년 \(calendarViewModel.getMonth())월"
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(divider)
        view.addSubview(calendarTab)
        view.addSubview(statisticsTab)
        view.addSubview(calendarScrollView)
        calendarScrollView.addSubview(calendarFrame)
        calendarScrollView.addSubview(calendarDivider)
        calendarScrollView.addSubview(todoListTableView)
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
        calendarScrollView.snp.makeConstraints({
            $0.top.equalTo(divider.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        calendarFrame.snp.makeConstraints({
            $0.top.equalTo(calendarScrollView.snp.top)
            $0.leading.equalTo(calendarScrollView.snp.leading)
            $0.trailing.equalTo(calendarScrollView.snp.trailing)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(508)
        })
        calendarDivider.snp.makeConstraints({
            $0.top.equalTo(calendarFrame.snp.bottom)
            $0.leading.equalTo(calendarScrollView.snp.leading)
            $0.trailing.equalTo(calendarScrollView.snp.trailing)
            $0.height.equalTo(2)
        })
        todoListTableView.snp.makeConstraints({
            $0.top.equalTo(calendarDivider.snp.bottom)
            $0.leading.equalTo(calendarScrollView.snp.leading)
            $0.trailing.equalTo(calendarScrollView.snp.trailing)
            $0.height.equalTo(120)
        })
    }
    func statisticsLayout() {
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
        
    }
    // MARK: - Bind
    override func bind() {
        calendarViewModel.monthObservable.subscribe( onNext: { [weak self] in
            self?.calendarMonth = $0
            self?.calendarDateLbl.text = "\(self?.calendarYear ?? 0)년 \($0)월"
        }).disposed(by: disposedBag)
        calendarViewModel.yearObservable.subscribe( onNext: { [weak self] in
            self?.calendarYear = $0
            self?.calendarDateLbl.text = "\($0)년 \(self?.calendarMonth ?? 0)월"
        }).disposed(by: disposedBag)
        calendarViewModel.weekDay // 월 ~ 일
            .bind(to: self.weekDayCollectionView.rx.items(cellIdentifier: "ReportWeekDayCell", cellType: ReportWeekDayCell.self)) { index, item, cell in
                if (index % 7) == 6 {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.error)
                } else {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.monoDark010)
                }
                cell.dayWeekLabel.text = item
            }.disposed(by: disposedBag)
        
        calendarViewModel.collectionViewHeight.subscribe { self.dayCollectionViewRemakeConstraint(count: $0) }.disposed(by: disposedBag)
        
        calendarViewModel.daylist // 월 달력 데이터 [String]
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "ReportCardCell", cellType: ReportCardCell.self)) { index, item, cell in
                if item == "emptyCell" {
                    cell.number.isHidden = false
                    cell.number.text = ""
                    cell.ic.isHidden = true
                    cell.isUserInteractionEnabled = false
                } else {
                    cell.number.isHidden = false
                    cell.number.text = item
                    cell.ic.isHidden = false
                    cell.isUserInteractionEnabled = true
                }
                if self.dateCheck == 0 && (("\(item)" == self.calendarViewModel.todaydd()) || "0\(item)" == self.calendarViewModel.todaydd()) {
                    cell.isToday = true
                    if (index % 7) == 6 {
                        cell.number.textColor = UIColor(asset: Asset.Color.error)
                    } else {
                        cell.number.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                } else {
                    cell.isToday = false
                    if (index % 7) == 6 {
                        cell.number.textColor = UIColor(asset: Asset.Color.error)
                    } else {
                        cell.number.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                }
                cell.layoutIfNeeded()
            }.disposed(by: disposedBag)
        
        dayCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.calendarSelectIndex = indexPath.row
            let cell = self.dayCollectionView.cellForItem(at: [0, indexPath.row]) as? ReportCardCell
            var day: String = cell?.number.text ?? ""
            var month: String = "\(self.calendarMonth ?? 0)"
            if Int(day)! < 10 {
                day = "0\(day)"
            }
            if self.calendarMonth ?? 0 < 10 {
                month = "0\(self.calendarMonth ?? 0)"
            }
            self.selectDate = "\(self.calendarYear ?? 0)\(month)\(day)"
            self.selectMonth = self.dateCheck
        }).disposed(by: disposedBag)
    }
    func todoBind() {
        guard let viewModel = viewModel else { return }
        let input = ReportCardViewModel.Input(tabAction: nil, statisticsPrev: self.statisticsPrevBtn.rx.tap.asDriverOnErrorJustComplete(), statisticsNext: self.statisticsNextBtn.rx.tap.asDriverOnErrorJustComplete(), currentMonth: self.statisticsMonth!, currentYear: self.statisticsYear!, awardTap: self.awardBtn.rx.tap.asDriverOnErrorJustComplete())
        tableViewOutput = viewModel.transform(input: input)
        tableViewOutput?.todoListData?.drive { list in
            list.bind(to: self.todoListTableView.rx.items(cellIdentifier: "ReportCardTodoCell", cellType: ReportCardTodoCell.self)) { index, item, cell in
//                self.todoList.append(item)
//                cell.todoIsSelected = item.isSelected ?? false
//                cell.timeBtn.setTitle(item.time ?? "", for: .normal)
//                cell.titleLbl.text = item.title ?? ""
//                cell.prefixLbl.text = item.prefix ?? ""
//                cell.cellType = item.type ?? .normal
//                if item.isSelected ?? false {
//                    cell.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
//                    cell.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
//                    cell.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
//                    cell.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
//                } else {
//                    cell.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
//                    cell.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
//                    cell.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
//                    cell.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
//                }
                self.todoListRemakeConstraints(count: index + 1)
            }
        }.disposed(by: disposedBag)
        todoListTableView.rx.setDelegate(self).disposed(by: disposedBag)
        tableViewOutput?.cellItemCount.subscribe(onNext: { count in
            print("itemCellCount!: \(count)")
        }).disposed(by: disposedBag)
        
    }
    func statisticsBind() {
        guard let viewModel = viewModel else { return }
        let input = ReportCardViewModel.Input(tabAction: nil, statisticsPrev: self.statisticsPrevBtn.rx.tap.asDriverOnErrorJustComplete(), statisticsNext: self.statisticsNextBtn.rx.tap.asDriverOnErrorJustComplete(), currentMonth: self.statisticsMonth!, currentYear: self.statisticsYear!, awardTap: self.awardBtn.rx.tap.asDriverOnErrorJustComplete())
        tableViewOutput = viewModel.transform(input: input)
        tableViewOutput?.reportListData?.drive { list in
            list.bind(to: self.statisticsRatingTableView.rx.items(cellIdentifier: "StatisticsCalendarCell", cellType: StatisticsCalendarCell.self)) { _, item, cell in
                cell.weekLbl.text = "첫째주"
                cell.reportLbl.text = item.rating ?? ""
            }
        }.disposed(by: disposedBag)
        statisticsRatingTableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        tableViewOutput?.reportBottomData?.drive { list in
            list.bind(to: self.statisticsPerformTableView.rx.items(cellIdentifier: "StatisticsPerformRateCell", cellType: StatisticsPerformRateCell.self)) { index, item, cell in
                if index == 0 {
                    cell.titleLbl.text = "전체 수행"
                    cell.dataLbl.text = "\(item.days ?? 0)"
                    cell.suffixLbl.text = "일"
                } else if index == 1 {
                    cell.titleLbl.text = "일부 수행"
                    cell.dataLbl.text = "\(item.days ?? 0)"
                    cell.suffixLbl.text = "일"
                } else if index == 2 {
                    cell.titleLbl.text = "습관 수행"
                    cell.dataLbl.text = "\(item.days ?? 0)"
                    cell.suffixLbl.text = "일"
                } else if index == 3 {
                    cell.titleLbl.text = "할일 수행"
                    cell.dataLbl.text = "\(item.days ?? 0)"
                    cell.suffixLbl.text = "일"
                } else if index == 4 {
                    cell.titleLbl.text = "회고 작성"
                    cell.dataLbl.text = "\(item.count ?? 0)"
                    cell.suffixLbl.text = "번"
                } else {
                    cell.titleLbl.text = "평균 수행률"
                    cell.dataLbl.text = "\(item.percent ?? 0)"
                    cell.suffixLbl.text = "%"
                }
                cell.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
            }
        }.disposed(by: disposedBag)
        statisticsPerformTableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        // 통계 이전달 다음달
        guard let viewModel = self.viewModel else { return }
        let output = viewModel.transform(input: input)
        output.statisticsPrev.drive(onNext: {
            let data = viewModel.statisticsPrevMonth(month: self.statisticsMonth!, year: self.statisticsYear!)
            self.statisticsDateLbl.text = data[0]
            self.statisticsMonth = Int(data[1])
            self.statisticsYear = Int(data[2])
        }).disposed(by: disposedBag)
        output.statisticsNext.drive(onNext: {
            let data = viewModel.statisticsNextMonth(month: self.statisticsMonth!, year: self.statisticsYear!)
            self.statisticsDateLbl.text = data[0]
            self.statisticsMonth = Int(data[1])
            self.statisticsYear = Int(data[2])
        }).disposed(by: disposedBag)
        
        output.awardTap.drive(onNext: {
            let mainvc = MainContainerView(viewModel: MainContainerViewModel(), navigator: self.navigator)
            mainvc.setReportCardView()
            let vc = self.navigator.get(seque: .awardViewModel(viewModel: AwardViewModel()))
            let navController = UINavigationController(rootViewController: vc!)
            navController.modalPresentationStyle = .overFullScreen
            navController.modalTransitionStyle = .crossDissolve
            navController.setNavigationBarHidden(true, animated: false)
            self.present(navController, animated: true, completion: nil)
        }).disposed(by: disposedBag)
    }
    // MARK: - Action
    func action() {
        calendarBtn.rx.tap.bind {
            self.calendarBtn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
            self.calendarBtn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
            self.statisticsBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
            self.statisticsBtn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
            self.calendarUnderLine.isHidden = false
            self.statisticsUnderLine.isHidden = true
            self.hidestatistics()
        }.disposed(by: disposedBag)
        statisticsBtn.rx.tap.bind {
            self.statisticsBtn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
            self.statisticsBtn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
            self.calendarBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
            self.calendarBtn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
            self.calendarUnderLine.isHidden = true
            self.statisticsUnderLine.isHidden = false
            self.hideCalendar()
        }.disposed(by: disposedBag)
        
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
        
    }
    // MARK: - Other
    
    func dayCollectionViewRemakeConstraint(count: Int) {
        dayCollectionView.snp.remakeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(16)
            $0.leading.equalTo(calendarView.snp.leading).offset(16)
            $0.trailing.equalTo(calendarView.snp.trailing).offset(-16)
            $0.height.equalTo(508)
        })
    }
    
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
    
    func reportCardCalendarView() -> UIView {
        let view = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        })
        view.addSubview(calendarView)
        calendarView.addSubview(btnPrev)
        calendarView.addSubview(btnNext)
        calendarView.addSubview(calendarDateLbl)
        calendarView.addSubview(weekDayCollectionView)
        calendarView.addSubview(dayCollectionView)
        calendarView.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(508)
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
        weekDayCollectionView.snp.makeConstraints({
            $0.top.equalTo(calendarDateLbl.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(12)
        })
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(16)
            $0.leading.equalTo(calendarView.snp.leading).offset(16)
            $0.trailing.equalTo(calendarView.snp.trailing).offset(-16)
            $0.height.equalTo(508)
        })
        
        return view
    }
    
    func todoListRemakeConstraints(count: Int) {
        todoListTableView.snp.remakeConstraints({
            $0.top.equalTo(calendarDivider.snp.bottom)
            $0.leading.equalTo(calendarScrollView.snp.leading)
            $0.trailing.equalTo(calendarScrollView.snp.trailing)
            $0.bottom.equalTo(calendarScrollView.snp.bottom)
            $0.height.equalTo(60 * (count + 1))
        })
    }
    
    func hideCalendar() {
        self.calendarScrollView.isHidden = true
        self.statisticsScrollView.isHidden = false
    }
    func hidestatistics() {
        self.calendarScrollView.isHidden = false
        self.statisticsScrollView.isHidden = true
    }
}

extension ReportCardView: UITableViewDelegate {
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
