//
//  ContactUsViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift
import RxCocoa

class ContactUsViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var provider = MoyaProvider<QuestionService>()
    var requestQuestionSuccessOb = PublishSubject<Void>()

    override init() {
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
// MARK: - API
extension ContactUsViewModel {
    func requestCreateQuestion(context: String?){
        let param = QuestionRequestModel.init(title: "사용자 문의", context: context)
        provider.request(.createQuestion(param: param), completion: { res in
            switch res {
            case .success(let result):
                do {
                    let json = JSON(try result.mapJSON())
                    print("requestCreateQuestion json : \(json)")
                    self.requestQuestionSuccessOb.onNext(())
                } catch let error {
                    Log.debug("requestCreateQuestion error", "\(error)")
                }
            case .failure(let error):
                Log.debug("requestCreateQuestion failure error", "\(error)")
            }
        })
    }
}
