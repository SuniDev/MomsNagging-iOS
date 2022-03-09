//
//  IntroViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import Foundation
import RxSwift

class IntroViewModel {
    //MARK: - Set Properties
    private var introModel = IntroModel(){
        didSet {
            name = introModel.name ?? ""
        }
    }
    //MARK: - Properties
    var name : String = "메롱ㅋ"
    //MARK: - Observable Properties
    var nameOb : Observable<String>?
    //MARK: - Set Model
    func modelUpdateName(){
        introModel.name = name
    }
    //MARK: - Set Observable
    func nameUpdate(){
        nameOb = Observable.just(name)
    }
    
    
}
