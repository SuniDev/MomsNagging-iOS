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
import AuthenticationServices

class LoginViewController: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: LoginViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    var viewBackground = UIView().then({
        $0.backgroundColor = .white
    })
    
    var lblTitle = UILabel().then({
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.text = "로그인 화면"
        $0.textAlignment = .center
    })
    
    var btnGoogleLogin = UIButton().then({
        $0.backgroundColor = .red
        $0.setTitle("구글 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
    })
    
    var btnKakaoLogin = UIButton().then({
        $0.backgroundColor = .yellow
        $0.setTitle("카카오 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
    })
    
    var btnAppleLogin = UIButton().then({
        $0.backgroundColor = .black
        $0.setTitle("애플 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
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
        viewBackground.addSubview(btnGoogleLogin)
        viewBackground.addSubview(btnKakaoLogin)
        viewBackground.addSubview(btnAppleLogin)
        
        viewBackground.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.centerX.equalTo(viewBackground)
            $0.top.equalTo(viewBackground).offset(20)
            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
        })
        
        btnGoogleLogin.snp.makeConstraints({
            $0.centerX.equalTo(viewBackground)
            $0.top.equalTo(lblTitle.snp.bottom).offset(50)
            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        })
        
        btnKakaoLogin.snp.makeConstraints({
            $0.centerX.equalTo(viewBackground)
            $0.top.equalTo(btnGoogleLogin.snp.bottom).offset(20)
            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        })
        
        btnAppleLogin.snp.makeConstraints({
            $0.centerX.equalTo(viewBackground)
            $0.top.equalTo(btnKakaoLogin.snp.bottom).offset(20)
            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = LoginViewModel.Input()
        let output = viewModel.transform(input: input)
        
        // Bind Input
//        btnGoogleLogin.rx.tap
//            .bind {
//                self.viewModel.input.btnGoogleLoginTapped.accept(self)
//            }
//            .disposed(by: disposeBag)
//
//        btnKakaoLogin.rx.tap
//            .bind(to: viewModel.input.btnKakaoLoginTapped)
//            .disposed(by: disposeBag)
//
//        btnAppleLogin.rx.tap
//            .bind {
//                self.signInApple()
//            }
//            .disposed(by: disposeBag)
//
//        // Bind Output
//        viewModel.output.shouldJoin
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: goToJoin)
//            .disposed(by: disposeBag)
//
//        viewModel.output.successLogin
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: goToMain)
//            .disposed(by: disposeBag)
        
    }
    
}

extension LoginViewController {
}

// MARK: - Apple Login UI
// extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
//
//    private func signInApple() {
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.email]
//
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = viewModel
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = viewModel
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
// }
