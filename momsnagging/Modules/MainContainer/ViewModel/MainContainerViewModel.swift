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
    var testOb = PublishSubject<Bool>()
        
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
                self.testOb.onNext(false)
            } else if tagNum == 1 {
                tabBar1.accept(Asset.Color.monoDark020)
                tabBar2.accept(Asset.Color.priMain)
                tabBar3.accept(Asset.Color.monoDark020)
                self.testOb.onNext(false)
            } else {
                tabBar1.accept(Asset.Color.monoDark020)
                tabBar2.accept(Asset.Color.monoDark020)
                tabBar3.accept(Asset.Color.priMain)
                self.testOb.onNext(false)
            }
        }).disposed(by: disposeBag)
        
        return Output(buttonLabelColorList: [tabBar1.asDriver(), tabBar2.asDriver(), tabBar3.asDriver()])
    }
    
}

extension MainContainerViewModel {
    func checkEvaluation() -> Observable<WeeklyEvaluationViewModel?> {
        return Observable<WeeklyEvaluationViewModel?>.create { observer -> Disposable in
            let isShow = self.isShowEvaluation()
            isShow
                .filter({ $0 == true })
                .flatMapLatest { _ -> Observable<WeeklyEvaluationViewModel> in
                    let viewModel = WeeklyEvaluationViewModel(withService: SceneDelegate.appService)
                    return Observable.just(viewModel)
                }.subscribe(onNext: { viewModel in
                    observer.onNext(viewModel)
                    observer.onCompleted()
                }).disposed(by: self.disposeBag)
            
            observer.onNext(nil)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func isShowEvaluation() -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let lastCheckDate = Common.getUserDefaultsObject(forKey: .dateLastCheckEvaluation) as? Date {
                
                // ======= Test Data Start ============
//            if let lastCheckDate = "2022-05-30".toDate(for: "yyyy-MM-dd", locale: Locale(identifier: "ko_KR")) {
                // ======= Test Data End ============
                
                // 기준 날짜의 월요일
                let weekday = lastCheckDate.getWeekDay() // (월 : 0 ~ 일 :6)
                let date = Calendar.current.date(byAdding: .day, value: -weekday, to: lastCheckDate) ?? lastCheckDate
                
                // 현재 날짜의 월요일
                var now = Date().to(for: "yyyy-MM-dd", locale: Locale(identifier: "ko_KR"))
                let nowWeekDay = now.getWeekDay()
                now = Calendar.current.date(byAdding: .day, value: -nowWeekDay, to: now) ?? now
                
                // 비교
                let componentDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
                let componentNow = Calendar.current.dateComponents([.year, .month, .day], from: now)
                                
                if componentNow.day == componentDate.day {
                    observer.onNext(false)
                    observer.onCompleted()
                }
                observer.onNext(true)
                observer.onCompleted()
            } else {
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
