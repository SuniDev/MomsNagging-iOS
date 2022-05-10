//
//  FloatingBtn.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/07.
//

import Foundation
import Then
import SnapKit
import UIKit
import RxSwift

/**
 # FloatingBtn, HomeViewExtension
 - Authors: tavi
 - Note: HomeView의 FloatingBtn만 따로 빼서 처리하기 위해 빼놨습니다
 */
extension HomeView {
    /**
     # setFloatingBtn
     - Authors: tavi
     - Note: HomeView에 플로팅 버튼 추가와 오토레이아웃 세팅 함수
     */
    func setFloatingBtn() {
        let floatingBtnIc = UIImageView()
        let backgroundFrame = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.black)?.withAlphaComponent(0.34)
            $0.isHidden = true
        })
        let habitItem = addFloatingItemView(btn: addHabitBtn, type: .habit)
        let todoItem = addFloatingItemView(btn: addTodoBtn, type: .todo)
        let floatingBtnView = floatingView(fb: floatingBtn, img: floatingBtnIc)
        self.view.addSubview(backgroundFrame)
        backgroundFrame.addSubview(habitItem)
        backgroundFrame.addSubview(todoItem)
        self.view.addSubview(floatingBtnView)
        backgroundFrame.snp.makeConstraints({
            $0.edges.equalTo(self.view.snp.edges)
            $0.top.equalTo(self.view.snp.top).offset(-60)
            $0.bottom.equalTo(self.view.snp.bottom)
        })
        floatingBtnView.snp.makeConstraints({
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.width.height.equalTo(56)
        })
        todoItem.snp.makeConstraints({
            $0.trailing.equalTo(floatingBtnView.snp.trailing)
            $0.bottom.equalTo(floatingBtnView.snp.bottom)
            $0.height.equalTo(56)
            $0.width.equalTo(146)
        })
        habitItem.snp.makeConstraints({
            $0.trailing.equalTo(floatingBtnView.snp.trailing)
            $0.bottom.equalTo(floatingBtnView.snp.bottom)
            $0.height.equalTo(56)
            $0.width.equalTo(146)
        })
        
        floatingBtn.rx.tap.bind {
            if self.floatingBtn.isSelected { // x 버튼 클릭시
                backgroundFrame.isHidden = true
                self.floatingBtn.isSelected = false
                self.floatingBind(btnSelected: true, img: floatingBtnIc)
                UIView.animate(withDuration: 0.1) {
                    todoItem.frame = todoItem.frame.offsetBy(dx: 0, dy: 80)
                    habitItem.frame = habitItem.frame.offsetBy(dx: 0, dy: 160)
                }
            } else { // + 버튼 클릭시
                backgroundFrame.isHidden = false
                self.floatingBtn.isSelected = true
                self.floatingBind(btnSelected: false, img: floatingBtnIc)
                UIView.animate(withDuration: 0.1) {
                    todoItem.frame = todoItem.frame.offsetBy(dx: 0, dy: -80)
                }
                UIView.animate(withDuration: 0.2) {
                    habitItem.frame = habitItem.frame.offsetBy(dx: 0, dy: -160)
                }
            }
        }.disposed(by: disposedBag)
    }
    
    /**
     # floatingView
     - Authors: tavi
     - parameters:
        - fb: 플로팅 버튼 이벤트를 받기위한 버튼
        - img: 플로팅버튼안 +, x 버튼 처리를 위한 이미지 뷰
     - Note: 플로팅버튼 뷰
     */
    func floatingView(fb: UIButton, img: UIImageView) -> UIView {
        let view = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.priMain)
            $0.layer.cornerRadius = 28
            $0.layer.masksToBounds = true
        })
        img.image = UIImage(asset: Asset.Icon.plus)
        view.addSubview(img)
        view.addSubview(fb)
        img.snp.makeConstraints({
            $0.center.equalTo(view.snp.center)
            $0.width.height.equalTo(30)
        })
        fb.snp.makeConstraints({
            $0.edges.equalTo(view.snp.edges)
        })
        return view
    }
    
    //플로팅 버튼 안의 아이템 (습관추가, 할일추가) 타입 열거
    enum FloatingItemType {
        case habit
        case todo
    }
    /**
     # addFloatingItemView
     - Authors: tavi
     - parameters:
        - btn: 플로팅 아이템의 인터렉션을 받기위한 버튼
        - type: 플로팅 아이템의 타입
     - Note: 플로팅 버튼 안 의 아이템뷰
     */
    func addFloatingItemView(btn: UIButton, type: FloatingItemType) -> UIView {
        let lblView = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        })
        let lbl = UILabel().then({
            $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
        })
        let roundView = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
            $0.layer.cornerRadius = 28
            $0.layer.masksToBounds = true
        })
        let ic = UIImageView()
        let view = UIView()
        
        switch type {
        case .habit:
            lbl.text = "습관 추가"
            lbl.textColor = UIColor(asset: Asset.Color.priDark020)
            ic.image = UIImage(asset: Asset.Icon.habitAddFloating)
            btn.rx.tap.bind {
                self.navigator.show(seque: .addHabit(viewModel: AddHabitViewModel()), sender: self, transition: .navigation)
            }.disposed(by: disposedBag)
        case .todo:
            lbl.text = "할일 추가"
            lbl.textColor = UIColor(asset: Asset.Color.monoDark010)
            ic.image = UIImage(asset: Asset.Icon.todoAddFloating)
            btn.rx.tap.bind {
                Log.debug("클릭이벤트", "할일추가 클릭")
            }.disposed(by: disposedBag)
        }
        
        view.addSubview(lblView)
        lblView.addSubview(lbl)
        view.addSubview(roundView)
        roundView.addSubview(ic)
        view.addSubview(btn)
        
        lblView.snp.makeConstraints({
            $0.centerY.equalTo(view.snp.centerY)
            $0.leading.equalTo(view.snp.leading)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        })
        lbl.snp.makeConstraints({
            $0.center.equalTo(lblView.snp.center)
        })
        roundView.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
            $0.width.height.equalTo(56)
        })
        ic.snp.makeConstraints({
            $0.center.equalTo(roundView.snp.center)
            $0.width.height.equalTo(24)
        })
        btn.snp.makeConstraints({
            $0.edges.equalTo(roundView.snp.edges)
        })
        return view
    }
    
    /**
     # floatingBind
     - Authors: tavi
     - parameters:
        - btnSelected: 버튼 선택 상태
        - img: 플로팅 버튼안의 +, x 아이콘 이미지뷰
     - Note: 플로팅 버튼의 선택여부에 따른 UI 변화를 위한 함수
     */
    func floatingBind(btnSelected: Bool, img: UIImageView) {
        guard let viewModel = viewModel else { return }
        lazy var input = HomeViewModel.Input(floatingBtnStatus: btnSelected)
        lazy var output = viewModel.transform(input: input)
        output.floatingBtnIc?.drive(onNext: { ic in
            if ic {
                img.image = UIImage(asset: Asset.Icon.xFloating)
            } else {
                img.image = UIImage(asset: Asset.Icon.plus)
            }
        }).disposed(by: disposedBag)
    }
}
