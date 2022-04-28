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

class BaseViewModel {
    // TODO: API 통신 처리.
}
