//
//  HomeViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel, ViewModelType {
    
    // MARK: Properties
    var disposeBag = DisposeBag()

    override init() {
    }
    // MARK: - Input
    struct Input {
        var floatingBtnStatus: Bool?
    }
    // MARK: - Output
    struct Output {
        var floatingBtnIc: Driver<Bool>?
    }
    
    func transform(input: Input) -> Output {
        let floatingBtnIc = BehaviorRelay<Bool>(value: false)
        if input.floatingBtnStatus ?? true {
            floatingBtnIc.accept(false)
        } else {
            floatingBtnIc.accept(true)
        }
        return Output(floatingBtnIc: floatingBtnIc.asDriver())
    }
    
}
