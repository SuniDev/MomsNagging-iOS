//
//  OnboardingViewController.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

import SnapKit
import Then
import RxViewController
import ReactorKit

class OnboardingViewController: BasePageViewController {
    
    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
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

    lazy var btnLogin = AppButton().then({
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.highlightedBackgroundColor = Asset.Color.monoLight020.color
        $0.layer.cornerRadius = 26.0
    })
    
    lazy var btnNext = AppButton().then({
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.layer.cornerRadius = 26.0
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var btnStart = AppButton().then({
        $0.isHidden = true
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.layer.cornerRadius = 26.0
        $0.setTitle("시작해볼래요!", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var imgvPagecontrol = UIImageView()
    
    // MARK: - Init
    init(with reactor: OnboardingReactor) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - init UI & Layout
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
    
    override func initLayout() {
        // 서브뷰 추가
        [lblTitle, viewMessage, imgvPagecontrol, btnLogin, btnNext, btnStart].forEach { view.addSubview($0) }
        viewMessage.addSubview(imgvEmoji)

        let safeArea = view.safeAreaLayoutGuide
        
        // lblTitle 레이아웃
        lblTitle.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(safeArea.snp.top).offset(15)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }

        // viewMessage 레이아웃
        viewMessage.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(lblTitle.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(safeArea).inset(30)
        }
        
        // imgvEmoji 레이아웃
        imgvEmoji.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
        
        // imgvPagecontrol 레이아웃
        imgvPagecontrol.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.bottom.equalTo(btnStart.snp.top).offset(-32)
        }
        
        // btnLogin 레이아웃
        btnLogin.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-32)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
        }
        
        // btnNext 레이아웃
        btnNext.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-20)
            $0.centerY.equalTo(btnLogin.snp.centerY)
        }
        
        // btnStart 레이아웃
        btnStart.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-32)
        }
    }

}

extension OnboardingViewController: View {
    func bind(reactor: OnboardingReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindView(_ reactor: OnboardingReactor) {
        
    }
    
    private func bindAction(_ reactor: OnboardingReactor) { }
    
    private func bindState(_ reactor: OnboardingReactor) {
        reactor.state.map { $0.step }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.steps.accept(step)
            })
            .disposed(by: disposeBag)
    }
    
}
