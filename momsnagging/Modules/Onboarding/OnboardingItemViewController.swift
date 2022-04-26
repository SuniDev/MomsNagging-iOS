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
    let viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    let lblTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    })
    
    let viewMessage = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    let imgvEmoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    let imgvBubble = UIImageView().then({
        $0.image = Asset.Assets.bubble224x60.image
        $0.contentMode = .scaleAspectFill
    })
    
    let imgvImage = UIImageView().then({
        $0.image = Asset.Assets.defautImage.image
    })
    
    let lblMessage = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    })
    
    let pageControl = UIPageControl().then({
        $0.pageIndicatorTintColor = Asset.Color.monoLight030.color
        $0.currentPageIndicatorTintColor = Asset.Color.priLight030.color
        $0.isUserInteractionEnabled = false
    })
    
    let btnLogin = UIButton()
    
    let btnNext = UIButton().then({
        $0.layer.cornerRadius = 26.0
        $0.backgroundColor = Asset.Color.priMain.color
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    let btnStart = UIButton().then({
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
        viewMessage.addSubview(imgvBubble)
        viewMessage.addSubview(lblMessage)
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
            $0.height.equalTo(179)
            $0.top.equalTo(lblTitle.snp.bottom)
            $0.centerX.equalToSuperview()
        })
        
        imgvEmoji.snp.makeConstraints({
            $0.height.width.equalTo(72.0)
            $0.top.equalToSuperview().offset(39.0)
            $0.leading.equalToSuperview()
        })
        
        imgvBubble.snp.makeConstraints({
            $0.width.equalTo(245.0)
            $0.top.equalTo(imgvEmoji.snp.top).offset(-8.0)
            $0.leading.equalTo(imgvEmoji.snp.trailing).offset(2.0)
            $0.trailing.equalToSuperview()
        })
        
        lblMessage.snp.makeConstraints({
            $0.leading.equalTo(imgvBubble).offset(35.0)
            $0.centerY.equalTo(imgvBubble).offset(-5.0)
            $0.trailing.equalTo(imgvBubble).offset(-15.0)
        })
        
        imgvImage.snp.makeConstraints({
            $0.top.equalTo(viewMessage.snp.bottom)
            $0.leading.equalToSuperview().offset(30.0)
            $0.trailing.equalToSuperview().offset(-30.0)
            $0.height.equalTo(imgvImage.snp.width).multipliedBy(1 / 0.94)
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
        
        output.setDescription.drive(onNext: { pageMsg in
            self.lblMessage.text = pageMsg
        }).disposed(by: disposeBag)
        
        output.setEmoji.drive(onNext: { image in
            self.imgvEmoji.image = image
        }).disposed(by: disposeBag)
        
        output.setImage.drive(onNext: { image in
            self.imgvImage.image = image
        }).disposed(by: disposeBag)
        
        output.setBubble.drive(onNext: { image in
            self.imgvBubble.image = image
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
