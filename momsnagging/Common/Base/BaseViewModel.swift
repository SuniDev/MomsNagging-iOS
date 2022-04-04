//
//  BaseViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/02.
//

import Foundation

protocol BaseViewModelType {
    associatedtype Input    // ViewModel to UI
    associatedtype Output   // UI to ViewModel
}

class BaseViewModel: NSObject {

    // TODO: Loading, Service 정의
}
