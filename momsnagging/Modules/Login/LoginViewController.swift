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

import GoogleSignIn
import RxKakaoSDKUser
import KakaoSDKUser
import AuthenticationServices
import RxRelay

class LoginViewController: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: LoginViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    var viewBackground = UIView().then({
        $0.backgroundColor = .white
    })
    
    let imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.logo.image
    })
    
    let viewGoogleLogin = UIView() .then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 20.0
        $0.addShadow(color: Asset.Color.monoDark020.color, alpha: 0.2, x: 0, y: 4, blur: 17, spread: 0)
    })
    
    let lblGoogleLogin = UILabel().then({
        $0.text = "Google로 로그인"
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
    })

    let imgvGoogleLogin = UIImageView().then({
        $0.image = Asset.Assets.google.image
    })
    
    var btnGoogleLogin = UIButton().then({
        $0.backgroundColor = .clear
    })
    
//    var btnKakaoLogin = UIButton().then({
//        $0.backgroundColor = .yellow
//        $0.setTitle("카카오 로그인", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.titleLabel?.font = .systemFont(ofSize: 20)
//    })
//
//    var btnAppleLogin = UIButton().then({
//        $0.backgroundColor = .black
//        $0.setTitle("애플 로그인", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.titleLabel?.font = .systemFont(ofSize: 20)
//    })
    
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
        view.backgroundColor = Asset.Color.monoWhite.color
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(imgvLogo)
        viewBackground.addSubview(viewGoogleLogin)
        viewGoogleLogin.addSubview(imgvGoogleLogin)
        viewGoogleLogin.addSubview(lblGoogleLogin)
        viewGoogleLogin.addSubview(btnGoogleLogin)
        
        viewBackground.snp.makeConstraints({
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        })
        
        imgvLogo.snp.makeConstraints({
            $0.width.height.equalTo(200)
            $0.top.equalTo(viewBackground)
            $0.centerX.equalTo(viewBackground)
        })
        
        viewGoogleLogin.snp.makeConstraints({
            $0.height.equalTo(56)
            $0.top.equalTo(viewBackground.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().offset(24)
        })
        
        lblGoogleLogin.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        imgvGoogleLogin.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(lblGoogleLogin.snp.leading).offset(8)
            $0.centerY.equalToSuperview()
        })
        
        btnGoogleLogin.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
//
//        lblTitle.snp.makeConstraints({
//            $0.centerX.equalTo(viewBackground)
//            $0.top.equalTo(viewBackground).offset(20)
//            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
//            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
//        })
//
//        btnGoogleLogin.snp.makeConstraints({
//            $0.centerX.equalTo(viewBackground)
//            $0.top.equalTo(lblTitle.snp.bottom).offset(50)
//            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
//            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
//            $0.height.equalTo(50)
//        })
//
//        btnKakaoLogin.snp.makeConstraints({
//            $0.centerX.equalTo(viewBackground)
//            $0.top.equalTo(btnGoogleLogin.snp.bottom).offset(20)
//            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
//            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
//            $0.height.equalTo(50)
//        })
//
//        btnAppleLogin.snp.makeConstraints({
//            $0.centerX.equalTo(viewBackground)
//            $0.top.equalTo(btnKakaoLogin.snp.bottom).offset(20)
//            $0.leading.equalTo(viewBackground.snp.leading).offset(20)
//            $0.trailing.equalTo(viewBackground.snp.trailing).offset(-20)
//            $0.height.equalTo(50)
//        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let googleSignInUser = PublishRelay<GIDGoogleUser?>()
        let googleSignInError = PublishRelay<Error?>()
        
        let input = LoginViewModel.Input(
            btnGoogleLoginTapped: btnGoogleLogin.rx.tap.asDriverOnErrorJustComplete(),
            getGoogleSignInUser: googleSignInUser.asDriverOnErrorJustComplete(),
            getGoogleSignInError: googleSignInError.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.googleSignIn
            .drive(onNext: { config in
                GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
                    googleSignInUser.accept(user)
                    googleSignInError.accept(error)
                }
            }).disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { error in
                CommonView.showToast(vc: self, message: error)
            }).disposed(by: disposeBag)
        
        // Bind Input
//        input.btnGoogleLogin.rx.tap
//            .bind {
//                self.viewModel.input.btnGoogleLoginTapped.accept(self)
//            }
//            .disposed(by: disposeBag)

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
 extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {

    private func signInApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]

        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
 }
