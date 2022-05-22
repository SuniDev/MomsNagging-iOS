//
//  SettingViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class SettingViewModel: BaseViewModel, ViewModelType {
    
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
extension SettingViewModel {
    
}
