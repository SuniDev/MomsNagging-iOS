//
//  WritingDiaryViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import Foundation
import RxSwift
import RxCocoa

class WritingDiaryViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        let btnBackTapped: Driver<Void>
        let textTitle: Driver<String?>
        let editingDidEndOnExitTitle: Driver<Void>
        let didBeginContents: Driver<Void>
        let didEndEditingContents: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let endEditingTitle: Driver<Void>
        let setContentsPlaceholder: Driver<String>
//        let removeContentsPlaceholder: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let contentsPlaceHolder = PublishRelay<String>()
        let textContents = BehaviorRelay<String>(value: "")
        
        input.textTitle
            .drive(onNext: { text in
                let text = text ?? ""
                textContents.accept(text)
            }).disposed(by: disposeBag)
        
        input.didBeginContents
            .drive(onNext: {
                contentsPlaceHolder.accept(self.getContentsPlaceholder(.fondMom))
            }).disposed(by: disposeBag)
        
        return Output(endEditingTitle: input.editingDidEndOnExitTitle,
                      setContentsPlaceholder: contentsPlaceHolder.asDriverOnErrorJustComplete())
    }
}
extension WritingDiaryViewModel {
    
    private func getContentsPlaceholder(_ type: NaggingIntensity) -> String {
        switch type {
        case .fondMom: return "오늘 하루 어땠어~^^?"
        case .coolMom: return "오늘 어땠니."
        case .coldMom: return "너는 꼭 엄마가 먼저 물어봐야 대답하더라. 오늘 어떻게 보냈니?"
        }
    }
    
    private func getCompleteAlertTitle(_ type: NaggingIntensity) -> String {
        // TODO: 사용자 호칭 가져오기
        let nickName = "자식"
        
        switch type {
        case .fondMom: return "우리 \(nickName) 오늘 하루도 수고 많았어^^"
        case .coolMom: return "그래. 수고했다."
        case .coldMom: return "다했다고 놀지 말고 다음날 해야할 꺼 미리 미리 준비해놔라!"
        }
    }
}
