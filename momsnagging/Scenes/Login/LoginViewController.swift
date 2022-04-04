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
        $0.textAlignment = .center
    })
    
    var btnGoogleSignIn = UIButton().then({
        $0.backgroundColor = Asset.red.color
        $0.setTitle("구글 로그인", for: .normal)
        $0.setTitleColor(Asset.white.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
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
        viewBackground.addSubview(btnGoogleSignIn)
        
        viewBackground.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.centerX.equalTo(viewBackground)
            $0.top.equalTo(viewBackground).offset(20)
            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
        })
        
        btnGoogleSignIn.snp.makeConstraints({
            $0.centerX.equalTo(viewBackground)
            $0.top.equalTo(lblTitle.snp.bottom).offset(50)
            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        })
        
    }
    
    // MARK: - bind
    override func bind() {
        // Bind Input
        btnGoogleSignIn.rx.tap
            .bind {
                self.viewModel.input.btnGoogleSignInTapped.accept(self)
            }
            .disposed(by: disposeBag)
        
        // Bind Output
        viewModel.output.successLogin
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToMain)
            .disposed(by: disposeBag)
        
    }

}
extension LoginViewController {
    private func goToMain() {
        // TODO: - 로그인 성공 매인 이동
        Log.debug("Success Login goToMain")
    }
}
