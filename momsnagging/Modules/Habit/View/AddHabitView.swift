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
//    lazy var imgvTip = UIImageView().then({
//
//    })
    lazy var btnTip = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var cvRecommend = UICollectionView()
    
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
        viewHeader = CommonView.defaultHeadFrame(leftIcBtn: btnBack, headTitle: "습관 추가")
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: true)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        view.addSubview(scrollView)
        
        viewContents.addSubview(lblTitleDirect)
        viewContents.addSubview(btnMyOwnHabit)
        viewContents.addSubview(viewMyOwnHabit)
        viewMyOwnHabit.addSubview(imgvPlus)
        viewMyOwnHabit.addSubview(lblMyOwnHabit)
        
        viewContents.addSubview(lblTitleRecommend)
//        viewContents.addSubview(imgvTip)
        viewContents.addSubview(btnTip)
//        viewContents.addSubview(cvRecommend)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
        
//        cvRecommend.snp.makeConstraints({
//            $0.top.leading.equalTo(lblTitleRecommend.snp.bottom).offset(16)
//            $0.trailing.bottom.equalToSuperview().offset(-16)
//        })
        
    }
    
    // MARK: - bind
    override func bind() {
        
    }
}
