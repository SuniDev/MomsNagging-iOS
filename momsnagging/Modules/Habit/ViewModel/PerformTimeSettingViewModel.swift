//
//  PerformTimeSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/10.
//

import Foundation
import RxSwift
import RxCocoa

class PerformTimeSettingViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var perfromTime: BehaviorRelay<String?>
    let timeGuideItems = BehaviorRelay<[String]>(value: [])
    
    enum TextHintType: String {
        case invalid    = "수행 시간은 11글자를 넘길 수 없단다."
        case none       = ""
    }
    
    init(performTime: String? = "") {
        self.perfromTime = BehaviorRelay<String?>(value: performTime)
    }
    
    // MARK: - Input
    struct Input {
        /// 생명 주기
        let willAppearPerformTimeSetting: Driver<Void>
        /// 해더
        let btnCacelTapped: Driver<Void>
        /// 수행 시간
        let textTime: Driver<String>
        let editingDidBeginTime: Driver<Void>
        let editingDidEndTime: Driver<Void>
        let timeGuideItemSelected: Driver<IndexPath>
        let btnSaveTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 뒤로 가기
        let goToBack: Driver<Void>
        /// 수행 시간 텍스트
        let setTextTime: Driver<String>
        /// 이름 수정 중
        let isEditingTime: Driver<Bool>
        /// 텍스트 힌트
        let textHint: Driver<TextHintType>
        /// 텍스트 카운트
        let textConunt: Driver<Int>
        /// 수행 시간 가이드 갯수
        let cntTimeGuide: Driver<Int>
        /// 수행 시간 가이드 아이템
        let timeGuideItems: BehaviorRelay<[String]>
        /// 저장 가능
        let canBeSave: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let textTime = BehaviorRelay<String>(value: "")
        let setTextTime = BehaviorRelay<String>(value: self.perfromTime.value ?? "")
        let isEditingTime = BehaviorRelay<Bool>(value: false)
        let isEmptyTime = BehaviorRelay<Bool>(value: true)
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        let textCount = BehaviorRelay<Int>(value: 0)
        let timeGuideItems = BehaviorRelay<[String]>(value: [])
        
        /// 수행 시간 : input -> output
        input.textTime
            .drive(onNext: { text in
                textTime.accept(text)
            }).disposed(by: disposeBag)
        
        textTime
            .map { $0.count }
            .bind(to: textCount)
            .disposed(by: disposeBag)
        
        input.editingDidBeginTime
            .drive(onNext: { () in
                textHint.accept(.none)
                isEditingTime.accept(true)
            }).disposed(by: disposeBag)
        
        let editingDidEndTime = input.editingDidEndTime.asObservable().share()
        editingDidEndTime
            .bind(onNext: { () in
                isEditingTime.accept(false)
            }).disposed(by: disposeBag)
        editingDidEndTime
            .flatMapLatest { _ -> Observable<Bool> in
                Observable.just(textTime.value.isEmpty)
            }.bind(to: isEmptyTime)
            .disposed(by: disposeBag)
        
        isEmptyTime.filter({ $0 == true })
            .bind(onNext: { _ in
                textHint.accept(.none)
            }).disposed(by: disposeBag)
        
        // 사용 가능 여부 확인 (띄어쓰기 포함 한/영/숫자/이모지 11글자)
        let isValidName = isEmptyTime
            .filter({ $0 == false })
            .flatMapLatest { _ -> Observable<Bool> in
                return self.isValidTime(textTime.value)
            }.share()
        
        isValidName
            .bind(onNext: { isValid in
                textHint.accept(isValid ? .none : .invalid)
            }).disposed(by: disposeBag)
        
        /// 수행 시간 가이드
        input.willAppearPerformTimeSetting
            .asObservable()
            .flatMapLatest { () -> Observable<[String]> in
                return self.getTimeGuideItems()
            }.subscribe(onNext: { items in
                timeGuideItems.accept(items)
            }).disposed(by: disposeBag)
        
        let cntTimeGuide = timeGuideItems.skip(1)
            .map { return $0.count }
        
        timeGuideItems.bind(to: self.timeGuideItems).disposed(by: disposeBag)
        
        input.timeGuideItemSelected
            .drive(onNext: { indexPath in
                let text = timeGuideItems.value[indexPath.row]
                setTextTime.accept(text)
            }).disposed(by: disposeBag)
        
        setTextTime
            .filter { !$0.isEmpty }
            .bind(onNext: { text in
                textTime.accept(text)
                
                if !isEditingTime.value {
                    isEmptyTime.accept(false)
                }
            }).disposed(by: disposeBag)
        
        let canBeSave = textTime
            .flatMapLatest { _ -> Observable<Bool> in
                return self.isValidTime(textTime.value)
            }
        
        let saveTime = input.btnSaveTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<String> in
                return textTime.asObservable()
            }.share()
        
        saveTime
            .bind(to: self.perfromTime)
            .disposed(by: disposeBag)
        
        let goToBack = Observable.of(input.btnCacelTapped.asObservable(), saveTime.mapToVoid()).merge()
        
        return Output(
            goToBack: goToBack.asDriverOnErrorJustComplete(),
            setTextTime: setTextTime.asDriver(onErrorJustReturn: ""),
            isEditingTime: isEditingTime.asDriverOnErrorJustComplete(),
            textHint: textHint.asDriverOnErrorJustComplete(),
            textConunt: textCount.asDriverOnErrorJustComplete(),
            cntTimeGuide: cntTimeGuide.asDriverOnErrorJustComplete(),
            timeGuideItems: timeGuideItems,
            canBeSave: canBeSave.asDriver(onErrorJustReturn: false)
        )
    }
}
extension PerformTimeSettingViewModel {
    func getTimeGuideItems() -> Observable<[String]> {
        return Observable<[String]>.create { observer -> Disposable in
            var items = [String]()
            items.append("아무때나")
            items.append("항상")
            items.append("오후 11:00")
            items.append("자기 전")
            items.append("침대에서")
            items.append("앱 켤때마다")
            items.append("눈 뜨자마자")
            items.append("퇴근할 때")
            items.append("지하철에서")
            observer.onNext(items)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func isValidTime( _ text: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if text.isEmpty || text.count > 11 {
                observer.onNext(false)
                observer.onCompleted()
            } else {
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
