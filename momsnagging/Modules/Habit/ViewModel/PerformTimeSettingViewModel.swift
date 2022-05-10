//
//  PerformTimeSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/10.
//

import Foundation
import RxSwift
import RxCocoa

class PerformTimeSettingViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        let btnCacelTapped: Driver<Void>
        let btnSaveTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let goToBack: Driver<Void>
//        let savePerformTime: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        return Output(goToBack: input.btnCacelTapped)
    }
}
