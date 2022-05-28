//
//  DiaryView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/06.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class DiaryView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Init
    init(viewModel: DiaryViewModel, navigator: Navigator) {
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
    var viewModel: DiaryViewModel!
    var calendarViewModel = CalendarViewModel()
    var disposedBag = DisposeBag()
    /*
     prefix : calendar
     Year, Month, Day 월간달력의 Lbl에 표시하기 위한 날짜 연, 월, 일
     */
//    var calendarYear: Int?
//    var calendarMonth: Int?
//    var calendarDay: Int?
    
    var monthCollectionViewHeight: Int? // 월별로 주(4주~6주)수를 카운팅하여 CollectionView의 높이를 remake하기 위함.
    var dateCheck: Int = 0 // 현재월 (0)로부터 다음달(1) 이전달 (-1)로 더하거나 빼는 변수
    var calendarSelectIndex: Int? // 월간달력의 현재 월의 선택된 셀의 인덱스.row값으로 선택된 날짜에 둥근원 표시를 위함
    var selectMonth: Int = 0 // 현재 월(0) 인지 확인 하는 변수
    
    // MARK: - UI Properties
    var backBtn = UIButton()
    var writeBtn = UIButton()
    var headFrame = UIView()
    
    var scrollView = UIScrollView()
    var backgroundFrame = UIView() // scrollView 안에 넣어 오토레이아웃 설정을 편하게 하기 위해 추가합니다
    
    var calendarFrame = UIView()
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
        collectionView.register(DiaryCalendarCell.self, forCellWithReuseIdentifier: "DiaryCalendarCell")
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
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40 - (9 * 6)) / 7, height: 12
        )
        return layout
    }
    /// 월간 달력의 일(1 ~ 28,29,30,31)에 해당하는 셀 레이아웃
    static func dayDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 22
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40 - (9 * 6)) / 7, height: 40)
        return layout
    }
    
    // 하단의 오늘의 일기 부분
    var todayDiaryTitleLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.text = "오늘의 일기 (날짜로 변경) "
    })
    var diaryDeleteBtn = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.delete), for: .normal)
    })
    var emptyDiaryFrame = UIView()
    var diaryFrame = UIView()
    var diaryTitleLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.text = "DiaryTitle"
    })
    var diaryContentsLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark030)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.text = "DiaryContents"
    })
    
    // MARK: - initUI
    override func initUI() {
        // 헤더
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "일기장", rightIcBtn: writeBtn)
        
        // Colleciton View
        monthCollectionViewHeight = 6
        calendarFrame.backgroundColor = .red
        emptyDiaryFrame = emptyFrameView()
        diaryFrame = diaryFrameView()
    }
    // MARK: - Layout Setting
    override func layoutSetting() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        view.addSubview(headFrame)
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundFrame)
        scrollView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        backgroundFrame.snp.makeConstraints({
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
        })
        
        backgroundFrame.addSubview(btnPrev)
        backgroundFrame.addSubview(btnNext)
        backgroundFrame.addSubview(calendarDateLbl)
        backgroundFrame.addSubview(weekDayCollectionView)
        backgroundFrame.addSubview(dayCollectionView)
        
        calendarDateLbl.snp.makeConstraints({
            $0.centerX.equalTo(backgroundFrame.snp.centerX)
            $0.top.equalTo(backgroundFrame.snp.top).offset(24)
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
            $0.top.equalTo(calendarDateLbl.snp.bottom).offset(28)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(20)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-20)
            $0.height.equalTo(12)
        })
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom).offset(22)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(20)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-20)
            $0.height.equalTo(63 * monthCollectionViewHeight!)
        })
        backgroundFrame.addSubview(todayDiaryTitleLbl)
        backgroundFrame.addSubview(diaryDeleteBtn)
//        backgroundFrame.addSubview(emptyDiaryFrame)
        backgroundFrame.addSubview(diaryFrame)
        todayDiaryTitleLbl.snp.makeConstraints({
            $0.top.equalTo(dayCollectionView.snp.bottom).offset(48)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(20)
            $0.trailing.equalTo(backgroundFrame.snp.centerX).offset(10)
        })
        diaryDeleteBtn.snp.makeConstraints({
            $0.width.height.equalTo(20)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(24)
            $0.centerY.equalTo(todayDiaryTitleLbl.snp.centerY).offset(1)
        })
