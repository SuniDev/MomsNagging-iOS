//
//  OnboardingViewController.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

class OnboardingViewController: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    
    // MARK: - init
    init(viewModel: OnboardingViewModel, navigator: Navigator) {
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
    }
    
    // MARK: - initUI
    override func initUI() {
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
    }
}
