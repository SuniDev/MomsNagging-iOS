//
//  LoginViewController.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

class LoginViewController: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel = LoginViewModel()
    var navigator: Navigator!
    
    // MARK: - UI Properties
    var viewBackground = UIView().then({
        $0.backgroundColor = Asset.white.color
    })
    
    var lblTitle = UILabel().then({
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = Asset.black.color
        $0.text = "로그인 화면"
    })
    
    // MARK: - init
    init(viewModel: LoginViewModel, navigator: Navigator) {
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
        view.addSubview(viewBackground)
        viewBackground.addSubview(lblTitle)
        
        viewBackground.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        lblTitle.snp.makeConstraints({
            $0.center.equalTo(viewBackground.snp.center)
        })
    }
    
    // MARK: - bind
    override func bind() {
        
    }

}
