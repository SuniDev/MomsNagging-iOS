//
//  OnboardingPageView.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingItemView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingItemViewModel?
    var navigator: Navigator!
    var delegate: OnboardingPageDelegate?
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var lblTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    })
    
    lazy var viewMessage = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvEmoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    lazy var imgvImage = UIImageView().then({
        $0.image = Asset.Assets.defautImage.image
    })
    
    lazy var pageControl = UIPageControl().then({
        $0.pageIndicatorTintColor = Asset.Color.monoLight030.color
        $0.currentPageIndicatorTintColor = Asset.Color.priLight030.color
        $0.isUserInteractionEnabled = false
    })
    
    lazy var btnLogin = CommonButton().then({
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.highlightedBackgroundColor = Asset.Color.monoLight020.color
        $0.layer.cornerRadius = 26.0
    })
    
    lazy var btnNext = CommonButton().then({
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.layer.cornerRadius = 26.0
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var btnStart = CommonButton().then({
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.layer.cornerRadius = 26.0
        $0.setTitle("시작해볼래요!", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    // MARK: - init
    init(viewModel: OnboardingItemViewModel, navigator: Navigator, delegate: OnboardingPageDelegate) {
        self.viewModel = viewModel
        self.navigator = navigator
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
        let loginAttributes: [NSAttributedString.Key: Any] = [
            .font: FontFamily.Pretendard.semiBold.font(size: 20),
            .foregroundColor: Asset.Color.monoDark020.color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let loginAttributedString = NSMutableAttributedString(
                string: "로그인",
                attributes: loginAttributes
         )
        
        btnLogin.setAttributedTitle(loginAttributedString, for: .normal)
    }
    
    // MARK: - layoutSetting
    // TODO: 디바이스 높이 667 사이즈 대응 작업 필요.
    override func layoutSetting() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(lblTitle)
        viewBackground.addSubview(viewMessage)
        viewMessage.addSubview(imgvEmoji)
        viewBackground.addSubview(imgvImage)
        viewBackground.addSubview(pageControl)
        viewBackground.addSubview(btnLogin)
        viewBackground.addSubview(btnNext)
        viewBackground.addSubview(btnStart)
                
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalTo(viewBackground)
        })
        
        viewMessage.snp.makeConstraints({
            $0.height.equalTo(100)
            $0.top.equalTo(lblTitle.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        })
        
        imgvEmoji.snp.makeConstraints({
            $0.top.trailing.leading.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        })
        
        let isLowHeightDevice = Common.getSafeareaHeight() < 736
        
        imgvImage.snp.makeConstraints({
            $0.height.equalTo(imgvImage.snp.width).multipliedBy(1 / 0.94)
            $0.leading.equalToSuperview().offset(isLowHeightDevice ? 65 : 30)
            $0.trailing.equalToSuperview().offset(isLowHeightDevice ? -65 : -30)
            $0.top.greaterThanOrEqualTo(viewMessage.snp.bottom).offset(32)
        })
        
        pageControl.snp.makeConstraints({
            $0.top.equalTo(imgvImage.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        })
        
        btnLogin.snp.makeConstraints({
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-32)
            $0.leading.equalToSuperview().offset(20)
            $0.top.greaterThanOrEqualTo(pageControl.snp.bottom).offset(12)
        })
        
        btnNext.snp.makeConstraints({
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(btnLogin)
        })
        
        btnStart.snp.makeConstraints({
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-32)
            $0.top.greaterThanOrEqualTo(pageControl.snp.bottom).offset(12)
        })
        
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = OnboardingItemViewModel.Input(btnLoginTapped: btnLogin.rx.tap.asDriverOnErrorJustComplete(), btnNextTapped: btnNext.rx.tap.asDriverOnErrorJustComplete(), btnStartTapped: btnStart.rx.tap.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.setTile.drive(onNext: { pageTitle in
            self.lblTitle.text = pageTitle
        }).disposed(by: disposeBag)
        
        output.setEmoji.drive(onNext: { image in
            self.imgvEmoji.image = image
        }).disposed(by: disposeBag)
        
        output.setImage.drive(onNext: { image in
            self.imgvImage.image = image
        }).disposed(by: disposeBag)
        
        output.setPageControl.drive(onNext: { numberOfPages, index in
            self.pageControl.numberOfPages = numberOfPages
            self.pageControl.currentPage = index
        }).disposed(by: disposeBag)
        
        output.isLastPage.drive(onNext: { isLast in
            self.btnLogin.isHidden = !isLast
            self.btnNext.isHidden = !isLast
            self.btnStart.isHidden = isLast
        }).disposed(by: disposeBag)
        
        output.goToLogin.drive(onNext: {
            self.navigator.show(seque: .login(viewModel: LoginViewModel()), sender: nil, transition: .root)
        }).disposed(by: disposeBag)
        
        output.goToNextPage.drive(onNext: { page in
            self.delegate?.goToNextPage(currentPage: page)
        }).disposed(by: disposeBag)
    
    }
     
}
