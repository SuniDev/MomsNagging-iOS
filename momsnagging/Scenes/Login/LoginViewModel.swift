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

class LoginViewModel: BaseViewModel, BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    // MARK: - Input
    struct Input {
        /// 구글 로그인
        let btnGoogleSignInTapped = PublishRelay<LoginViewController>()
    }
    
    // MARK: - Output
    struct Output {
        /// 회원가입으로 이동
        let shouldSignUp = PublishRelay<LoginInfo>()
        /// 회원 인증 성공
        let successLogin = PublishRelay<Void>()
        /// 로그인 오류 발생 (네트워크 오류)
        let error = PublishRelay<String>()
    }
    
    // MARK: - business logic
    override init() {
        super.init()
        
        // subscribe Input
        input.btnGoogleSignInTapped
            .subscribe(onNext: { [weak self] vc in
                guard let self = self else { return }
                self.signInGoogle(vc: vc)
            }).disposed(by: disposeBag)
    }
    
    func signInGoogle(vc: LoginViewController) {
        let signInConfig = GIDConfiguration(clientID: ApiList.getGooleClientID())
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            user.authentication.do { authentication, error in
                guard error == nil else { Log.error(error!); return }
                guard let authentication = authentication else { return }
                
                if authentication.idToken != nil {
                    let loginInfo = LoginInfo(authToken: user.userID, email: user.profile?.email, snsType: .google)
                    self.getUserInfo(loginInfo: loginInfo)
                } else {
                    Log.debug("Google Token nil")
                }
            }
        }
    }
    
    func getUserInfo(loginInfo: LoginInfo) {
        // TODO: 서버에 회원 정보 request, user 정보 저장
//        let user = User(loginInfo: loginInfo, nickname: "아들")
        output.successLogin.accept(())
    }

}
