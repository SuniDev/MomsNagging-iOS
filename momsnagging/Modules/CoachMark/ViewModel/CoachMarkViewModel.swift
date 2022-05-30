//
//  CoachMarkViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/30.
//

import Foundation
import RxSwift
import RxCocoa


class CoachMarkViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
    }
    
    // MARK: - Output
    struct Output {
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        return Output()
    }

}
