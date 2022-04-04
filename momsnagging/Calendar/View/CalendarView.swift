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
        layoutSetting()
        bind()
    }
    // MARK: - Properties & Variable
//    var viewModel = CalendarViewModel()
    var weekDay: [String]?
    var daylist: [String]?
    var weekdayList: [Int]?
    // MARK: - UI Properties
    lazy var weekDayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weekDayCellLayout())
        collectionView.register(CalendarWeekDayCell.self, forCellWithReuseIdentifier: "CalendarWeekDayCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 0
        return collectionView
    }()
    
    func weekDayCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 7, height: 50)
        return layout
    }
    lazy var dayCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 1
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    func dayDayCellLayout() -> UICollectionViewFlowLayout {
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
    
    lazy var weekCalendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dayDayCellLayout())
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 2
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - InitUI
    func initUI() {
        weekDay = viewModel.weekDayList()
        daylist = viewModel.dayList()
        weekdayList = viewModel.getWeekCalendarData()
    }
    // MARK: - Layout Setting
    func layoutSetting() {
        view.addSubview(weekDayCollectionView)
        view.addSubview(dayCollectionView)
        view.addSubview(weekLabel)
        view.addSubview(weekCalendarCollectionView)
        weekDayCollectionView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(50)
        })
        dayCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekDayCollectionView.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(85 * viewModel.rowCount())
        })
        weekLabel.snp.makeConstraints({
            $0.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(20)
        })
        weekCalendarCollectionView.snp.makeConstraints({
            $0.top.equalTo(weekLabel.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        
    }
    // MARK: - Bind
    func bind() {
        
    }
    // MARK: - Other
}
// MARK: - Action
extension CalendarView {
}

// MARK: - UICollectionView Delegate, Datasource
extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return weekDay?.count ?? 0
        } else if collectionView.tag == 1 {
            return daylist?.count ?? 0
        } else {
            return weekdayList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarWeekDayCell", for: indexPath) as? CalendarWeekDayCell else {
                fatalError()
            }
            let row = weekDay?[indexPath.row]
            cell.dayWeekLabel.text = row
            return cell
        } else if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as? CalendarDayCell else {
                fatalError()
            }
            let row = daylist?[indexPath.row]
            if row == "" {
                cell.emoji.isHidden = true
            } else {
                cell.number.text = row
                cell.emoji.isHidden = false
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as? CalendarDayCell else {
                fatalError()
            }
            let row = weekdayList?[indexPath.row]
            cell.number.text = "\(row ?? 0)"
            cell.emoji.isHidden = false
            return cell
        }
    }
}
