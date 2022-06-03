//
//  AddHabitView.swift
//  momsnagging
//
//  Created by suni on 2022/05/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class AddHabitView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: AddHabitViewModel?
    var navigator: Navigator!
    
    private let recommendTitleCellSpacing: CGFloat = 16
    private let recommendTitleCellHeight: CGFloat = 96
    private let recommendTitleIdentifier = "RecommendHabitTitleCell"
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    lazy var lblTitleDirect = UILabel().then({
        $0.text = "직접 입력"
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    
    lazy var viewMyOwnHabit = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var imgvPlus = UIImageView().then({
        $0.image = Asset.Icon.plus.image
    })
    lazy var lblMyOwnHabit = UILabel().then({
        $0.text = "나만의 습관 만들기"
        $0.textColor = Asset.Color.priMain.color
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
    })
    lazy var btnMyOwnHabit = UIButton().then({
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.addBorder(color: Asset.Color.priLight030.color, width: 1)
    })
    
    lazy var lblTitleRecommend = UILabel().then({
        $0.text = "추천 습관"
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var imgvTipIcon = UIImageView().then({
        $0.image = Asset.Icon.tip.image
    })
    lazy var btnTip = UIButton().then({
        $0.backgroundColor = .clear
    })
    lazy var imgvTipView = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.addhabitTip.image
    })
    lazy var lblTip = UILabel().then({
        $0.isHidden = true
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.numberOfLines = 2
        $0.text = "추천 습관 목록에 있는 습관을 추가하면\n맞춤형 잔소리 푸쉬 알림을 제공해준단다."
    })
    
    var recommendTitleList: [RecommendHabitTitle] = []
    
    lazy var recommendTitleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: recommendTitleCellLayout())
        collectionView.register(RecommendHabitTitleCell.self, forCellWithReuseIdentifier: recommendTitleIdentifier)
        collectionView.backgroundColor = Asset.Color.monoWhite.color
        collectionView.contentInset = .zero
        return collectionView
    }()
    
    private func recommendTitleCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = recommendTitleCellSpacing
        layout.minimumLineSpacing = recommendTitleCellSpacing
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - (recommendTitleCellSpacing * 3)) / 2, height: recommendTitleCellHeight)
        return layout
    }
    
    // MARK: - init
    init(viewModel: AddHabitViewModel, navigator: Navigator) {
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

        // Do any additional setup after loading the view.
    }
    
    // MARK: - initUI
    override func initUI() {
        self.view.backgroundColor = Asset.Color.monoWhite.color
        viewHeader = CommonView.defaultHeadFrame(leftIcBtn: btnBack, headTitle: "습관 추가")
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: false)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        view.addSubview(scrollView)
        
        viewContents.addSubview(lblTitleDirect)
        viewContents.addSubview(viewMyOwnHabit)
        viewMyOwnHabit.addSubview(imgvPlus)
        viewMyOwnHabit.addSubview(lblMyOwnHabit)
        viewContents.addSubview(btnMyOwnHabit)
        
        viewContents.addSubview(lblTitleRecommend)
        viewContents.addSubview(imgvTipIcon)
        viewContents.addSubview(btnTip)
        viewContents.addSubview(imgvTipView)
        viewContents.addSubview(lblTip)
        viewContents.addSubview(recommendTitleCollectionView)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitleDirect.snp.makeConstraints({
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(18)
        })

        btnMyOwnHabit.snp.makeConstraints({
            $0.height.equalTo(55)
            $0.top.equalTo(lblTitleDirect.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        viewMyOwnHabit.snp.makeConstraints({
            $0.height.equalTo(27)
            $0.center.equalTo(btnMyOwnHabit)
        })
        
        imgvPlus.snp.makeConstraints({
            $0.height.width.equalTo(20)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        })
        
        lblMyOwnHabit.snp.makeConstraints({
            $0.leading.equalTo(imgvPlus.snp.trailing).offset(8)
            $0.top.trailing.bottom.equalToSuperview()
        })
        
        lblTitleRecommend.snp.makeConstraints({
            $0.top.equalTo(btnMyOwnHabit.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(18)
        })
        
        imgvTipIcon.snp.makeConstraints({
            $0.width.height.equalTo(18)
            $0.centerY.equalTo(lblTitleRecommend)
            $0.leading.equalTo(lblTitleRecommend.snp.trailing).offset(4)
        })
        
        btnTip.snp.makeConstraints({
            $0.top.leading.equalTo(imgvTipIcon).offset(-5)
            $0.bottom.equalTo(imgvTipIcon).offset(5)
            $0.trailing.equalTo(imgvTipView).offset(5)
        })
        
        imgvTipView.snp.makeConstraints({
            $0.width.equalTo(217)
            $0.height.equalTo(38)
            $0.leading.equalTo(imgvTipIcon.snp.trailing).offset(2)
            $0.top.equalTo(imgvTipIcon.snp.top).offset(-14)
        })
        
        lblTip.snp.makeConstraints({
            $0.leading.equalTo(imgvTipView).offset(18)
            $0.centerY.equalTo(imgvTipView)
        })
        
        recommendTitleCollectionView.snp.makeConstraints({
            $0.top.equalTo(lblTitleRecommend.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        })
        
        view.layoutIfNeeded()
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = AddHabitViewModel.Input(
            willAppearAddHabit: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
            btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
            btnMyOwnHabitTapped: self.btnMyOwnHabit.rx.tap.asDriverOnErrorJustComplete(),
            btnTipTapped: self.btnTip.rx.tap.asDriverOnErrorJustComplete(),
            recommendTitleItemSelected: self.recommendTitleCollectionView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.goToBack
            .drive(onNext: {
                
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
        
        output.goToMyOwnHabit
            .drive(onNext: {
                self.navigator.show(seque: .detailHabit(viewModel: DetailHabitViewModel(isNew: true, isRecommendHabit: false, dateParam: self.viewModel?.dateParam ?? "", homeViewModel: (self.viewModel?.homeViewModel!)!)), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
        
        output.isHiddenTip
            .drive(onNext: { isHidden in
                if isHidden {
                    self.imgvTipView.fadeOut()
                    self.lblTip.fadeOut()
                } else {
                    self.imgvTipView.fadeIn()
                    self.lblTip.fadeIn()
                }
            }).disposed(by: disposeBag)
        
        output.cntRecommendTitle
            .drive(onNext: { count in
                let line = ( count / 2 ) + ( count % 2 )
                var height = line * Int(self.recommendTitleCellHeight)
                height += Int(self.recommendTitleCellSpacing) * (line - 1)
                self.recommendTitleCollectionView.snp.makeConstraints({
                    $0.height.equalTo(height)
                })
            }).disposed(by: disposeBag)
        output.recommendTitleItems.subscribe(onNext: { list in
            self.recommendTitleList = list
            Log.debug("self.recommendTitleList", "\(self.recommendTitleList)")
        }).disposed(by: disposeBag)
        
        output.recommendTitleItems
            .bind(to: recommendTitleCollectionView.rx.items(cellIdentifier: recommendTitleIdentifier, cellType: RecommendHabitTitleCell.self)) { _, item, cell in
                cell.lblTitle.text = item.categoryName ?? item.title
                cell.normalBackgroundColor = UIColor(hexString: item.normalColor ?? "")
                cell.selectedBackgroundColor = UIColor(hexString: item.highlightColor ?? "")
                cell.image.image = item.image
            }.disposed(by: disposeBag)
        
        output.recommendTitleItemSelected
            .drive(onNext: { indexPath in
                let vc = Navigator.Scene.recommendedHabit(viewModel: RecommendedHabitViewModel(type: indexPath.row, homeViewModel: viewModel.homeViewModel ?? HomeViewModel(), dateParam: self.viewModel?.dateParam ?? "", categoryId: self.recommendTitleList[indexPath.row].id ?? 0 ))
                self.navigator.show(seque: vc, sender: self, transition: .navigation)
            }).disposed(by: disposeBag)

    }
}
