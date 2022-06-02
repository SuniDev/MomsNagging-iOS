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

class LoginViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
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
        /// 로그인 정보 없음 -> 회원가입(ID설정) 이동
        let goToJoin: Driver<IDSettingViewModel>
        /// 회원 인증 성공 -> 메인 이동
        let goToMain: Driver<MainContainerViewModel>
        /// 로그인 오류 발생
        let error: Driver<String>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        /// Login Status
        let snsLoginInfo = BehaviorRelay<SNSLogin>(value: SNSLogin(snsType: "", id: ""))
        let errorMessage = PublishRelay<String>()
        
        errorMessage
            .subscribe(onNext: { error in
                Log.error(error)
            }).disposed(by: disposeBag)
        
        /// 구글 로그인
        let googlgoogleSignInConfig = PublishRelay<GIDConfiguration>()
        
        input.btnGoogleLoginTapped
            .drive(onNext: {
                googlgoogleSignInConfig.accept(GIDConfiguration(clientID: ApiList.getGooleClientID()))
            }).disposed(by: disposeBag)
        
        input.getGoogleSignInUser
            .drive(onNext: { user in
                guard let user = user else { return }
                user.authentication.do { _, error in
                    if let error = error {
                        errorMessage.accept(error.localizedDescription)
                        return
                    }
                    if let id = user.userID {
                        let snsLogin = SNSLogin(snsType: SnsType.google.rawValue, id: id, email: user.profile?.email)
                        snsLoginInfo.accept(snsLogin)
                    } else {
                        errorMessage.accept("구글 ID가 없습니다.")
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
                guard let id = user.id else {
                    errorMessage.accept("카카오 ID가 없습니다.")
                    return
                }
                let snsLogin = SNSLogin(snsType: SnsType.kakao.rawValue, id: String(id), email: user.kakaoAccount?.email)
                snsLoginInfo.accept(snsLogin)
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
                    let email = appleIDCredential.email ?? ""
                    
                    let snsLogin = SNSLogin(snsType: SnsType.apple.rawValue, id: id, email: email)
                    snsLoginInfo.accept(snsLogin)

                case let passwordCredential as ASPasswordCredential:

                    // Sign in using an existing iCloud Keychain credential.
                    _ = passwordCredential.user
                    _ = passwordCredential.password

                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        let requestLogin = snsLoginInfo
            .skip(1)
            .flatMapLatest { info -> Observable<Login> in
                return self.requestLogin(snsType: info.snsType, code: info.id)
            }.share()
        
        let goToJoin = requestLogin
            .filter { $0.token == nil }
            .map { _ -> IDSettingViewModel in
                let snsLogin = snsLoginInfo.value
                let join = JoinRequest(provider: snsLogin.snsType,
                                       code: snsLogin.id,
                                       email: snsLogin.email ?? "",
                                       id: "",
                                       nickname: "",
                                       firebaseToken: CommonUser.getFCMToken())
                let viewModel = IDSettingViewModel(withService: self.provider, joinRequest: join)
                return viewModel
            }
        
        let requestGetUser = requestLogin
            .filter { $0.token != nil }
            .map { CommonUser.authorization = $0.token }
            .flatMapLatest { _ -> Observable<User> in
                return self.requestGetUser()
            }.share()
        
        let setUser = requestGetUser
            .filter { $0.id != nil }
            .share()
        
        setUser
            .subscribe(onNext: { user in
                CommonUser.setUser(user)
            }).disposed(by: disposeBag)
        
        let goToMain = setUser
            .map { _ -> MainContainerViewModel in
                let viewModel = MainContainerViewModel()
                return viewModel
            }
        
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
                      goToJoin: goToJoin.asDriverOnErrorJustComplete(),
                      goToMain: goToMain.asDriverOnErrorJustComplete(),
                      error: errorMessage.asDriverOnErrorJustComplete())
    }
}

// MARK: API
extension LoginViewModel {
    private func requestLogin(snsType: String, code: String) -> Observable<Login> {
        let request = LoginRequest(provider: snsType, code: code, firebaseToken: CommonUser.getFCMToken())
        return self.provider.authService.login(request: request)
    }
    
    private func requestGetUser() -> Observable<User> {
        let request = GetUserRequest()
        return self.provider.userService.getUser(request: request)
    }
}
