//
//  LoginViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import Foundation
import RxSwift
import RxCocoa

import GoogleSignIn
import RxKakaoSDKUser
import KakaoSDKUser
import AuthenticationServices

class LoginViewModel: BaseViewModel, BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    struct Input {
        /// 구글 로그인
        let btnGoogleLoginTapped = PublishRelay<LoginViewController>()
        /// 카카오 로그인
        let btnKakaoLoginTapped = PublishRelay<Void>()
        /// 애플 로그인
        let btnAppleLoginTapped = PublishRelay<LoginViewController>()
    }
    
    // MARK: - Output
    struct Output {
        /// 회원가입으로 이동
        let shouldJoin = PublishSubject<LoginInfo>()
        /// 회원 인증 성공
        let successLogin = PublishSubject<Void>()
        /// 로그인 오류 발생 (네트워크 오류)
        let error = PublishSubject<String>()
    }
    
    // MARK: - init
    override init() {
        super.init()
        
        input.btnGoogleLoginTapped
            .subscribe(onNext: { [weak self] vc in
                guard let self = self else { return }
                self.signInGoogle(vc: vc)
            }).disposed(by: disposeBag)
        
        input.btnKakaoLoginTapped
            .bind(onNext: signInKakao)
            .disposed(by: disposeBag)
        
        input.btnAppleLoginTapped
            .bind(onNext: signInApple)
            .disposed(by: disposeBag)
    }
    
    // MARK: - business logic
    func signInGoogle(vc: LoginViewController) {
        let signInConfig = GIDConfiguration(clientID: ApiList.getGooleClientID())
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            user.authentication.do { authentication, error in
                guard error == nil else { Log.error(error!); return }
                guard let authentication = authentication else { return }
                
                if let token = authentication.idToken {
//                    let id = user.userID
                    let loginInfo = LoginInfo(authToken: token, email: user.profile?.email, snsType: .google)
                    self.getUserInfo(loginInfo: loginInfo)
                } else {
                    Log.debug("Google Token nil")
                }
            }
        }
    }
    
    func signInKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext: { oauthToken in
                    self.getKakaoUserInfo(authToken: "\(oauthToken)")
                }, onError: {error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { oauthToken in
                    self.getKakaoUserInfo(authToken: "\(oauthToken)")
                }, onError: {error in
                    Log.error(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func signInApple(vc: LoginViewController) {
    }
    
    func getKakaoUserInfo(authToken: String) {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { user in
//                let id = user.id
                let loginInfo = LoginInfo(authToken: authToken, email: user.kakaoAccount?.email, snsType: .kakao)
                self.getUserInfo(loginInfo: loginInfo)
            }, onFailure: {error in
                Log.error(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getUserInfo(loginInfo: LoginInfo) {
        // TODO: 서버에 회원 정보 request, user 정보 저장
        Log.debug("Login Info \(loginInfo)")
        output.successLogin.accept(())
    }

}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            _ = credential.user
        }
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system .
//            let id = appleIDCredential.user
            let token = appleIDCredential.identityToken
            let email = appleIDCredential.email ?? ""
            
            let loginInfo = LoginInfo(authToken: String(describing: token), email: email, snsType: .apple)
            self.getUserInfo(loginInfo: loginInfo)
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
            
        default:
            break
        }
    }
}
