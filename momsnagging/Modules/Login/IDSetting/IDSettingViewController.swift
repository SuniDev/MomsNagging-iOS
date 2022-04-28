//
//  IDSettingViewController.swift
//  momsnagging
//
//  Created by suni on 2022/04/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

class IDSettingViewController: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: IDSettingViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    var viewBackground = UIView().then({
        $0.backgroundColor = .yellow
    })
    
    // MARK: - init
    init(viewModel: IDSettingViewModel, navigator: Navigator) {
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

        // Do any additional setup after loading the view.
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
    }
}
