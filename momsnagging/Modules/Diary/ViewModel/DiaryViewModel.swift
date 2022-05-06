//
//  DiaryViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/06.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift
import RxCocoa

class DiaryViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()

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
extension DiaryViewModel {
    
}
