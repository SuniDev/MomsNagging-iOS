//
//  CalendarView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

class CalendarView: UIViewController {
    
    let viewModel: CalendarViewModel!
    let navigator: Navigator!
    
    init(viewModel: CalendarViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bind()
        actionBind()
        layoutSetting()
    }
    // MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var monthCollectionViewHeight: Int?
    // MARK: - UI Properties
    var scrollView = UIScrollView().then({
        $0.showsVerticalScrollIndicator = false
    })
    var backgroundFrame = UIView().then({
        $0.backgroundColor = .black
    })
    var yearLabel = UILabel().then({
        $0.textColor = Asset.white.color
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
    })
    var monthLabel = UILabel().then({
        $0.textColor = Asset.white.color
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
    })
    var btnPrev = UIButton().then({
        $0.setTitle("<", for: .normal)
        $0.setTitleColor(Asset.white.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    })
    var btnNext = UIButton().then({
        $0.setTitle(">", for: .normal)
        $0.setTitleColor(Asset.white.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    })
    var weekDayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekDayCellLayout())
        collectionView.register(CalendarWeekDayCell.self, forCellWithReuseIdentifier: "CalendarWeekDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 0
        return collectionView
    }()
    
    static func weekDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 7, height: 50)
        return layout
    }
    
    var dayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 1
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    static func dayDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 7, height: 80)
        return layout
    }
    
    let weekLabel = UILabel().then({
        $0.text = "주간달력"
        $0.textColor = .white
    })
    
    var weekCalendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 2
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - InitUI
    func initUI() {
    }
    // MARK: - Layout Setting
    func layoutSetting() {
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundFrame)
        backgroundFrame.addSubview(yearLabel)
        backgroundFrame.addSubview(monthLabel)
        backgroundFrame.addSubview(btnPrev)
        backgroundFrame.addSubview(btnNext)
        backgroundFrame.addSubview(weekDayCollectionView)
        backgroundFrame.addSubview(dayCollectionView)
        backgroundFrame.addSubview(weekLabel)
        backgroundFrame.addSubview(weekCalendarCollectionView)
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        yearLabel.snp.makeConstraints({
            $0.top.equalTo(backgroundFrame.snp.top).offset(20)
            $0.centerX.equalTo(backgroundFrame.snp.centerX)
        })
        monthLabel.snp.makeConstraints({
            $0.centerX.equalTo(backgroundFrame.snp.centerX)
            $0.top.equalTo(yearLabel.snp.bottom).offset(10)
        })
        btnPrev.snp.makeConstraints({
            $0.centerY.equalTo(monthLabel.snp.centerY)
            $0.trailing.equalTo(monthLabel.snp.leading).offset(-24)
            $0.width.height.equalTo(30)
        })
        btnNext.snp.makeConstraints({
            $0.centerY.equalTo(monthLabel.snp.centerY)
            $0.leading.equalTo(monthLabel.snp.trailing).offset(24)
            $0.width.height.equalTo(30)
        })
        weekDayCollectionView.snp.makeConstraints({
            $0.top.equalTo(monthLabel.snp.bottom).offset(24)
            $0.leading.equalTo(backgroundFrame.snp.leading)
            $0.trailing.equalTo(backgroundFrame.snp.trailing)
            $0.height.equalTo(50)
        })
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom)
            $0.leading.equalTo(backgroundFrame.snp.leading)
            $0.trailing.equalTo(backgroundFrame.snp.trailing)
            $0.height.equalTo(85 * monthCollectionViewHeight!)
        })
        weekLabel.snp.makeConstraints({
            $0.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(20)
        })
        weekCalendarCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekLabel.snp.bottom)
            $0.leading.equalTo(backgroundFrame.snp.leading)
            $0.trailing.equalTo(backgroundFrame.snp.trailing)
            $0.height.equalTo(85)
            $0.bottom.equalTo(backgroundFrame.snp.bottom).offset(-100)
        })
        
    }
    // MARK: - Bind
    func bind() {
        // MARK: - Output
        viewModel.weekDay // 월~ 일
            .bind(to: self.weekDayCollectionView.rx.items(cellIdentifier: "CalendarWeekDayCell", cellType: CalendarWeekDayCell.self)) { _, item, cell in
                cell.dayWeekLabel.text = item
            }.disposed(by: disposedBag)
        viewModel.daylist // 월 달력 데이터 [String]
            .bind(to: self.dayCollectionView.rx.items(cellIdentifier: "CalendarDayCell", cellType: CalendarDayCell.self)) { _, item, cell in
                if item == "emptyCell" {
                    cell.emoji.isHidden = true
                    cell.number.isHidden = false
                    cell.number.text = ""
                } else {
                    cell.emoji.isHidden = false
                    cell.number.isHidden = false
                    cell.number.text = item
                }
            }.disposed(by: disposedBag)
        viewModel.weekDayListObservable // 주달력 데이터 [String]
            .bind(to: self.weekCalendarCollectionView.rx.items(cellIdentifier: "CalendarDayCell", cellType: CalendarDayCell.self)) { _, item, cell in
                cell.number.text = "\(item)"
            }.disposed(by: disposedBag)
        viewModel.monthObservable.subscribe { self.monthLabel.text = "\($0.element ?? 0)" }.disposed(by: disposedBag)
        viewModel.yearObservable.subscribe { self.yearLabel.text = "\($0.element ?? 0)" }.disposed(by: disposedBag)
        viewModel.weekDayList(currentMonth: Int(self.monthLabel.text!)!, currentYear: Int(self.yearLabel.text!)!)
        monthCollectionViewHeight = viewModel.rowCount(currentMonth: Int(self.monthLabel.text!)!, currentYear: Int(self.yearLabel.text!)!)
        viewModel.collectionViewHeight.subscribe { self.dayCollectionViewRemakeConstraint(count: $0) }.disposed(by: disposedBag)
    }
    // MARK: - Action Bind
    func actionBind() {
        // MARK: - Intput
        self.btnNext.rx.tap.bind {
            self.viewModel.getNextMonth(currentMonth: Int(self.monthLabel.text!)!, currentYear: Int(self.yearLabel.text!)!)
        }.disposed(by: disposedBag)
        self.btnPrev.rx.tap.bind {
            self.viewModel.getLastMonth(currentMonth: Int(self.monthLabel.text!)!, currentYear: Int(self.yearLabel.text!)!)
        }.disposed(by: disposedBag)
    }
    // MARK: - Other
    func dayCollectionViewRemakeConstraint(count: Int) {
        dayCollectionView.snp.remakeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom)
            $0.leading.equalTo(backgroundFrame.snp.leading)
            $0.trailing.equalTo(backgroundFrame.snp.trailing)
            $0.height.equalTo(85 * count)
        })
    }
}
extension CalendarView {
    
}
