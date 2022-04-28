//
//  OnboardingPageViewController.swift
//  momsnagging
//
//  Created by suni on 2022/04/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

protocol OnboardingPageDelegate: AnyObject {
    func goToNextPage(currentPage: Int)
}

class OnboardingPageViewController: BasePageViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingPageViewModel?
    var navigator: Navigator!

    var pages: [OnboardingItemViewController] = [OnboardingItemViewController]()
        
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
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let appendPage = PublishRelay<Void>()
        let input = OnboardingPageViewModel.Input(appendPage: appendPage.asObservable())
        let output = viewModel.transform(input: input)
        
        output.setPageItemViewModel
            .drive(onNext: { viewModel in
                let page = OnboardingItemViewController(viewModel: viewModel, navigator: self.navigator, delegate: self)
                self.pages.append(page)
                appendPage.accept(())
            }).disposed(by: disposeBag)
        
        output.appendFirstPage
            .drive(onNext: { () in
                let page = self.pages[0]
                self.setViewControllers([page], direction: .forward, animated: false, completion: nil)
            }).disposed(by: disposeBag)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingItemViewController else { return nil }
        guard let index = pages.firstIndex(of: vc) else { return nil }
        
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingItemViewController else { return nil }
        guard let index = pages.firstIndex(of: vc) else { return nil }
        
        let nextIndex = index + 1
        if nextIndex == pages.count {
            return nil
        }
        return pages[nextIndex]
    }
    
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstVC = pageViewController.viewControllers?.first as? OnboardingItemViewController else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}
extension OnboardingPageViewController: OnboardingPageDelegate {
    func goToNextPage(currentPage: Int) {
        var nextPage = currentPage + 1
        if nextPage >= self.pages.count {
            nextPage -= 1
        }
        
        self.setViewControllers([self.pages[nextPage]], direction: .forward, animated: true)
    }
}
