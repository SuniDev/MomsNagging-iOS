//
//  DetailDiaryViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import Foundation
import RxSwift
import RxCocoa

class DetailDiaryViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    private let isNew: BehaviorRelay<Bool>
    
    init(isNew: Bool) {
        self.isNew = BehaviorRelay<Bool>(value: isNew)
    }
    
    // MARK: - Input
    struct Input {
        let btnBackTapped: Driver<Void>
        let textTitle: Driver<String?>
        let textContents: Driver<String?>
        let editingDidEndOnExitTitle: Driver<Void>
        let didBeginContents: Driver<Void>
        let didEndEditingContents: Driver<Void>
        let btnDoneTapped: Driver<Void>
        let btnModifyTapped: Driver<Void>
        let doneAlertDoneHandler: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 작성 모드
        let isWriting: Driver<Bool>
        /// 뒤로 가기
        let goToBack: Driver<Void>
        /// 제목 리턴
        let endEditingTitle: Driver<Void>
        /// 내용 플레이스홀더
        let setContentsPlaceholder: Driver<String>
        /// 작성 완료 가능
        let canBeDone: Driver<Bool>
        /// 다이어리 작성 완료
        let successDoneDiary: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let isWriting = BehaviorRelay<Bool>(value: false)
        let contentsPlaceHolder = BehaviorRelay<String>(value: "")
        let textTitle = BehaviorRelay<String>(value: "")
        let textContents = BehaviorRelay<String>(value: "")
        
        self.isNew
            .bind(onNext: {
                isWriting.accept($0)
            }).disposed(by: disposeBag)
        
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
        
        input.btnModifyTapped
            .drive(onNext: {
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        input.textTitle
            .drive(onNext: { text in
                let text = text ?? ""
                textTitle.accept(text)
            }).disposed(by: disposeBag)
        
        input.textContents
            .drive(onNext: { text in
                let text = text ?? ""
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
        
        return Output(isWriting: isWriting.asDriverOnErrorJustComplete(),
                      goToBack: input.btnBackTapped,
                      endEditingTitle: input.editingDidEndOnExitTitle,
                      setContentsPlaceholder: contentsPlaceHolder.asDriverOnErrorJustComplete(),
                      canBeDone: canBeDone.asDriverOnErrorJustComplete(),
                      successDoneDiary: successDoneDiary.asDriverOnErrorJustComplete())
    }
}
extension DetailDiaryViewModel {
    
    private func getContentsPlaceholder( _ type: NaggingIntensity) -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            switch type {
            case .fondMom: observer.onNext("오늘 하루 어땠어~^^?")
            case .coolMom: observer.onNext("오늘 어땠니.")
            case .coldMom: observer.onNext("너는 꼭 엄마가 먼저 물어봐야 대답하더라. 오늘 어떻게 보냈니?")
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
            case .coldMom: observer.onNext("다했다고 놀지 말고 다음날 해야할 꺼 미리 미리 준비해놔라!")
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
