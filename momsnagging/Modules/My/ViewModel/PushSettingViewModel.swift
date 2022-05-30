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
        let isOnGeneralNotice = BehaviorRelay<Bool>(value: CommonUser.allowGeneralNotice ?? false)
        let isOnTodoNotice = BehaviorRelay<Bool>(value: CommonUser.allowTodoNotice ?? false)
        let isOnRoutineNotice = BehaviorRelay<Bool>(value: CommonUser.allowRoutineNotice ?? false)
        let isOnWeeklyNotice = BehaviorRelay<Bool>(value: CommonUser.allowWeeklyNotice ?? false)
        let isOnOtherNotice = BehaviorRelay<Bool>(value: CommonUser.allowOtherNotice ?? false)
        
        // 스위치 트리거
        let setGeneralNotice = BehaviorRelay<Bool>(value: CommonUser.allowGeneralNotice ?? false)
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
            .flatMapLatest { request in
                return self.requestPutUser(request)
            }.share()
        
        let requestGetUser = requestPutUser
            .filter({ $0.id != nil })
            .flatMapLatest { _ in
                return self.requestGetUser()
            }.share()
        
        let setUser = requestGetUser
            .filter { $0.id != nil }
            .share()
        
        setUser
            .subscribe(onNext: { user in
                CommonUser.setUser(user) {
                    // TODO: 네트워크가 느리면 오류로 보여서.. 네이티브에서 자연스럽게 하는 것으로 변경
//                    isOnGeneralNotice.accept(user.allowGeneralNotice ?? isOnGeneralNotice.value)
//                    isOnTodoNotice.accept(user.allowTodoNotice ?? isOnTodoNotice.value)
//                    isOnRoutineNotice.accept(user.allowRoutineNotice ?? isOnRoutineNotice.value)
//                    isOnWeeklyNotice.accept(user.allowWeeklyNotice ?? isOnWeeklyNotice.value)
//                    isOnOtherNotice.accept(user.allowOtherNotice ?? isOnOtherNotice.value)
                }
            }).disposed(by: disposeBag)
        
        input.valueChangedGeneral.debug()
            .drive(onNext: { isOn in
                isOnGeneralNotice.accept(isOn)
                
                var request = PutUserRequest()
                request.allowGeneralNotice = isOn
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
