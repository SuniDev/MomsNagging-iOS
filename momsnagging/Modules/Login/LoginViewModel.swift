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

class LoginViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
//        /// 구글 로그인
        let btnGoogleLoginTapped: Driver<Void>
        let getGoogleSignInUser: Driver<GIDGoogleUser?>
        let getGoogleSignInError: Driver<Error?>
//        /// 카카오 로그인
//        let btnKakaoLoginTapped = PublishRelay<Void>()
//        /// 애플 로그인
//        let btnAppleLoginTapped = PublishRelay<LoginViewController>()
    }
    
    // MARK: - Output
    struct Output {
        let googleSignIn: Driver<GIDConfiguration>
//        /// 회원가입으로 이동
//        let shouldJoin = PublishSubject<LoginInfo>()
//        /// 회원 인증 성공
//        let successLogin = PublishSubject<Void>()
//        /// 로그인 오류 발생 (네트워크 오류)
        let error: Driver<String>
    }
    
    private var googlgoogleSignInConfig = PublishRelay<GIDConfiguration>()
    private var snsLoginInfo = PublishRelay<LoginInfo>()
    private var error = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.btnGoogleLoginTapped
            .drive(onNext: {
                self.googlgoogleSignInConfig.accept(GIDConfiguration(clientID: ApiList.getGooleClientID()))
            }).disposed(by: disposeBag)
        
        let googleSignIn = self.googlgoogleSignInConfig.asDriverOnErrorJustComplete()
        
        input.getGoogleSignInUser
            .drive(onNext: { user in
                guard let user = user else { return }
                user.authentication.do { authentication, error in
                    guard error == nil else { return }
                    guard let authentication = authentication else { return }

                    if let token = authentication.idToken {
                        let id = user.userID
                        let loginInfo = LoginInfo(authToken: token, authId: id, email: user.profile?.email, snsType: .google)
                        self.snsLoginInfo.accept(loginInfo)
                    } else {
                        self.error.accept("구글 로그인 토큰이 없습니다.")
                    }
                }
            }).disposed(by: disposeBag)
        
        // TODO: Request Get UserInfo API
        self.snsLoginInfo
            .subscribe(onNext: { info in
                self.error.accept("로그인 정보: \(info.snsType?.rawValue ?? "") / \(info.email ?? "") \n API 준비중.")
        }).disposed(by: disposeBag)

        let error = self.error.asDriverOnErrorJustComplete()
        
        return Output(googleSignIn: googleSignIn,
                      error: error)
    }
    
}
extension LoginViewModel {
    
    // MARK: - business logic
//
//    func signInKakao() {
//        if UserApi.isKakaoTalkLoginAvailable() {
//            UserApi.shared.rx.loginWithKakaoTalk()
//                .subscribe(onNext: { oauthToken in
//                    self.getKakaoUserInfo(authToken: "\(oauthToken)")
//                }, onError: {error in
//                    Log.error(error)
//                })
//            .disposed(by: disposeBag)
//        } else {
//            UserApi.shared.rx.loginWithKakaoAccount()
//                .subscribe(onNext: { oauthToken in
//                    self.getKakaoUserInfo(authToken: "\(oauthToken)")
//                }, onError: {error in
//                    Log.error(error)
//                })
//                .disposed(by: disposeBag)
//        }
//    }
//
//    func signInApple(vc: LoginViewController) {
//    }
//
//    func getKakaoUserInfo(authToken: String) {
//        UserApi.shared.rx.me()
//            .subscribe(onSuccess: { user in
////                let id = user.id
//                let loginInfo = LoginInfo(authToken: authToken, email: user.kakaoAccount?.email, snsType: .kakao)
//                self.getUserInfo(loginInfo: loginInfo)
//            }, onFailure: {error in
//                Log.error(error)
//            })
//            .disposed(by: disposeBag)
//    }
//
    
    // TODO: 서버에 회원 정보 request, user 정보 저장

}

// extension LoginViewModel: ASAuthorizationControllerDelegate {
    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            _ = credential.user
//        }
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            
//            // Create an account in your system .
////            let id = appleIDCredential.user
//            let token = appleIDCredential.identityToken
//            let email = appleIDCredential.email ?? ""
//            
//            let loginInfo = LoginInfo(authToken: String(describing: token), email: email, snsType: .apple)
//            self.getUserInfo(loginInfo: loginInfo)
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            
//        case let passwordCredential as ASPasswordCredential:
//            
//            // Sign in using an existing iCloud Keychain credential.
//            _ = passwordCredential.user
//            _ = passwordCredential.password
//            
//        default:
//            break
//        }
//    }
// }
