//
//  ReportCardViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class ReportCardViewModel: BaseViewModel, ViewModelType{
    
    var disposeBag = DisposeBag()
    
    override init(){
    }
    // MARK: - Input
    struct Input {
        var tabAction: Driver<Bool>
    }
    // MARK: - Output
    struct Output {
        var tabAction = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        let tabAction = PublishRelay<Bool>()
        
        input.tabAction.drive { bool in
            if bool {
                tabAction.accept(true)
            } else {
                tabAction.accept(false)
            }
        }.disposed(by: disposeBag)
        
        return Output(tabAction: tabAction)
    }
    
}
// MARK: - API
extension ReportCardViewModel {
    
}
