//
//  NicknameSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import UIKit
import SnapKit
import Then
import RxSwift

class NicknameSettingView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: NicknameSettingViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    
    // MARK: - init
    init(viewModel: NicknameSettingViewModel, navigator: Navigator) {
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
        view.backgroundColor = Asset.Color.skyblue.color
               
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
    }
    
    // MARK: - bind
    override func bind() {
        
    }

}
