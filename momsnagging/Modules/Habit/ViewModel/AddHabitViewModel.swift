//
//  AddHabitViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/07.
//

import Foundation
import RxSwift
import RxCocoa

class AddHabitViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
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
