//
//  OnboardingPageView.swift
//  momsnagging
//
//  Created by suni on 2022/04/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingPageView: BasePageViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingPageViewModel?
    var navigator: Navigator!

    var pages: [OnboardingItemView] = [OnboardingItemView]()
    var currentPageIndex = BehaviorRelay<Int>(value: 0)
        
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
        $0.isHidden = true
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.layer.cornerRadius = 26.0
        $0.setTitle("시작해볼래요!", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    // MARK: - init
    init(viewModel: OnboardingPageViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
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
        self.view.addSubview(btnLogin)
        self.view.addSubview(btnNext)
        self.view.addSubview(btnStart)
        
        btnLogin.snp.makeConstraints({
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-32)
            $0.leading.equalToSuperview().offset(20)
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
        })
        
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
                
        let input = OnboardingPageViewModel.Input(currentPageIndex: self.currentPageIndex.asDriverOnErrorJustComplete(),
                                                  btnLoginTapped: btnLogin.rx.tap.asDriverOnErrorJustComplete(),
                                                  btnNextTapped: btnNext.rx.tap.asDriverOnErrorJustComplete(),
                                                  btnStartTapped: btnStart.rx.tap.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.setPageItemViewModel
            .drive(onNext: { viewModel in
                let page = OnboardingItemView(viewModel: viewModel, navigator: self.navigator)
                self.pages.append(page)
            }).disposed(by: disposeBag)
        
        output.appendFirstPage
            .drive(onNext: { () in
                let page = self.pages[0]
                self.setViewControllers([page], direction: .forward, animated: false, completion: nil)
            }).disposed(by: disposeBag)
        
        output.isLastPage.drive(onNext: { isLast in
            if isLast && self.btnStart.isHidden {
                self.btnLogin.fadeOut(0.1)
                self.btnNext.fadeOut(0.1)
                 self.btnStart.fadeIn(0.1)
            } else if !isLast && self.btnLogin.isHidden {
                self.btnLogin.fadeIn(0.1)
                self.btnNext.fadeIn(0.1, completion: {
                    self.btnStart.fadeOut(0.1)
                })
            }
        }).disposed(by: disposeBag)
        
        output.goToLogin.drive(onNext: { viewModel in
            self.navigator.show(seque: .login(viewModel: viewModel), sender: nil, transition: .root)
        }).disposed(by: disposeBag)
        
        output.goToNextPage.drive(onNext: { _ in
            var nextPage = self.currentPageIndex.value + 1
            if nextPage >= self.pages.count {
                nextPage -= 1
            }
            self.currentPageIndex.accept(nextPage)
            self.setViewControllers([self.pages[nextPage]], direction: .forward, animated: true)
        }).disposed(by: disposeBag)
        
    }
}

extension OnboardingPageView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingItemView else { return nil }
        guard let index = pages.firstIndex(of: vc) else { return nil }
        
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingItemView else { return nil }
        guard let index = pages.firstIndex(of: vc) else { return nil }
        
        let nextIndex = index + 1
        if nextIndex == pages.count {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentView = pageViewController.viewControllers?[0] as? OnboardingItemView, let currentViewModel = currentView.viewModel {
                self.currentPageIndex.accept(currentViewModel.data.value.getCurrentPage())
            }
        }
    }
    
}

extension OnboardingPageView: UIPageViewControllerDelegate {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstVC = pageViewController.viewControllers?.first as? OnboardingItemView else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}
