//
//  DeleteAccountViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift
import RxCocoa

class DeleteAccountViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    override init() {
    }
    // MARK: - Input
    struct Input {
    }
    // MARK: - Output
    struct Output {
        var inconvenienceList: Driver<[Inconvenience]>?
    }
    
    func transform(input: Input) -> Output {
//        let inconvenienceList: Driver<[Inconvenience]>?
        return Output(inconvenienceList: inconvenience())
    }
    
    func inconvenience() -> Driver<[Inconvenience]> {
        let returnData = BehaviorRelay<[Inconvenience]>(value: [])
        let list = ["서비스 이용이 불편해요.", "고객응대가 불만이에요.", "비슷한 서비스 앱이 더 좋아요.", "자주 사용하지 않아요."]
        var appendList: [Inconvenience] = []
        for item in list {
            var model = Inconvenience()
            model.contents = item
            appendList.append(model)
        }
        returnData.accept(appendList)
        return returnData.asDriver()
    }
}
// MARK: - API
extension DeleteAccountViewModel {
    
}

