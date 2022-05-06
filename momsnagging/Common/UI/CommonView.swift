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
    
    /**
     # detailHeadFrame
     - parameters:
        - btnBack : HeadFrame 왼쪽 '뒤로가기' 버튼
        - lblTitle : HeadFrame 가운데 타이틀
        - btnDone:HeadFrame 오른쪽 '완료' 버튼
        - btnMore:HeadFrame 오른쪽 '미트볼/more' 이미지 버튼
     - Authors: suni
     - Returns: UIView
     - Note: 상세 화면 헤더
     */
    static func detailHeadFrame(btnBack: UIButton, lblTitle: UILabel, btnDone: UIButton, btnMore: UIButton) -> UIView {
        lazy var viewHeader = UIView().then({
            $0.backgroundColor = Asset.Color.monoWhite.color
        })
        
        _ = btnBack.then({
            $0.setImage(Asset.Icon.straightLeft.image, for: .normal)
        })
        
        _ = btnDone.then({
            $0.isEnabled = false
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(Asset.Color.priMain.color, for: .normal)
            $0.setTitleColor(Asset.Color.monoDark040.color, for: .disabled)
            $0.setTitleColor(Asset.Color.priDark020.color, for: .highlighted)
        })
        
        _ = btnMore.then({
            $0.isHidden = true
            $0.setImage(Asset.Icon.more.image, for: .normal)
        })
        
        _ = lblTitle.then({
            $0.textColor = UIColor(asset: Asset.Color.monoDark010)
            $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
        })
        
        viewHeader.addSubview(btnBack)
        viewHeader.addSubview(lblTitle)
        viewHeader.addSubview(btnDone)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
        })
        
        btnBack.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        })
        
        lblTitle.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        btnDone.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        })
        
        return viewHeader
    }
    
    static func textField(placeHolder: String = "") -> UITextField {
        lazy var textField = UITextField().then({
            $0.textColor = Asset.Color.monoDark010.color
            $0.layer.cornerRadius = 4
            $0.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                          attributes: [NSAttributedString.Key.foregroundColor: Asset.Color.monoDark030.color])
            $0.addLeftPadding(width: 8)
            $0.font = FontFamily.Pretendard.regular.font(size: 14)
            $0.addBorder(color: Asset.Color.monoLight010.color, width: 1)
        })
        
        return textField
    }
    
    static func requiredTitleFrame(_ text: String) -> UIView {
        lazy var viewTitle = UIView().then({
            $0.backgroundColor = Asset.Color.monoWhite.color
        })
        
        lazy var lblTitle = UILabel().then({
            $0.text = text
            $0.textColor = Asset.Color.monoDark010.color
            $0.font = FontFamily.Pretendard.bold.font(size: 16)
        })
        
        lazy var lblRequired = UILabel().then({
            $0.text = "필수"
            $0.textColor = Asset.Color.priMain.color
            $0.font = FontFamily.Pretendard.regular.font(size: 12)
        })
        
        viewTitle.addSubview(lblTitle)
        viewTitle.addSubview(lblRequired)
        
        lblTitle.snp.makeConstraints({
            $0.leading.top.bottom.equalToSuperview()
        })
        
        lblRequired.snp.makeConstraints({
            $0.leading.equalTo(lblTitle.snp.trailing).offset(6)
            $0.centerY.equalTo(lblTitle)
        })
        
        return viewTitle
    }
    
    static func scrollView(viewContents: UIView, bounces: Bool) -> UIScrollView {
        lazy var scrollView = UIScrollView().then({
            $0.bounces = bounces
        })
        
        _ = viewContents.then({
            $0.backgroundColor = .clear
        })
        
        scrollView.addSubview(viewContents)
        
        viewContents.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        })
        
        return scrollView
    }
}
