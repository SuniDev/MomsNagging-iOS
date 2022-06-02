//
//  BaseViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/02.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModelType {

    associatedtype Input    // UI to ViewModel
    associatedtype Output   // ViewModel to UI
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

class BaseViewModel: NSObject {
}

class ViewModel: NSObject {
    let provider: AppServices
    let networkError = PublishRelay<String>()
    
    init(provider: AppServices) {
        self.provider = provider
        super.init()
    }
}
