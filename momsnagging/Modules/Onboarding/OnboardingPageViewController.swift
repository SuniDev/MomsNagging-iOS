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

class OnboardingPageViewController: BasePageViewController {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingPageViewModel?

    var pages: [OnboardingItemViewController] = [OnboardingItemViewController]()
    
    // MARK: - UI Properties
    
    // MARK: - init
    init(viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
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
        
        let input = OnboardingPageViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.setPage
            .drive(onNext: { page in
                Log.debug("page \(page)")
                self.pages.append(page)
                if self.pages.count == 1 {
                    self.setViewControllers([page], direction: .forward, animated: false, completion: nil)
                }
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
