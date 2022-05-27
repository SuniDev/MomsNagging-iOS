//
//  LoginView.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import GoogleSignIn
import RxKakaoSDKUser
import KakaoSDKUser
import AuthenticationServices

class LoginView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: LoginViewModel?
    var navigator: Navigator!
    
    let appleSignInAuthorization = PublishRelay<ASAuthorization>()
    let appleSignInError = PublishRelay<Error?>()
    
    // MARK: - UI Properties
    var viewBackground = UIView().then({
        $0.backgroundColor = .white
    })
    
    let imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.logo.image
    })

    let imgvGoogleLogin = UIImageView().then({
        $0.image = Asset.Assets.loginGoogle.image
        $0.addShadow(color: Asset.Color.monoDark020.color, alpha: 0.2, x: 0, y: 4, blur: 17, spread: 0)
        $0.isUserInteractionEnabled = false
    })
    
    var btnGoogleLogin = CommonButton().then({
        $0.normalBackgroundColor = .clear
        $0.highlightedBackgroundColor = Asset.Color.selected.color
        $0.layer.cornerRadius = 20
    })

    let imgvKakaoLogin = UIImageView().then({
        $0.image = Asset.Assets.loginKakao.image
        $0.addShadow(color: Asset.Color.monoDark020.color, alpha: 0.2, x: 0, y: 4, blur: 17, spread: 0)
    })
    
    var btnKakaoLogin = CommonButton().then({
        $0.normalBackgroundColor = .clear
        $0.highlightedBackgroundColor = Asset.Color.selected.color
        $0.layer.cornerRadius = 20
    })
    
    let imgvAppleLogin = UIImageView().then({
        $0.image = Asset.Assets.loginApple.image
        $0.addShadow(color: Asset.Color.monoDark020.color, alpha: 0.2, x: 0, y: 4, blur: 17, spread: 0)
    })
    
    var btnAppleLogin = CommonButton().then({
        $0.normalBackgroundColor = .clear
        $0.highlightedBackgroundColor = Asset.Color.selected.color
        $0.layer.cornerRadius = 20
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
        view.backgroundColor = Asset.Color.monoWhite.color
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(imgvLogo)
        
        viewBackground.addSubview(imgvGoogleLogin)
        viewBackground.addSubview(btnGoogleLogin)
        
        viewBackground.addSubview(imgvKakaoLogin)
        viewBackground.addSubview(btnKakaoLogin)
        
        viewBackground.addSubview(imgvAppleLogin)
        viewBackground.addSubview(btnAppleLogin)
        
        viewBackground.snp.makeConstraints({
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        })
        
        imgvLogo.snp.makeConstraints({
            $0.width.height.equalTo(200)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
        
        imgvGoogleLogin.snp.makeConstraints({
            $0.height.equalTo(imgvGoogleLogin.snp.width).multipliedBy(1 / 5.85)
            $0.top.equalTo(imgvLogo.snp.bottom).offset(70)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        })
        
        btnGoogleLogin.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvGoogleLogin)
        })
        
        imgvKakaoLogin.snp.makeConstraints({
            $0.height.equalTo(imgvKakaoLogin.snp.width).multipliedBy(1 / 5.85)
            $0.top.equalTo(imgvGoogleLogin.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        })
        
        btnKakaoLogin.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvKakaoLogin)
        })
        
        imgvAppleLogin.snp.makeConstraints({
            $0.height.equalTo(imgvAppleLogin.snp.width).multipliedBy(1 / 5.85)
            $0.top.equalTo(imgvKakaoLogin.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        })
        
        btnAppleLogin.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvAppleLogin)
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let googleSignInUser = PublishRelay<GIDGoogleUser?>()
        let googleSignInError = PublishRelay<Error?>()
        
        let input = LoginViewModel.Input(
            btnGoogleLoginTapped: btnGoogleLogin.rx.tap.asDriverOnErrorJustComplete(),
            getGoogleSignInUser: googleSignInUser.asDriverOnErrorJustComplete(),
            getGoogleSignInError: googleSignInError.asDriverOnErrorJustComplete(),
            btnKakaoLoginTapped: btnKakaoLogin.rx.tap.asDriverOnErrorJustComplete(),
            btnAppleLoginTapped: btnAppleLogin.rx.tap.asDriverOnErrorJustComplete(),
            appleSignInAuthorization: self.appleSignInAuthorization.asDriverOnErrorJustComplete(),
            getAppleSignInError: self.appleSignInError.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.googleSignIn
            .drive(onNext: { config in
                GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
                    googleSignInUser.accept(user)
                    googleSignInError.accept(error)
                }
            }).disposed(by: disposeBag)
        
        output.appleSignIn
            .drive(onNext: {
                self.signInApple()
            }).disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { error in
                Log.error(error)
                CommonView.showAlert(vc: self, type: .oneBtn, title: STR_LOGIN_ERROR_TITLE, message: STR_LOGIN_ERROR_MESSAGE, doneTitle: STR_DONE)
            }).disposed(by: disposeBag)
        
        output.goToJoin
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .idSetting(viewModel: viewModel), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
        
        output.goToMain
            .drive(onNext: { viewModel in
                    self.navigator.show(seque: .mainContainer(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Apple Login UI
extension LoginView: ASAuthorizationControllerPresentationContextProviding {

    private func signInApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let appleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        appleIDRequest.requestedScopes = [.email]
        let applePaaswordRequest = ASAuthorizationPasswordProvider().createRequest()
        let requests = [appleIDRequest,
                        applePaaswordRequest]

        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.appleSignInError.accept(error)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.appleSignInAuthorization.accept(authorization)
    }
}
