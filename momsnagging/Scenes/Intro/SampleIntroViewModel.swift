//
//  IntroViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import Foundation
import RxSwift

// TODO: - Navigator PR후, 네이밍 수정.
class SampleIntroViewModel {
    
    // MARK: - Properties
    var isAutoLogin: Observable<Bool>?
    
    func getLoginInfo() {
        // TODO: - 자동 로그인 여부 체크
        isAutoLogin = Observable.just(false)
    }
}
