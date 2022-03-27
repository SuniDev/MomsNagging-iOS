//
//  CommonView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit
import Then

// MARK: - 공통되는 자주사용되는 2~3회 이상 사용되는 공통 속성의 UI설정해서 바로 가져다 쓰면 편할듯합니다.
/// 공통뷰 모음 Class
class CommonView {
    // ex. 공통 버튼 형태 등
    static func testButton() -> UIButton {
        let button = UIButton().then({
            $0.backgroundColor = Asset.black.color
        })
        return button
    }
    // ex. 공통 헤드 뷰
    enum HeadViewButtonType{
        case closeBtn
        case backBtn
    }
    static func headFrame(headTitle:String, type:HeadViewButtonType) -> UIView {
        let view = UIView()
        _ = UILabel().then({
            $0.text = headTitle
        })
        switch type {
        case .closeBtn:
            print("닫기 버튼일때 레이아웃 설정")
        case .backBtn:
            print("뒤로가기 버튼일때 레이아웃 설정")
        }
        return view
    }
    // Alert의 버튼 타입에 사용할 enum으로 Alert의 버튼 1개 또는 2개일때를 구분하기 위하여 생성함.
    enum AlertType {
        case oneButton
        case twoButton
    }
    /*
     view : 이 메서드를 사용할 View
     type : 버튼의 타입 1개의 버튼인지 2개의 버튼인지 선택 .oneButton, twoButton
     title : Alert Title문구
     message : Alert 메세지 문구
     doneAction : 확인 눌렀을때 사용할 UIAlertAction으로 사용할 뷰에서 생성하여 컨트롤
     cancelTitle(Optional) : cancel버튼의 메세지 변경시 사용
     */
    static func systemAlert(view: UIViewController, type: AlertType, title: String?, message: String?, doneAction: UIAlertAction, cancelTitle: String? = "취소") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        switch type {
        case .oneButton:
            alert.addAction(doneAction)
        case .twoButton:
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
        }
        view.present(alert, animated: true, completion: nil)
    }
}
