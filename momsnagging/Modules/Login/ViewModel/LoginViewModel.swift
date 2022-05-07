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
import KakaoSDKAuth
import RxKakaoSDKAuth
import AuthenticationServices

class LoginViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    override init() { }
    
    // MARK: - Input
    struct Input {
        /// 구글 로그인
        let btnGoogleLoginTapped: Driver<Void>
        let getGoogleSignInUser: Driver<GIDGoogleUser?>
        let getGoogleSignInError: Driver<Error?>
        /// 카카오 로그인
        let btnKakaoLoginTapped: Driver<Void>
        /// 애플 로그인
        let btnAppleLoginTapped: Driver<Void>
        let appleSignInAuthorization: Driver<ASAuthorization>
        let getAppleSignInError: Driver<Error?>
    }
    
    // MARK: - Output
    struct Output {
        /// 구글 로그인
        let googleSignIn: Driver<GIDConfiguration>
        /// 애플 로그인
        let appleSignIn: Driver<Void>
        /// 로그인 정보 없음 -> 회원가입 필요
        let needToJoin: Driver<LoginInfo>
        /// 회원 인증 성공
        let successLogin: Driver<User>
        /// 로그인 오류 발생
        let error: Driver<String>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        /// Login Status
        let snsLoginInfo = PublishRelay<LoginInfo>()
        let needToJoin = PublishRelay<LoginInfo>()
        let successLogin = PublishRelay<User>()
        let errorMessage = PublishRelay<String>()
        
        /// 구글 로그인
        let googlgoogleSignInConfig = PublishRelay<GIDConfiguration>()
        
        input.btnGoogleLoginTapped
            .drive(onNext: {
                googlgoogleSignInConfig.accept(GIDConfiguration(clientID: ApiList.getGooleClientID()))
            }).disposed(by: disposeBag)
        
        input.getGoogleSignInUser
            .drive(onNext: { user in
                guard let user = user else { return }
                user.authentication.do { authentication, error in
                    if let error = error { errorMessage.accept(error.localizedDescription)
                        return
                    }
                    guard let authentication = authentication else { return }

                    if let token = authentication.idToken {
                        let id = user.userID
                        let loginInfo = LoginInfo(authToken: token, authId: id, email: user.profile?.email, snsType: .google)
                        snsLoginInfo.accept(loginInfo)
                    } else {
                        errorMessage.accept("구글 로그인 토큰이 없습니다.")
                    }
                }
            }).disposed(by: disposeBag)
        
        /// 카카오 로그인
        let kakaoAuthToken = BehaviorRelay<String?>(value: nil)
        
        input.btnKakaoLoginTapped
            .asObservable()
            .flatMapLatest({ () -> Observable<KakaoSDKAuth.OAuthToken> in
                if UserApi.isKakaoTalkLoginAvailable() {
                   return UserApi.shared.rx.loginWithKakaoTalk()
                } else {
                    return UserApi.shared.rx.loginWithKakaoAccount()
                }
            })
            .subscribe(onNext: { authToken in
                kakaoAuthToken.accept(authToken.accessToken)
            }, onError: { error in
                errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        kakaoAuthToken
            .asObservable()
            .skip(1)
            .flatMapLatest { _ -> Observable<KakaoSDKUser.User> in
                return UserApi.shared.rx.me().asObservable()
            }.subscribe(onNext: { user in
                guard let id = user.id else { return }
                let token = kakaoAuthToken.value
                let loginInfo = LoginInfo(authToken: token, authId: String(id), email: user.kakaoAccount?.email, snsType: .kakao)
                snsLoginInfo.accept(loginInfo)
            }, onError: { error in
                errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        /// 애플 로그인
        input.appleSignInAuthorization
            .drive(onNext: { authorization in
                if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    _ = credential.user
                }
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:

                    // Create an account in your system .
                    let id = appleIDCredential.user
                    let token = appleIDCredential.identityToken
                    let email = appleIDCredential.email ?? ""

                    let loginInfo = LoginInfo(authToken: String(describing: token), authId: id, email: email, snsType: .apple)
                    snsLoginInfo.accept(loginInfo)

                case let passwordCredential as ASPasswordCredential:

                    // Sign in using an existing iCloud Keychain credential.
                    _ = passwordCredential.user
                    _ = passwordCredential.password

                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        // TODO: Request Get UserInfo API
        snsLoginInfo
            .subscribe(onNext: { info in
                needToJoin.accept(info)
//                errorMessage.accept("로그인 정보: \(info.snsType?.rawValue ?? "") / \(info.email ?? "") \n API 준비중.")
        }).disposed(by: disposeBag)
        
        /// Error
        input.getGoogleSignInError
            .drive { error in
                guard let error = error else { return }
                errorMessage.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
        
        input.getAppleSignInError
            .drive { error in
                guard let error = error else { return }
                errorMessage.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
       
        return Output(googleSignIn: googlgoogleSignInConfig.asDriverOnErrorJustComplete(),
                      appleSignIn: input.btnAppleLoginTapped,
                      needToJoin: needToJoin.asDriverOnErrorJustComplete(),
                      successLogin: successLogin.asDriverOnErrorJustComplete(),
                      error: errorMessage.asDriverOnErrorJustComplete())
    }
    
}