//        emptyDiaryFrame.snp.makeConstraints({
//            $0.top.equalTo(todayDiaryTitleLbl.snp.bottom).offset(14)
//            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
//            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
//            $0.bottom.equalTo(backgroundFrame.snp.bottom).offset(-20)
//            $0.height.equalTo(172)
//        })
        diaryFrame.snp.makeConstraints({
            $0.top.equalTo(todayDiaryTitleLbl.snp.bottom).offset(14)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
            $0.bottom.equalTo(backgroundFrame.snp.bottom).offset(-20)
            $0.height.equalTo(172)
        })
    }
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
                
        let input = DiaryViewModel.Input(
            btnBackTapped: self.backBtn.rx.tap.asDriverOnErrorJustComplete(),
            loadCalendar: Observable.just(CalendarDate(year: self.calendarViewModel.getYear(),
                                                       month: self.calendarViewModel.getMonth(),
                                                       day: self.calendarViewModel.getToday())).asDriverOnErrorJustComplete(),
            setCalendarMonth: self.calendarViewModel.monthObservable.asDriverOnErrorJustComplete(),
            setCalendarYear: self.calendarViewModel.yearObservable.asDriverOnErrorJustComplete(),
            loadDayList: self.calendarViewModel.daylist.asDriverOnErrorJustComplete(),
            dayItemSelected: self.dayCollectionView.rx.itemSelected.asDriverOnErrorJustComplete(),
            btnPrevTapped: self.btnPrev.rx.tap.mapToVoid().asDriverOnErrorJustComplete(),
            btnNextTapped: self.btnNext.rx.tap.mapToVoid().asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.setCalendarDate
            .drive(onNext: { date in
                self.calendarDateLbl.text = "\(date.year)년 \(date.month)월"
            }).disposed(by: disposedBag)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposedBag)
        
        output.dayItemSelected
            .drive(onNext: { indexPath in
//                self.calendarSelectIndex = indexPath.row
//                for i in 0..<37 {
//                    let cell = self.dayCollectionView.cellForItem(at: [0, i]) as? DiaryCalendarCell
//                    if i == indexPath.row {
//                        cell?.selectDayRoundFrame.isHidden = false
//                    } else {
//                        cell?.selectDayRoundFrame.isHidden = true
//                    }
//                }
//                self.selectMonth = self.dateCheck
            }).disposed(by: disposedBag)
        
        output.dayItems
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "DiaryCalendarCell", cellType: DiaryCalendarCell.self)) { index, item, cell in
                cell.number.text = item.strDay
                cell.isToday = item.isToday
                cell.isSunday = (index % 7) == 6
                cell.isWroteDiary = item.day?.diaryExists ?? false
                cell.isEnabled = item.isThisMonth
                cell.configure()
            }.disposed(by: disposedBag)
        
        output.setLastMonth
            .drive(onNext: { date in
                self.calendarViewModel.getLastMonth(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposedBag)
        
        output.setNextMonth
            .drive(onNext: { date in
                self.calendarViewModel.getNextMonth(currentMonth: date.month, currentYear: date.year)
            }).disposed(by: disposedBag)
        
        self.bindCalendar()
    }
    
    // MARK: - Action
    func action() {
        // 작성하기, 수정하기 액션
        writeBtn.rx.tap.bind {
//            self.navigator.show(seque: .detailDiary(viewModel: DetailDiaryViewModel(withService: AppServices(authService: AuthService()), isNew: true)), sender: self, transition: .navigation)
        }.disposed(by: disposedBag)
    }
    
    // MARK: - CalendarViewModel bind
    func bindCalendar() {
        
        calendarViewModel.weekDay // 월 ~ 일
            .bind(to: self.weekDayCollectionView.rx.items(cellIdentifier: "CalendarWeekDayCell", cellType: CalendarWeekDayCell.self)) { index, item, cell in
                if (index % 7) == 6 {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.error)
                } else {
                    cell.dayWeekLabel.textColor = UIColor(asset: Asset.Color.monoDark010)
                }
                cell.dayWeekLabel.text = item
            }.disposed(by: disposedBag)
        
    }
}

// MARK: - 캘린더 UI
extension DiaryView {
    /**
     # emptyFrameView
     - Authors: tavi
     - returns: UIView
     - Note: 일기가 없을때 보여주는 뷰
     */
    func emptyFrameView() -> UIView {
        let view = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        })
        let ic = UIImageView().then({
            $0.image = UIImage(asset: Asset.Assets.emojiDefaultDis)
        })
        let lbl = UILabel().then({
            $0.text = "해당 날짜에 일기가 없단다"
            $0.font = FontFamily.Pretendard.regular.font(size: 16)
        })
        view.addSubview(ic)
        view.addSubview(lbl)
        ic.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(43)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(55.05)
            $0.height.equalTo(50.39)
        })
        lbl.snp.makeConstraints({
            $0.top.equalTo(ic.snp.bottom).offset(12)
            $0.centerX.equalTo(view.snp.centerX)
        })
        return view
    }
    /**
     # diaryFrameView
     - Authors: tavi
     - returns: UIView
     - Note: 일기를 보여주는 뷰
     */
    func diaryFrameView() -> UIView {
        let view = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        })
        view.addSubview(diaryTitleLbl)
        view.addSubview(diaryContentsLbl)
        diaryTitleLbl.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(8)
            $0.leading.equalTo(view.snp.leading).offset(8)
            $0.trailing.equalTo(view.snp.trailing).offset(-8)
        })
        diaryContentsLbl.snp.makeConstraints({
            $0.top.equalTo(diaryTitleLbl.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(8)
            $0.trailing.equalTo(view.snp.trailing).offset(-8)
        })
        return view
    }
}
