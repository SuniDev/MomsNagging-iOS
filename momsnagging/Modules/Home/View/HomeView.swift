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

class HomeView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: HomeViewModel!
    var calendarViewModel = CalendarViewModel()
    var disposedBag = DisposeBag()
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var selectDayIndex: Int?
    // MARK: - UI Properties
    var listBtn = UIButton()
    var headTitleLbl = UILabel()
    var headDropDownBtn = UIButton()
    var diaryBtn = UIButton()
    var headFrame = UIView()
    
    var weekCalendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(WeekDayCalendarCell.self, forCellWithReuseIdentifier: "WeekDayCalendarCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        return collectionView
    }()
    
    static func dayDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 21 - (10 * 6)) / 7, height: 56)
        return layout
    }
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headTitleLbl.text = calendarViewModel.todayFormatteryyMMdd()
        headFrame = CommonView.homeHeadFrame(listIconBtn: listBtn, headTitle: headTitleLbl, dropDownButton: headDropDownBtn, diaryBtn: diaryBtn)
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
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
    }
    // MARK: - Bind _ Output
    override func bind() {
        calendarViewModel.weekDayListObservable // 주달력 데이터 [String]
            .bind(to: self.weekCalendarCollectionView.rx.items(cellIdentifier: "WeekDayCalendarCell", cellType: WeekDayCalendarCell.self)) { index, item, cell in
                cell.weekDayLbl.text = self.calendarViewModel.getWeekDayList()[index]
                cell.numberLbl.text = "\(item)"
                if "\(item)" == self.calendarViewModel.todaydd() {
                    cell.isToday = true
                } else {
                    cell.isToday = false
                }
            }.disposed(by: disposedBag)
        calendarViewModel.monthObservable.subscribe { self.month = $0 }.disposed(by: disposedBag)
        calendarViewModel.yearObservable.subscribe { self.year = $0 }.disposed(by: disposedBag)
        calendarViewModel.weekDayList(currentMonth: month, currentYear: year)
        
        weekCalendarCollectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            for i in 0..<7 {
                let cell = self.weekCalendarCollectionView.cellForItem(at: [0, i]) as? WeekDayCalendarCell
                if i == indexPath.row {
                    cell?.selectDayRoundFrame.isHidden = false
                } else {
                    cell?.selectDayRoundFrame.isHidden = true
                }
            }
        }).disposed(by: disposedBag)
    }
    
    // MARK: - Action Bind _ Input
    // MARK: - Other
    
}
