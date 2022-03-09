//
//  CommonView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit
import Then

//MARK: - 공통되는 자주사용되는 2~3회 이상 사용되는 공통 속성의 UI설정해서 바로 가져다 쓰면 편할듯합니다.
///공통뷰 모음 Class
class CommonView {
    //ex. 공통 버튼 형태 등
    func testButton() -> UIButton{
        let button = UIButton().then({
            $0.backgroundColor = Asset.black.color
        })
        return button
    }
    //ex. 공통 헤드 뷰
    enum HeadViewButtonType{
        case CloseBtn
        case backBtn
    }
    func headFrame(headTitle:String,type:HeadViewButtonType) -> UIView {
        let view = UIView()
        let title = UILabel().then({
            $0.text = headTitle
        })
        switch type {
        case .CloseBtn:
            print("닫기 버튼일때 레이아웃 설정")
        case .backBtn:
            print("뒤로가기 버튼일때 레이아웃 설정")
        }
        return view
    }
}
