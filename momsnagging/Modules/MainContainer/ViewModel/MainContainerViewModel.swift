//
//  MainContainerViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class MainContainerViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var tabHandler = PublishRelay<Int>()
    
    override init() {
    }
    // MARK: - Input
    struct Input {
        var buttonTag: Observable<Int>
    }
    // MARK: - Output
    struct Output {
        var buttonLabelColorList: [Driver<ColorAsset>]
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        let tabBar1 = BehaviorRelay(value: Asset.Color.priMain)
        let tabBar2 = BehaviorRelay(value: Asset.Color.priMain)
        let tabBar3 = BehaviorRelay(value: Asset.Color.priMain)
        
        input.buttonTag.bind(onNext: { tagNum in
            self.tabHandler.accept(tagNum)
            
            if tagNum == 0 {
                tabBar1.accept(Asset.Color.priMain)
                tabBar2.accept(Asset.Color.monoDark020)
                tabBar3.accept(Asset.Color.monoDark020)
            } else if tagNum == 1 {
                tabBar1.accept(Asset.Color.monoDark020)
                tabBar2.accept(Asset.Color.priMain)
                tabBar3.accept(Asset.Color.monoDark020)
            } else {
                tabBar1.accept(Asset.Color.monoDark020)
                tabBar2.accept(Asset.Color.monoDark020)
                tabBar3.accept(Asset.Color.priMain)
            }
        }).disposed(by: disposeBag)
        
        return Output(buttonLabelColorList: [tabBar1.asDriver(), tabBar2.asDriver(), tabBar3.asDriver()])
    }
    
}

extension MainContainerViewModel {
    
}
