//
//  PushSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class PushSettingView: BaseViewController, Navigatable {
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: PushSettingViewModel!
    
    // MARK: - UI Properties
    
    // MARK: - Init
    init(viewModel: PushSettingViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - InitUI
    override func initUI() {
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
    }
    
    // MARK: - bind
    override func bind() {
    }
}
