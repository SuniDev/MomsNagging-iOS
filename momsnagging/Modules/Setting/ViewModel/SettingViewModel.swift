//
//  SettingViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class SettingViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    override init() {
    }
    // MARK: - Input
    struct Input {
    }
    // MARK: - Output
    struct Output {
        var settingListData: Driver<[String]>?
    }
    
    func transform(input: Input) -> Output {
        
        return Output(settingListData: settingList())
    }
    
    func settingList() -> Driver<[String]> {
        let returnList = BehaviorRelay<[String]>(value: [])
        let list: [String] = ["개인정보 처리방침", "문의하기", "회원탈퇴", "앱 버전"]
        returnList.accept(list)
        return returnList.asDriver()
    }
    
}
// MARK: - API
extension SettingViewModel {
    
}
