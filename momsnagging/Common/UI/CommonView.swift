//
//  CommonView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit
import Then
import Toast_Swift
import SnapKit

// MARK: - 공통되는 자주사용되는 2~3회 이상 사용되는 공통 속성의 UI설정해서 바로 가져다 쓰면 편할듯합니다.
/// 공통뷰 모음 Class
class CommonView {
    
    static func homeHeadFrame(listIconBtn: UIButton, headTitle: UILabel, dropDownImageView: UIImageView, dropDownButton: UIButton, diaryBtn: UIButton) -> UIView {
        let view = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        })
        headTitle.then({
            $0.textColor = UIColor(asset: Asset.Color.monoDark010)
            $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
        })
        dropDownImageView.then({
            $0.image = UIImage(asset: Asset.Icon.chevronDown)
        })
        listIconBtn.then({
            $0.setImage(UIImage(asset: Asset.Icon.list), for: .normal)
        })
        diaryBtn.then({
            $0.setImage(UIImage(asset: Asset.Icon.diary), for: .normal)
        })
        
        view.addSubview(headTitle)
        view.addSubview(dropDownImageView)
        view.addSubview(dropDownButton)
        view.addSubview(listIconBtn)
        view.addSubview(diaryBtn)
        
        headTitle.snp.makeConstraints({
            $0.center.equalTo(view.snp.center)
        })
        dropDownImageView.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(view.snp.centerY)
            $0.leading.equalTo(headTitle.snp.trailing).offset(5.5)
        })
        dropDownButton.snp.makeConstraints({
            $0.top.equalTo(headTitle.snp.top)
            $0.leading.equalTo(headTitle.snp.leading)
            $0.trailing.equalTo(dropDownImageView.snp.trailing)
            $0.bottom.equalTo(headTitle.snp.bottom)
        })
        listIconBtn.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.centerY.equalTo(view.snp.centerY)
        })
        diaryBtn.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.centerY.equalTo(view.snp.centerY)
        })
        
        return view
    }
    
    // Alert의 버튼 타입에 사용할 enum으로 Alert의 버튼 1개 또는 2개일때를 구분하기 위하여 생성함.
    enum AlertType {
        case oneBtn
        case twoBtn
    }
    /*
     vc : 이 메서드를 사용할 vc
     type : 버튼의 타입 1개의 버튼인지 2개의 버튼인지 선택 .oneButton, twoButton
     title : Alert Title문구
     message : Alert 메세지 문구
     doneAction : 확인 눌렀을때 사용할 UIAlertAction으로 사용할 뷰에서 생성하여 컨트롤
     cancelTitle(Optional) : cancel버튼의 메세지 변경시 사용
     */
    // 220422 suni. doneTitle, cancelAction 추가 / UIAlertAction -> Handler로 변경 / .present 메인 스레드에서 처리하도록 변경.
    static func showAlert(vc: UIViewController, type: AlertType, title: String? = "", message: String? = "", cancelTitle: String? = STR_CANCEL, doneTitle: String = STR_DONE, cancelHandler:(() -> Void)? = nil, doneHandler:(() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler?()
            }
            let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
                doneHandler?()
            }
            
            switch type {
            case .oneBtn:
                alert.addAction(doneAction)
            case .twoBtn:
                alert.addAction(cancelAction)
                alert.addAction(doneAction)
            }
            
            Log.debug(alert.actions)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showToast(vc: UIViewController, message: String, duration: TimeInterval = ToastManager.shared.duration) {
        vc.view.makeToast(message, duration: duration)
    }
}
