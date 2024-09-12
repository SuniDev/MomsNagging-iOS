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
    var pages: [OnboardingItemViewController] = []
    
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
        $0.image = Asset.Assets.onboardingEmoji1.image
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
    
    lazy var imgvPagecontrol = UIImageView().then({
        $0.image = Asset.Assets.pagecontrol1.image
    })
    
    // MARK: - Init
    init(with reactor: OnboardingReactor) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.reactor = reactor
        self.initializePages()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - init UI & Layout
    override func initUI() {
        self.delegate = self
        self.dataSource = self
        
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
        
        lblTitle.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(safeArea.snp.top).offset(15)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }
        
        viewMessage.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(lblTitle.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(safeArea).inset(30)
        }
        
        imgvEmoji.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
        
        imgvPagecontrol.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.bottom.equalTo(btnStart.snp.top).offset(-32)
        }
        
        btnLogin.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-32)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
        }
        
        btnNext.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-20)
            $0.centerY.equalTo(btnLogin.snp.centerY)
        }
        
        btnStart.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-32)
        }
    }
    
    // MARK: - Pages 초기화
    private func initializePages() {
        guard let reactor = reactor else { return }
        
        // OnboardingItemViewController 생성 후 각 페이지에 할당
        for i in 0..<reactor.currentState.onboardings.count {
            let itemVC = OnboardingItemViewController(with: reactor.currentState.onboardings[i])
            pages.append(itemVC)
        }
        
        // 첫 페이지로 설정
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
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
    
    private func bindAction(_ reactor: OnboardingReactor) {
        btnNext.rx.tap
            .withLatestFrom(reactor.state.map { $0.currentPageIndex }) // 현재 페이지 인덱스를 가져옴
            .subscribe(onNext: { [weak self] currentPageIndex in
                guard let self = self else { return }

                let nextPageIndex = currentPageIndex + 1
                if nextPageIndex < reactor.currentState.onboardings.count {
                    // 다음 페이지가 있을 경우 상태 업데이트 및 페이지 전환
                    reactor.action.onNext(.setPage(nextPageIndex))

                    let nextViewController = self.pages[nextPageIndex]
                    self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: OnboardingReactor) {
        reactor.state.map { $0.step }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.steps.accept(step)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPageIndex }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] pageIndex in
                guard let self = self else { return }
                
                // 현재 페이지에 해당하는 뷰 컨트롤러로 페이지 전환
                if pageIndex >= 0 && pageIndex < self.pages.count {
                    
                    // 페이지에 맞는 이미지 및 페이지 컨트롤 업데이트
                    self.imgvEmoji.image = reactor.currentState.onboardings[pageIndex].emoji
                    self.imgvPagecontrol.image = reactor.currentState.onboardings[pageIndex].pageControl
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let reactor = reactor else { return nil }
        
        // 현재 페이지가 무엇인지 정확히 계산
        guard let itemVC = viewController as? OnboardingItemViewController, let currentIndex = pages.firstIndex(of: itemVC) else { return nil }
        let previousIndex = currentIndex - 1
        
        if previousIndex >= 0 {
            return pages[previousIndex]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let reactor = reactor else { return nil }
        
        // 현재 페이지가 무엇인지 정확히 계산
        guard let itemVC = viewController as? OnboardingItemViewController, let currentIndex = pages.firstIndex(of: itemVC) else { return nil }
        let nextIndex = currentIndex + 1
        
        if nextIndex < reactor.currentState.onboardings.count {
            return pages[nextIndex]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first as? OnboardingItemViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            // 페이지 전환이 완료되었을 때 상태 업데이트
            reactor?.action.onNext(.setPage(currentIndex))
        }
    }
}
