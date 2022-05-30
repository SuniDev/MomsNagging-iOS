//
//  CoachMarkView.swift
//  momsnagging
//
//  Created by suni on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CoachMarkView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingItemViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewMain = UIView().then({
        $0.backgroundColor = .clear
    })
    
    // MARK: - init
    init(viewModel: OnboardingItemViewModel, navigator: Navigator, delegate: OnboardingPageDelegate) {
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
        
    }
}
extension CoachMarkView {
    
}
