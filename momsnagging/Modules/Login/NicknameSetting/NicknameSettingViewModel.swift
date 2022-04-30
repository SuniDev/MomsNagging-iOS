//
//  NicknameSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import UIKit
import RxSwift
import RxCocoa

class NicknameSettingViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    private let loginInfo = PublishSubject<LoginInfo>()
    
    init(loginInfo: LoginInfo) {
        self.loginInfo.onNext(loginInfo)
    }
    
    // MARK: - Input
    struct Input {
    }
    
    // MARK: - Output
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
