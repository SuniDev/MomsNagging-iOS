//
//  PrivacyPolicyViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class PrivacyPolicyViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    override init() {
    }
    // MARK: - Input
    struct Input {
    }
    // MARK: - Output
    struct Output {
        var privacyPolicyListData: Driver<[PrivacyPolicyModel]>?
    }
    
    func transform(input: Input) -> Output {
        return Output(privacyPolicyListData: privacyPolicyList())
    }
    func privacyPolicyList() -> Driver<[PrivacyPolicyModel]> {
        let returnList = BehaviorRelay<[PrivacyPolicyModel]>(value: [])
        var list: [PrivacyPolicyModel] = []
        let titleList = ["1. 개인정보 처리방침", "2. 개인정보 수집 목적", "3. 수집하는 개인정보의 항목", "4. 개인정보의 처리 및 보유 기간", "5. 개인정보 파기"]
        let contentsList = ["""
                                    1. 개인정보 처리방침 (검토중)
                            """,
                            """
                                    2. 개인정보 수집 목적 (검토중)
                            """,
                            """
                                    3. 수집하는 개인정보의 항목 (검토중)
                            """,
                            """
                                    4. 개인정보의 처리 및 보유 기간 (검토중)
                            """,
                            """
                                    5. 개인정보 파기 (검토중)
                            """]
        for i in 0..<4 {
           var model = PrivacyPolicyModel()
            model.title = titleList[i]
            model.contents = contentsList[i]
            list.append(model)
        }
        returnList.accept(list)
        return returnList.asDriver()
    }
}
// MARK: - API
extension PrivacyPolicyViewModel {
    
}
