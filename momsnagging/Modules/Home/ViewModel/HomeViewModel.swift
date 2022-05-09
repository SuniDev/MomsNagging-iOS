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
        var listBtnAction: Bool? // 리스트 버튼을 선택한 상태(취소, 저장버튼 보여짐) - true, 취소 또는 저장을 누른 상태 (리스트, 다이어리 버튼 보여짐) - false
        var sourceIndex: Int?
        var destinationIndex: Int?
    }
    // MARK: - Output
    struct Output {
        var floatingBtnIc: Driver<Bool>? // 플로팅 토글시 버튼안의 +(false) x(true) 버튼 변경
        var todoListData: Driver<[TodoListModel]>? // 투두 리스트 데이터 TodoListModel은 임의로 만든 더미 모델형태입니다.
        var toggleImage: Driver<UIImage>! // 셀 선택 상태에 따른 체크박스 이미지
        var cellColorList: Driver<[ColorAsset]>! // 셀 선택상태에 따른 색상 리스트
        
//        var cellRightImg: Driver<Bool>?
        var diaryBtnStatus: Driver<Bool>?
        var listBtnStatus: Driver<Bool>?
        var cancelBtnStatus: Driver<Bool>?
        var saveBtnStatus: Driver<Bool>?
        
        var inputValue: Driver<HomeViewModel.Input>?
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
            } else {
                colorList.append(Asset.Color.monoLight010)
                colorList.append(Asset.Color.monoDark010)
            }
            colorListOb.accept(colorList)
            
            toggleImg.accept(UIImage(asset: Asset.Icon.todoNonSelect)!)
        }
        
        let diaryBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let listBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let cancelBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let saveBtnStatusOb = BehaviorRelay<Bool>(value: false)
        let inputValueOb = BehaviorRelay<HomeViewModel.Input>(value: HomeViewModel.Input())
        if input.listBtnAction ?? false {
            diaryBtnStatusOb.accept(true)
            listBtnStatusOb.accept(true)
            cancelBtnStatusOb.accept(false)
            saveBtnStatusOb.accept(false)
            inputValueOb.accept(HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, cellType: nil, listBtnAction: false))
        } else {
            diaryBtnStatusOb.accept(false)
            listBtnStatusOb.accept(false)
            cancelBtnStatusOb.accept(true)
            saveBtnStatusOb.accept(true)
            inputValueOb.accept(HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: nil, cellType: nil, listBtnAction: true))
        }
        let todoListData = todoList(sourceIndex: input.sourceIndex, destIndex: input.destinationIndex)
        return Output(floatingBtnIc: floatingBtnIc.asDriver(), todoListData: todoListData, toggleImage: toggleImg.asDriver(), cellColorList: colorListOb.asDriver(), diaryBtnStatus: diaryBtnStatusOb.asDriver(), listBtnStatus: listBtnStatusOb.asDriver(), cancelBtnStatus: cancelBtnStatusOb.asDriver(), saveBtnStatus: saveBtnStatusOb.asDriver(), inputValue: inputValueOb.asDriver())
    }
    
    func todoList(sourceIndex: Int?=nil, destIndex: Int?=nil) -> Driver<[TodoListModel]> {
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
                model.type = .todo
            } else if i == 3 {
                model.prefix = "4회"
                model.type = .count
            } else {
                model.type = .normal
            }
            list.append(model)
        }
        
//        if let sourceIndex = sourceIndex {
//            let moveCell = list[sourceIndex]
//            list.remove(at: sourceIndex)
//            list.insert(moveCell, at: destIndex!)
//        }
        returnList.accept(list)
        return returnList.asDriver()
    }
    
    func listSort() {
        //리스트, 다이어리 버튼 숨겨야함 (true)
        //저장,취소버튼 보여야함 (false)
        //cellIconChange 두줄 equal모양 버튼
    }
//    func cancelOrSave() {
//        //리스트, 다이어리 버튼 보여야함 (false)
//        //저장,취소버튼 숨겨야함 (true)
//        //cellIconChange 세로 More 버튼
//    }
    
}
