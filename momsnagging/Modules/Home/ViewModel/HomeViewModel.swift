//
//  HomeViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class HomeViewModel: BaseViewModel, ViewModelType {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    var todoListData: [TodoListModel] = []
    override init() {
    }
    // MARK: - Input
    struct Input {
        var floatingBtnStatus: Bool?
        var selectStatus: Bool?
        var cellType: TodoCellType?
    }
    // MARK: - Output
    struct Output {
        var floatingBtnIc: Driver<Bool>?
        var todoListData: Driver<[TodoListModel]>?
        var toggleImage: Driver<UIImage>!
        var cellColorList: Driver<[ColorAsset]>!
    }
    
    func transform(input: Input) -> Output {
        let floatingBtnIc = BehaviorRelay<Bool>(value: false)
        if input.floatingBtnStatus ?? true {
            floatingBtnIc.accept(false)
        } else {
            floatingBtnIc.accept(true)
        }
        if input.selectStatus ?? true {
            
        } else {
            
        }
        let toggleImg = BehaviorRelay<UIImage>(value: UIImage(asset: Asset.Icon.todoNonSelect)!)
        let colorListOb = BehaviorRelay<[ColorAsset]>(value: [])
        var colorList: [ColorAsset] = []
        if input.selectStatus ?? false {
            colorList.removeAll()
            colorList.append(Asset.Color.monoLight010)
            colorList.append(Asset.Color.monoLight030)
            colorList.append(Asset.Color.monoDark020)
            colorList.append(Asset.Color.monoLight030)
            colorList.append(Asset.Color.monoDark020)
            colorListOb.accept(colorList)
            
            toggleImg.accept(UIImage(asset: Asset.Icon.todoSelect)!)
        } else {
            colorList.removeAll()
            colorList.append(Asset.Color.monoWhite)
            colorList.append(Asset.Color.monoLight010)
            colorList.append(Asset.Color.monoDark010)
            if input.cellType == .todo {
                colorList.append(Asset.Color.priMain)
                colorList.append(Asset.Color.monoWhite)
            } else if input.cellType == .count {
                colorList.append(Asset.Color.subLight030)
                colorList.append(Asset.Color.monoDark010)
            }
            colorListOb.accept(colorList)
            
            toggleImg.accept(UIImage(asset: Asset.Icon.todoNonSelect)!)
        }
        return Output(floatingBtnIc: floatingBtnIc.asDriver(),todoListData: todoList(), toggleImage: toggleImg.asDriver(), cellColorList: colorListOb.asDriver())
    }
    
    func todoList() -> Driver<[TodoListModel]> {
        // 더미데이터 입니다. API 오면 붙이면 될듯합니다.
        let returnList = BehaviorRelay<[TodoListModel]>(value: [])
        var list: [TodoListModel] = []
        for i in 0...4 {
            var model = TodoListModel()
            model.isSelected = false
            model.time = "time"
            model.title = "Title"
            if i == 2 {
                model.prefix = "할일"
            } else if i == 3 {
                model.prefix = "4회"
            }
            model.type = .normal
            list.append(model)
        }
        returnList.accept(list)
        return returnList.asDriver()
    }
    
}
