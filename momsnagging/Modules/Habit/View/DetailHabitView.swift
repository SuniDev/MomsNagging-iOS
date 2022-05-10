//
//  DetailHabitView.swift
//  momsnagging
//
//  Created by suni on 2022/05/06.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa

class DetailHabitView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: DetailHabitViewModel?
    var navigator: Navigator!
    
    private let cycleCellSpacing: CGFloat = 10.5
    private var cycleCellHeight: CGFloat = 0.0
    private let cycleIdentifier = "CycleCell"
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    lazy var btnDone = UIButton()
    lazy var btnMore = UIButton()
    lazy var lblTitle = UILabel().then({
        $0.text = "습관 상세"
    })
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    /// 습관 이름
    lazy var detailNameFrame = UIView()
    lazy var viewNameTitle = UIView()
    lazy var viewHintTextField = UIView()
    lazy var tfName = CommonTextField().then({
        $0.placeholder = "어떤 습관 추가할래?"
        $0.returnKeyType = .done
    })
    lazy var lblHint = CommonHintLabel()
    
    /// 수행 시간
    lazy var detailPerformTimeFrame = UIView()
    lazy var btnPerformTime = UIButton()
    lazy var viewTimeTitle = UIView()
    lazy var lblTime = UILabel().then({
        $0.text = "아직 정해지지 않았단다"
        $0.textColor = Asset.Color.monoDark030.color
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    
    /// 이행 주기
    lazy var cycleFrame = UIView()
    lazy var viewCycleTitle = UIView()
    lazy var viewCycleType = UIView().then({
        $0.addBorder(color: Asset.Color.monoLight020.color, width: 1)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var btnCycleWeek = CommonButton().then({
        $0.layer.cornerRadius = 5
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.selectedBackgroundColor = Asset.Color.priLight010.color
        $0.setTitle("요일", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark030.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .selected)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.selectedFont = FontFamily.Pretendard.semiBold.font(size: 14)
        $0.isSelected = true
        
    })
    lazy var btnCycleNumber = CommonButton().then({
        $0.layer.cornerRadius = 5
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.selectedBackgroundColor = Asset.Color.priLight010.color
        $0.setTitle("N회", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark030.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .selected)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.selectedFont = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var cycleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: cycleCellLayout())
        collectionView.register(CycleCell.self, forCellWithReuseIdentifier: cycleIdentifier)
        collectionView.backgroundColor = Asset.Color.monoWhite.color
        collectionView.contentInset = .zero
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private func cycleCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cycleCellSpacing
        layout.minimumLineSpacing = .zero
        self.cycleCellHeight = (UIScreen.main.bounds.width - (cycleCellSpacing * 6) - (16 * 2)) / 7
        layout.itemSize = CGSize(width: self.cycleCellHeight, height: self.cycleCellHeight)
        return layout
    }
    
    lazy var divider = UIView()
    
    /// 잔소리 알림
    lazy var detailNaggingPushFrame = UIView()
    lazy var viewDefaultNaggingPush = UIView()
    lazy var viewTimeNaggingPush = UIView()
    lazy var lblPushTitle = UILabel().then({
        $0.text = "잔소리 알림"
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = Asset.Color.monoDark010.color
    })
    lazy var switchPush = UISwitch().then({
        $0.onTintColor = Asset.Color.priMain.color
        $0.tintColor = Asset.Color.monoDark030.color
        $0.thumbTintColor = Asset.Color.monoWhite.color
        $0.backgroundColor = Asset.Color.monoDark030.color
        $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        $0.layer.cornerRadius = $0.bounds.height / 2
    })
    lazy var viewAddPushTime = UIView()
    
    // MARK: - init
    init(viewModel: DetailHabitViewModel, navigator: Navigator) {
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
        
        /// ScrollView TapGesture로 키보드 내리기.
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        viewContents.backgroundColor = .red
        
        viewHeader = CommonView.detailHeadFrame(btnBack: btnBack, lblTitle: lblTitle, btnDone: btnDone)
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: true)
        
        /// 잔소리 알림
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfName, lblHint: lblHint)
        viewNameTitle = CommonView.requiredTitleFrame("습관 이름")
        detailNameFrame = CommonView.detailNameFrame(viewNameTitle: viewNameTitle, viewHintTextField: viewHintTextField)
        
        /// 수행 시간
        viewTimeTitle = CommonView.requiredTitleFrame("수행 시간")
        detailPerformTimeFrame = CommonView.detailPerformTimeFrame(viewTimeTitle: viewTimeTitle, lblTime: lblTime)
        
        /// 이행 주기
        viewCycleTitle = CommonView.requiredTitleFrame("이행 주기")
        
        /// 잔소리 알림
        viewAddPushTime = CommonView.detailAddPushTimeFrame(defaultView: viewDefaultNaggingPush, timeView: viewTimeNaggingPush)
        viewAddPushTime.isHidden = true
        detailNaggingPushFrame = CommonView.detailNaggingPushFrame(lblTitle: lblPushTitle, switchPush: switchPush, viewAddPushTime: viewAddPushTime)
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        view.addSubview(scrollView)
        
        viewContents.addSubview(detailNameFrame)
        viewContents.addSubview(detailPerformTimeFrame)
        viewContents.addSubview(btnPerformTime)
        viewContents.addSubview(cycleFrame)
        
        /// 이행 주기
        cycleFrame.addSubview(viewCycleTitle)
        cycleFrame.addSubview(viewCycleType)
        viewCycleType.addSubview(btnCycleWeek)
        viewCycleType.addSubview(btnCycleNumber)
        cycleFrame.addSubview(cycleCollectionView)
        cycleFrame.addSubview(divider)
        
        viewContents.addSubview(detailNaggingPushFrame)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        /// 습관 이름
        detailNameFrame.snp.makeConstraints({
            $0.height.equalTo(105)
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        /// 수행 시간
        detailPerformTimeFrame.snp.makeConstraints({
            $0.height.equalTo(101)
            $0.top.equalTo(detailNameFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        btnPerformTime.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(detailPerformTimeFrame)
        })
        
        /// 이행 주기
        cycleFrame.snp.makeConstraints({
            $0.height.equalTo(143 + self.cycleCellHeight)
            $0.top.equalTo(detailPerformTimeFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        viewCycleTitle.snp.makeConstraints({
            $0.top.leading.equalToSuperview()
        })
        
        viewCycleType.snp.makeConstraints({
            $0.height.equalTo(42)
            $0.top.equalTo(viewCycleTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
        })
        
        btnCycleWeek.snp.makeConstraints({
            $0.top.leading.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-3)
        })
        
        btnCycleNumber.snp.makeConstraints({
            $0.width.equalTo(btnCycleWeek)
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalTo(btnCycleWeek.snp.trailing).offset(3)
            $0.bottom.trailing.equalToSuperview().offset(-3)
        })
        
        cycleCollectionView.snp.makeConstraints({
            $0.top.equalTo(viewCycleType.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.cycleCellHeight)
        })
        
        divider.snp.makeConstraints({
            $0.top.equalTo(cycleCollectionView.snp.bottom).offset(32)
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        /// 잔소리 알림
        detailNaggingPushFrame.snp.makeConstraints({
            $0.height.equalTo(105)
            $0.top.equalTo(cycleFrame.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(20)
        })
        
        view.layoutIfNeeded()
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = DetailHabitViewModel.Input(
            btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
            btnCycleWeekTapped: self.btnCycleWeek.rx.tap.asDriverOnErrorJustComplete(),
            btnCycleNumber: self.btnCycleNumber.rx.tap.asDriverOnErrorJustComplete(),
            cycleItemSelected: self.cycleCollectionView.rx.itemSelected.asDriver(),
            valueChangedPush: self.switchPush.rx.controlEvent(.valueChanged).withLatestFrom(self.switchPush.rx.value).asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
        
        output.cycleItems
            .bind(to: cycleCollectionView.rx.items(cellIdentifier: cycleIdentifier, cellType: CycleCell.self)) { _, item, cell in
                cell.lblTitle.text = item
            }.disposed(by: disposeBag)
        
        output.selectCycleType
            .drive(onNext: { type in
                self.btnCycleWeek.isSelected = type == .week
                self.btnCycleNumber.isSelected = type == .number
                let inset = type == .week ? 0 : ((self.cycleCellSpacing + self.cycleCellHeight) / 2)
                self.cycleCollectionView.snp.updateConstraints({
                    $0.leading.trailing.equalToSuperview().inset(inset)
                })
            }).disposed(by: disposeBag)
        
        output.isNaggingPush
            .drive(onNext: { isNaggingPush in
                if isNaggingPush {
                    self.viewAddPushTime.fadeIn()
                } else {
                    self.viewAddPushTime.fadeOut()
                }
            }).disposed(by: disposeBag)
    }
}
