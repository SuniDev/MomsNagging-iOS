//
//  OnboardingPageViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/24.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingPageViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let datas = PublishRelay<[Onboarding]>()
    private let itemsVCs = PublishRelay<[OnboardingItemViewController]>()
    
    override init() {
        // TODO: 온보딩 이미지 초기화
//        var onboardDatas = [Onboarding]()
//        onboardDatas.append(Onboarding(index: 0, title: "1. 습관/할일 추가", message: "반복되는 습관과 할일을 추가해\n너만의 목록을 만들어 보렴!", image: nil))
//        onboardDatas.append(Onboarding(index: 1, title: "2. 추천 습관", message: "무엇을 해야할지 모르는\n아들/딸들을 위해\n추천습관 목록이 있단다!", image: nil))
//        onboardDatas.append(Onboarding(index: 2, title: "3. 엄마가 잔소리 해주는 푸쉬 알림", message: "엄마의 친숙한 말투로\n잔소리 push 알림을\n제공해준단다!", image: nil))
//        onboardDatas.append(Onboarding(index: 3, title: "4. 3단계 잔소리 강도 설정", message: "다정한 엄마, 냉정한 엄마,\n화가 많은 엄마, 세 가지 타입 중\n원하는 잔소리를 고르렴!", image: nil))
//        onboardDatas.append(Onboarding(index: 4, title: "5. 이 외 기능", message: "이 이외에도 다양한 기능들이\n있으니 사용해보렴!", image: nil))
        datas.accept(datas.value + [Onboarding(index: 0, title: "1. 습관/할일 추가", message: "반복되는 습관과 할일을 추가해\n너만의 목록을 만들어 보렴!", image: nil)])
        
    }
    
    // MARK: - Input
    struct Input {
        
    }
    
    // MARK: - Output
    struct Output {
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        datas.asObservable().subscribe({
            var items = self.itemsVCs.values
            for data in $0 {
                let vc = OnboardingItemViewController(viewModel: OnboardingItemViewModel(data: data))
                itemsVCs.append(vc)
            }
        })
//        var onboardItems = [OnboardingItemViewController]()
//        for data in datas.values {
//            let vc = OnboardingItemViewController(viewModel: OnboardingItemViewModel(data: data))
//            itemsVCs.append(vc)
//        }
        
        
        return Output()
    }

}
