//
//  DetailDiaryViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import Foundation
import RxSwift
import RxCocoa

class DetailDiaryViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    private let isNew: BehaviorRelay<Bool>
    
    // TODO: Diary 날짜 받기
    init(withService provider: AppServices, isNew: Bool) {
        self.isNew = BehaviorRelay<Bool>(value: isNew)
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        /// 더보기
        let btnMoreTapped: Driver<Void>
        let dimViewTapped: Driver<Void>
        let btnModifyTapped: Driver<Void>
        let btnDeleteTapped: Driver<Void>
        /// 뒤로가기
        let btnBackTapped: Driver<Void>
        let backAlertDoneHandler: Driver<Void>
        /// 삭제하기
        let deleteAlertDoneHandler: Driver<Void>
        /// 작성
        let textTitle: Driver<String?>
        let textContents: Driver<String?>
        let editingDidEndOnExitTitle: Driver<Void>
        let didBeginContents: Driver<Void>
        let didEndEditingContents: Driver<Void>
        /// 완료
        let btnDoneTapped: Driver<Void>
        let doneAlertDoneHandler: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        ///  바텀 시트
        let showBottomSheet: Driver<Void>
        let hideBottomSheet: Driver<Void>
        /// 작성 모드
        let isWriting: Driver<Bool>
        /// 뒤로 가기
        let showBackAlert: Driver<String>
        let goToBack: Driver<Void>
        /// 삭제 하기
        let showDeleteAlert: Driver<String>
        /// 제목 리턴
        let endEditingTitle: Driver<Void>
        /// 내용 플레이스홀더
        let setContentsPlaceholder: Driver<String>
        /// 작성 완료 가능
        let canBeDone: Driver<Bool>
        /// 다이어리 작성 완료
        let successDoneDiary: Driver<String>
        /// 제목 30자 이내 텍스트 (글자 제한)
        let setTextTitle: Driver<String>
        /// 제목 길이 초과 (30자)
        let lengthExceededTitle: Driver<Void>
        /// 내용 1000자 이내 텍스트 (글자 제한)
        let setTextContents: Driver<String>
        /// 내용 길이 초과 (1000자)
        let lengthExceededContents: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let isWriting = BehaviorRelay<Bool>(value: false)
        let contentsPlaceHolder = BehaviorRelay<String>(value: "")
        let isNew = self.isNew
        
        let textTitle = BehaviorRelay<String>(value: "")
        let textContents = BehaviorRelay<String>(value: "")
        let lengthExceededTitle = PublishRelay<Void>()
        let lengthExceededContents = PublishRelay<Void>()
        
        /// 작성 모드
        isNew
            .bind(onNext: {
                isWriting.accept($0)
            }).disposed(by: disposeBag)
        
        let btnModifyTapped = input.btnModifyTapped.asObservable().share()
        
        btnModifyTapped
            .subscribe(onNext: {
                isNew.accept(false)
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        let btnDeleteTapped = input.btnDeleteTapped.asObservable()
        
        let hideBottomSheet = Observable.merge(btnModifyTapped, input.dimViewTapped.asObservable(), btnDeleteTapped)
        let showDeleteAlert = btnDeleteTapped
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_DIARY_DELETE)
            }
        
        isWriting
            .filter { $0 == true }
            .flatMapLatest({ _ -> Observable<String> in
                // TODO: 사용자 잔소리 강도
                return self.getContentsPlaceholder(.fondMom)
            })
            .subscribe(onNext: { text in
                if textContents.value.isEmpty {
                    contentsPlaceHolder.accept(text)
                }
            }).disposed(by: disposeBag)
                
        let btnBackTapped = input.btnBackTapped.asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(isWriting.value)
            }.share()
        
        let showBackAlert = btnBackTapped
            .filter { $0 == true }
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_DIARY_BACK)
            }
        
        let backAlertDoneHandler = input.backAlertDoneHandler
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(self.isNew.value)
            }.share()
        
        let goToBack = Observable.merge(
            backAlertDoneHandler.filter { $0 == true }.mapToVoid(),
            btnBackTapped.filter { $0 == false }.mapToVoid(), input.deleteAlertDoneHandler.asObservable())
            
        backAlertDoneHandler
            .filter { $0 == false }
            .mapToVoid()
            .subscribe(onNext: {
                isWriting.accept(false)
            }).disposed(by: disposeBag)
        
        /// 일기작 작성
        input.textTitle
            .asObservable()
            .scan("") { previous, new -> String in
                guard let new = new else { return "" }
                if new.count > 30 {
                    lengthExceededTitle.accept(())
                    return previous
                } else {
                    return new
                }
            }.subscribe(onNext: { text in
                textTitle.accept(text)
            }).disposed(by: disposeBag)
        
        input.textContents
            .asObservable()
            .scan("") { previous, new -> String in
                guard let new = new else { return "" }
                if new.count > 20 {
                    lengthExceededContents.accept(())
                    return previous
                } else {
                    return new
                }
            }.subscribe(onNext: { text in
                textContents.accept(text)
            }).disposed(by: disposeBag)
        
        input.didBeginContents
            .drive(onNext: {
                if !contentsPlaceHolder.value.isEmpty {
                    contentsPlaceHolder.accept("")
                }
            }).disposed(by: disposeBag)

        input.didEndEditingContents
            .asObservable()
            .flatMapLatest({ _ -> Observable<String> in
                // TODO: 사용자 잔소리 강도
                return self.getContentsPlaceholder(.fondMom)
            })
            .subscribe(onNext: { text in
                if textContents.value.isEmpty {
                    contentsPlaceHolder.accept(text)
                }
            }).disposed(by: disposeBag)
        
        let canBeDone = Observable.combineLatest(textTitle.asObservable(), textContents.asObservable())
            .map({ dTitle, dContents -> Bool in
                if !dTitle.isEmpty && !dContents.isEmpty && contentsPlaceHolder.value.isEmpty {
                    return true
                }
                return false
            })
        
        // TODO: Request 일기장 저장 API
        let successDoneDiary = input.btnDoneTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<String> in
                // TODO: 사용자 잔소리 강도
                return self.getDoneAlertTitle(.fondMom)
            }
        
        input.doneAlertDoneHandler
            .drive(onNext: {
                isWriting.accept(false)
            }).disposed(by: disposeBag)
        
        return Output(showBottomSheet: input.btnMoreTapped,
                      hideBottomSheet: hideBottomSheet.asDriverOnErrorJustComplete(),
                      isWriting: isWriting.asDriverOnErrorJustComplete(),
                      showBackAlert: showBackAlert.asDriver(onErrorJustReturn: STR_DIARY_BACK),
                      goToBack: goToBack.asDriverOnErrorJustComplete(),
                      showDeleteAlert: showDeleteAlert.asDriver(onErrorJustReturn: STR_DIARY_DELETE),
                      endEditingTitle: input.editingDidEndOnExitTitle,
                      setContentsPlaceholder: contentsPlaceHolder.asDriverOnErrorJustComplete(),
                      canBeDone: canBeDone.asDriverOnErrorJustComplete(),
                      successDoneDiary: successDoneDiary.asDriverOnErrorJustComplete(),
                      setTextTitle: textTitle.asDriverOnErrorJustComplete(),
                      lengthExceededTitle: lengthExceededTitle.asDriverOnErrorJustComplete(),
                      setTextContents: textContents.asDriverOnErrorJustComplete(),
                      lengthExceededContents: lengthExceededContents.asDriverOnErrorJustComplete())
    }
}
extension DetailDiaryViewModel {
    
    private func getContentsPlaceholder( _ type: NaggingIntensity) -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            switch type {
            case .fondMom: observer.onNext("오늘 하루 어땠어~^^?")
            case .coolMom: observer.onNext("오늘 어땠니.")
            case .angryMom: observer.onNext("너는 꼭 엄마가 먼저 물어봐야 대답하더라. 오늘 어떻게 보냈니?")
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func getDoneAlertTitle(_ type: NaggingIntensity) -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            // TODO: 사용자 호칭 가져오기
            let nickName = "자식"
            switch type {
            case .fondMom: observer.onNext("우리 \(nickName) 오늘 하루도 수고 많았어^^")
            case .coolMom: observer.onNext("그래. 수고했다.")
            case .angryMom: observer.onNext("다했다고 놀지 말고 다음날 해야할 꺼 미리 미리 준비해놔라!")
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
