//
//  PushSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation
import RxSwift
import RxCocoa

class PushSettingViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
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

extension PushSettingViewModel {
    
}
