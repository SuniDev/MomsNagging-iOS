//
//  CommonPopup.swift
//  momsnagging
//
//  Created by suni on 2022/07/07.
//

import UIKit
import Then
import SnapKit
import RxSwift

/**
 # (C) CommonPopup
 - Authors: suni
 - Note: 팝업 공통 ViewcController
 */
class CommonPopup: BaseViewController {
    private var disposeBag = DisposeBag()
    
    enum PopupType {
        case forceUpdate
        case selectUpdate
        case etc
    }
    
    lazy var dimView = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
    })
    lazy var backView = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var popupView = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 16
        $0.addShadow(color: .black, alpha: 0.09, x: 0, y: 4, blur: 20, spread: 0)
    })
    
    lazy var icon = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    lazy var lblTitle = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    })
    lazy var lblMessage = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    })
    
    lazy var viewBtnCenter = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var viewBtnTwo = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var viewBtnLeft = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var viewBtnRight = UIView().then({
        $0.backgroundColor = .clear
    })
    
    lazy var btnCenter = UIButton().then({
        $0.backgroundColor = .clear
    })
    lazy var btnLeft = UIButton().then({
        $0.backgroundColor = .clear
    })
    lazy var btnRight = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var lblCenter = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.success.color
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    lazy var lblLeft = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var lblRight = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.success.color
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    
    lazy var dividerVerti = UIView().then({
        $0.backgroundColor = Asset.Color.monoLight030.color
    })
    lazy var dividerHori = UIView().then({
        $0.backgroundColor = Asset.Color.monoLight030.color
    })
    
    override func initUI() {
        self.view.backgroundColor = .clear
    }
    
    override func layoutSetting() {
        view.addSubview(dimView)
        view.addSubview(backView)
        backView.addSubview(popupView)
        backView.addSubview(icon)
        popupView.addSubview(lblTitle)
        popupView.addSubview(lblMessage)
        popupView.addSubview(dividerHori)
        
        popupView.addSubview(viewBtnCenter)
        
        viewBtnCenter.addSubview(lblCenter)
        viewBtnCenter.addSubview(btnCenter)
        
        popupView.addSubview(viewBtnTwo)
        viewBtnTwo.addSubview(viewBtnLeft)
        viewBtnTwo.addSubview(viewBtnRight)
        viewBtnTwo.addSubview(dividerVerti)
        
        viewBtnLeft.addSubview(lblLeft)
        viewBtnLeft.addSubview(btnLeft)
        viewBtnRight.addSubview(lblRight)
        viewBtnRight.addSubview(btnRight)
        
        dimView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        backView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().offset(-45)
        })
        
        popupView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        icon.snp.makeConstraints({
            $0.height.width.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(popupView.snp.top)
        })
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(44)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        })
        lblMessage.snp.makeConstraints({
            $0.top.equalTo(lblTitle.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        })
        
        dividerHori.snp.makeConstraints({
            $0.height.equalTo(1)
            $0.top.equalTo(lblMessage.snp.bottom).offset(30)
            $0.trailing.leading.equalToSuperview()
        })
        
        viewBtnCenter.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.equalTo(dividerHori.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        lblCenter.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        btnCenter.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        viewBtnTwo.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.equalTo(dividerHori.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        viewBtnLeft.snp.makeConstraints({
            $0.leading.top.bottom.equalToSuperview()
        })
        lblLeft.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        btnLeft.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        dividerVerti.snp.makeConstraints({
            $0.width.equalTo(1)
            $0.leading.equalTo(viewBtnLeft.snp.trailing)
            $0.top.bottom.equalToSuperview()
        })
        
        viewBtnRight.snp.makeConstraints({
            $0.width.equalTo(viewBtnLeft)
            $0.leading.equalTo(dividerVerti.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
        })
        lblRight.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        btnRight.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        viewBtnCenter.isHidden = true
        viewBtnTwo.isHidden = true
    }
    
    func setUI(popupType: PopupType, title: String = "", message: String = "", cancelTitle: String = STR_NO, doneTitle: String = STR_YES, cancelHandler:(() -> Void)? = nil, doneHandler:(() -> Void)? = nil) {
        DispatchQueue.main.async {
            switch popupType {
            // 강제 업데이트
            case .forceUpdate:
                self.lblTitle.text = STR_UPDATE_TITLE
                self.lblMessage.text = STR_UPDATE_MESSAGE
                self.lblCenter.text = STR_UPDATE_DONE
                
                self.viewBtnCenter.isHidden = false
                self.viewBtnTwo.isHidden = true
                
            // 선택 업데이트
            case .selectUpdate:
                self.lblTitle.text = STR_UPDATE_TITLE
                self.lblMessage.text = STR_UPDATE_MESSAGE
                self.lblLeft.text = STR_UPDATE_CANCEL
                self.lblRight.text = STR_UPDATE_DONE
                
                self.viewBtnCenter.isHidden = true
                self.viewBtnTwo.isHidden = false
                
            case .etc:
                break
            }
        }
    }
    
    func showAnim(vc: UIViewController, parentAddView: UIView?, completion:(() -> Void)? = nil) {
        var pView = parentAddView
        
        if pView == nil {
            pView = vc.view
        }
        
        guard let parentView = pView else {
            completion?()
            return
        }
        
        vc.addChild(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(self.view)
        self.view.snp.makeConstraints({
            $0.top.bottom.trailing.leading.equalToSuperview()
        })
        
        self.dimView.fadeIn(0.3, alpha: 0.3, completion: nil)
        self.backView.fadeIn(0.3, alpha: 1.0, completion: {
            completion?()
        })
    }
    
    func hideAnim() {
        self.dimView.fadeOut(0.3, completion: nil)
        self.backView.fadeOut(0.3, completion: {
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}
