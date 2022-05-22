//
//  MyViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class MyViewModel: BaseViewModel, ViewModelType {
    
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
extension MyViewModel {
    
}
