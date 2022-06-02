//
//  AwardViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import RxSwift
import RxCocoa

class AwardViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let willApearView: Driver<Void>
        let btnCloseTapped: Driver<Void>
        let viewTapped: Driver<Void>
    }
    // MARK: - Output
    struct Output {
        let setAwardLevel: Driver<Int>
        let dismiss: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let requestAwards = input.willApearView
            .asObservable()
            .flatMapLatest { _ -> Observable<Awards> in
                return self.requestAwards()
            }.share()
        
        let setAwardLevel = requestAwards
            .filter { $0.level != nil }
            .map { $0.level ?? 0 }
            .share()
        
        let dismiss = Observable.merge(input.btnCloseTapped.asObservable(), input.viewTapped.asObservable())
        
        return Output(setAwardLevel: setAwardLevel.asDriverOnErrorJustComplete(),
                      dismiss: dismiss.asDriverOnErrorJustComplete())
    }
}
// MARK: - API
extension AwardViewModel {
    private func requestAwards() -> Observable<Awards> {
        let request = AwardsRequest()
        return self.provider.gradeService.award(request: request)
    }
}
