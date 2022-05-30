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
        let isOnGeneralNotice = BehaviorRelay<Bool>(value: CommonUser.allowGeneralNotice ?? false)
        let isOnTodoNotice = BehaviorRelay<Bool>(value: CommonUser.allowTodoNotice ?? false)
        let isOnRoutineNotice = BehaviorRelay<Bool>(value: CommonUser.allowRoutineNotice ?? false)
        let isOnWeeklyNotice = BehaviorRelay<Bool>(value: CommonUser.allowWeeklyNotice ?? false)
        let isOnOtherNotice = BehaviorRelay<Bool>(value: CommonUser.allowOtherNotice ?? false)
        
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
                    isOnGeneralNotice.accept(user.allowGeneralNotice ?? isOnGeneralNotice.value)
                    isOnTodoNotice.accept(user.allowTodoNotice ?? isOnTodoNotice.value)
                    isOnRoutineNotice.accept(user.allowRoutineNotice ?? isOnRoutineNotice.value)
                    isOnWeeklyNotice.accept(user.allowWeeklyNotice ?? isOnWeeklyNotice.value)
                    isOnOtherNotice.accept(user.allowOtherNotice ?? isOnOtherNotice.value)
                }
            }).disposed(by: disposeBag)
        
        input.valueChangedGeneral.debug()
            .drive(onNext: { isOn in
                var request = PutUserRequest()
                request.allowGeneralNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        input.valueChangedTodo
            .drive(onNext: { isOn in
                var request = PutUserRequest()
                request.allowTodoNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        input.valueChangedRoutine
            .drive(onNext: { isOn in
                var request = PutUserRequest()
                request.allowRoutineNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        input.valueChangedWeekyly
            .drive(onNext: { isOn in
                var request = PutUserRequest()
                request.allowWeeklyNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        input.valueChangedOther
            .drive(onNext: { isOn in
                var request = PutUserRequest()
                request.allowOtherNotice = isOn
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        return Output(goToBack: input.btnBackTapped,
                      setGeneralNotice: isOnGeneralNotice.asDriverOnErrorJustComplete(),
                      setTodoNotice: isOnTodoNotice.asDriverOnErrorJustComplete(),
                      setRoutineNotice: isOnRoutineNotice.asDriverOnErrorJustComplete(),
                      setWeeklyNotice: isOnWeeklyNotice.asDriverOnErrorJustComplete(),
                      setOtherNotice: isOnOtherNotice.asDriverOnErrorJustComplete()
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
