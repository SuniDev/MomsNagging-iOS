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
        let btnBackTapped: Driver<Void>
        let valueChangedGeneral: Driver<Bool>
        let valueChangedTodo: Driver<Bool>
        let valueChangedRoutine: Driver<Bool>
        let valueChangedWeekyly: Driver<Bool>
        let valueChangedOther: Driver<Bool>
    }
    
    // MARK: - Output
    struct Output {
        let goToBack: Driver<Void>
        let setGeneralNotice: Driver<Bool>
        let setTodoNotice: Driver<Bool>
        let setRoutineNotice: Driver<Bool>
        let setWeeklyNotice: Driver<Bool>
        let setOtherNotice: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let requestPutUserTrigger = PublishRelay<PutUserRequest>()
        // 상태 체크
        let isOnTodoNotice = BehaviorRelay<Bool>(value: CommonUser.allowTodoNotice ?? false)
        let isOnRoutineNotice = BehaviorRelay<Bool>(value: CommonUser.allowRoutineNotice ?? false)
        let isOnWeeklyNotice = BehaviorRelay<Bool>(value: CommonUser.allowWeeklyNotice ?? false)
        let isOnOtherNotice = BehaviorRelay<Bool>(value: CommonUser.allowOtherNotice ?? false)
        let isOnGeneralNotice = BehaviorRelay<Bool>(value: CommonUser.getGeneralNotice())
        
        // 스위치 트리거
        let setGeneralNotice = BehaviorRelay<Bool>(value: CommonUser.getGeneralNotice())
        setGeneralNotice
            .bind(to: isOnGeneralNotice)
            .disposed(by: disposeBag)
        let setTodoNotice = BehaviorRelay<Bool>(value: CommonUser.allowTodoNotice ?? false)
        setTodoNotice
            .bind(to: isOnTodoNotice)
            .disposed(by: disposeBag)
        let setRoutineNotice = BehaviorRelay<Bool>(value: CommonUser.allowRoutineNotice ?? false)
        setRoutineNotice
            .bind(to: isOnRoutineNotice)
            .disposed(by: disposeBag)
        let setWeeklyNotice = BehaviorRelay<Bool>(value: CommonUser.allowWeeklyNotice ?? false)
        setWeeklyNotice
            .bind(to: isOnWeeklyNotice)
            .disposed(by: disposeBag)
        let setOtherNotice = BehaviorRelay<Bool>(value: CommonUser.allowOtherNotice ?? false)
        setOtherNotice
            .bind(to: isOnOtherNotice)
            .disposed(by: disposeBag)
        
        let requestPutUser = requestPutUserTrigger
            .flatMapLatest { request -> Observable<UserResult> in
                self.isLoading.accept(true)
                return self.requestPutUser(request)
            }.share()
        
        requestPutUser
            .bind(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
        let requestGetUser = requestPutUser
            .filter({ $0.id != nil })
            .flatMapLatest { _ -> Observable<User> in
                return self.requestGetUser()
            }.share()
        
        let setUser = requestGetUser
            .filter { $0.id != nil }
            .share()
        
        setUser
            .subscribe(onNext: { user in
                CommonUser.setUser(user)
            }).disposed(by: disposeBag)
        
        input.valueChangedGeneral
            .drive(onNext: { isOn in
                isOnGeneralNotice.accept(isOn)
                
                var request = PutUserRequest()
                request.allowTodoNotice = isOn
                request.allowRoutineNotice = isOn
                request.allowWeeklyNotice = isOn
                request.allowOtherNotice = isOn
                requestPutUserTrigger.accept(request)
                
                setTodoNotice.accept(isOn)
                setRoutineNotice.accept(isOn)
                setWeeklyNotice.accept(isOn)
                setOtherNotice.accept(isOn)
            }).disposed(by: disposeBag)
        
        let valueChangedTodo = input.valueChangedTodo.asObservable().share()
        valueChangedTodo
            .subscribe(onNext: { isOn in
                isOnTodoNotice.accept(isOn)
                
                var request = PutUserRequest()
                request.allowTodoNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        let valueChangedRoutine = input.valueChangedRoutine.asObservable().share()
        valueChangedRoutine
            .subscribe(onNext: { isOn in
                isOnRoutineNotice.accept(isOn)
                
                var request = PutUserRequest()
                request.allowRoutineNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        let valueChangedWeekyly = input.valueChangedWeekyly.asObservable().share()
        valueChangedWeekyly
            .subscribe(onNext: { isOn in
                isOnWeeklyNotice.accept(isOn)
                
                var request = PutUserRequest()
                request.allowWeeklyNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        let valueChangedOther = input.valueChangedOther.asObservable().share()
        valueChangedOther
            .subscribe(onNext: { isOn in
                isOnOtherNotice.accept(isOn)
                
                var request = PutUserRequest()
                request.allowOtherNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(isOnTodoNotice, isOnRoutineNotice, isOnWeeklyNotice, isOnOtherNotice)
            .subscribe(onNext: { todo, routine, weekly, other in
                setGeneralNotice.accept(todo && routine && weekly && other)
            }).disposed(by: disposeBag)
        
        return Output(goToBack: input.btnBackTapped,
                      setGeneralNotice: setGeneralNotice.distinctUntilChanged().asDriverOnErrorJustComplete(),
                      setTodoNotice: setTodoNotice.distinctUntilChanged().asDriverOnErrorJustComplete(),
                      setRoutineNotice: setRoutineNotice.distinctUntilChanged().asDriverOnErrorJustComplete(),
                      setWeeklyNotice: setWeeklyNotice.distinctUntilChanged().asDriverOnErrorJustComplete(),
                      setOtherNotice: setOtherNotice.distinctUntilChanged().asDriverOnErrorJustComplete()
        )
    }
}
// MARK: - API
extension PushSettingViewModel {
    private func requestPutUser(_ request: PutUserRequest) -> Observable<UserResult> {
        return self.provider.userService.putUser(request: request)
    }
    
    private func requestGetUser() -> Observable<User> {
        let request = GetUserRequest()
        return self.provider.userService.getUser(request: request)
    }
}
