//
//  OnboardingPageViewController.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingItemViewController: BaseViewController {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingItemViewModel?
    
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
    
    lazy var btnLogin = UIButton()
    
    lazy var btnNext = UIButton().then({
        $0.layer.cornerRadius = 26.0
        $0.backgroundColor = Asset.Color.priMain.color
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var btnStart = UIButton().then({
        $0.layer.cornerRadius = 26.0
        $0.backgroundColor = Asset.Color.priMain.color
        $0.setTitle("시작해볼래요!", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    // MARK: - init
    init(viewModel: OnboardingItemViewModel) {
        self.viewModel = viewModel
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
            $0.top.equalToSuperview().offset(15.0)
            $0.centerX.equalTo(viewBackground)
            $0.leading.trailing.greaterThanOrEqualToSuperview()
        })
        
        viewMessage.snp.makeConstraints({
            $0.height.equalTo(94)
            $0.top.equalTo(lblTitle.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        })
        
        imgvEmoji.snp.makeConstraints({
            $0.width.equalTo(319)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        })
        
        imgvImage.snp.makeConstraints({
            $0.width.equalTo(312)
            $0.height.equalTo(320)
            $0.top.equalTo(viewMessage.snp.bottom).offset(45)
            $0.centerX.equalToSuperview()
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
            $0.top.greaterThanOrEqualTo(pageControl.snp.bottom).offset(32)
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
            $0.top.greaterThanOrEqualTo(pageControl.snp.bottom).offset(32)
        })
        
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = OnboardingItemViewModel.Input()
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

    }
     
}
