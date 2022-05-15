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

class ReportCardView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        action()
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
    
    var calendarYear: Int?
    var calendarMonth: Int?
    var calendarDay: Int?
    
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
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(divider)
        view.addSubview(calendarTab)
        view.addSubview(statisticsTab)
        view.addSubview(calendarScrollView)
        calendarScrollView.addSubview(calendarFrame)
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
            $0.bottom.equalTo(calendarScrollView.snp.bottom).offset(-200)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(600)
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
    // MARK: - Action
    func action() {
        calendarBtn.rx.tap.bind {
            self.calendarBtn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
            self.calendarBtn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
            self.statisticsBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
            self.statisticsBtn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
            self.calendarUnderLine.isHidden = false
            self.statisticsUnderLine.isHidden = true
        }.disposed(by: disposedBag)
        statisticsBtn.rx.tap.bind {
            self.statisticsBtn.setTitleColor(UIColor(asset: Asset.Color.priMain), for: .normal)
            self.statisticsBtn.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
            self.calendarBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark040), for: .normal)
            self.calendarBtn.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
            self.calendarUnderLine.isHidden = true
            self.statisticsUnderLine.isHidden = false
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
}
