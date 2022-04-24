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

    var itemsVCs: [OnboardingItemViewController] = [OnboardingItemViewController]()
    
    // MARK: - UI Properties
    
    // MARK: - init
    init(viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [:])
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
        dataSource = self
        delegate = nil
        setViewControllers([itemsVCs[0]], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = OnboardingPageViewModel.Input()
        let output = viewModel.transform(input: input)
        
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingItemViewController else { return nil }
        guard let index = itemsVCs.firstIndex(of: vc) else { return nil }
        
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return itemsVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingItemViewController else { return nil }
        guard let index = itemsVCs.firstIndex(of: vc) else { return nil }
        
        let nextIndex = index + 1
        if nextIndex == itemsVCs.count {
            return nil
        }
        return itemsVCs[nextIndex]
    }
    
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return itemsVCs.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first as? OnboardingItemViewController else {
            return 0
        }
        guard let firstVCIndex = itemsVCs.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
}
