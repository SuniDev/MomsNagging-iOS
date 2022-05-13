//
//  CommonBottomSheet.swift
//  momsnagging
//
//  Created by suni on 2022/05/14.
//

import UIKit
import Then
import SnapKit

/**
 # (C) CommonBottomSheet
 - Authors: suni
 - Note: 바텀 시트 ViewcController
 */
class CommonBottomSheet: BaseViewController {
    lazy var dimView = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color.withAlphaComponent(0.3)
    })
    lazy var bottomView = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var viewModify = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var icModify = UIImageView().then({
        $0.image = Asset.Icon.edit.image
    })
    lazy var lblModify = UILabel().then({
        $0.text = "수정하기"
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var btnModify = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var viewDelete = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var icDelete = UIImageView().then({
        $0.image = Asset.Icon.delete.image
        $0.tintColor = Asset.Color.error.color
    })
    lazy var lblDelete = UILabel().then({
        $0.text = "삭제하기"
        $0.textColor = Asset.Color.error.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var btnDelete = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    override func initUI() {
        self.view.backgroundColor = .clear
    }
    
    override func layoutSetting() {
        view.addSubview(dimView)
        view.addSubview(bottomView)
        bottomView.addSubview(viewModify)
        viewModify.addSubview(icModify)
        viewModify.addSubview(lblModify)
        viewModify.addSubview(btnModify)
        bottomView.addSubview(viewDelete)
        viewDelete.addSubview(icDelete)
        viewDelete.addSubview(lblDelete)
        viewDelete.addSubview(btnDelete)
        
        dimView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        bottomView.snp.makeConstraints({
            $0.height.equalTo(132)
            $0.bottom.leading.trailing.equalToSuperview()
        })
        
        viewModify.snp.makeConstraints({
            $0.height.equalTo(66)
            $0.top.leading.trailing.equalToSuperview()
        })
        icModify.snp.makeConstraints({
            $0.height.width.equalTo(16)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        })
        lblModify.snp.makeConstraints({
            $0.leading.equalTo(icModify.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        })
        btnModify.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        viewDelete.snp.makeConstraints({
            $0.height.equalTo(66)
            $0.bottom.leading.trailing.equalToSuperview()
        })
        icDelete.snp.makeConstraints({
            $0.height.width.equalTo(16)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        })
        lblDelete.snp.makeConstraints({
            $0.leading.equalTo(icDelete.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        })
        btnDelete.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
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
           $0.edges.equalToSuperview()
       })
       
       self.dimView.alpha = 0.0
       let originalTransform = self.bottomView.transform
       
       var bottomY: CGFloat = 0.0
       bottomY = UIScreen.main.bounds.size.height - self.bottomView.frame.minY
       
       let hideTransform = originalTransform.translatedBy(x: 0.0, y: bottomY)
       self.bottomView.transform = hideTransform
       
       UIView.animate(withDuration: 0.2, animations: { [weak self] in
           if let self = self {
               self.dimView.alpha = 0.3
               self.bottomView.transform = originalTransform
           }
       }, completion: { _ in
           completion?()
       })
   }
    
   func hideAnim() {
       let window = UIApplication.shared.windows.first
       guard let topPadding = window?.safeAreaInsets.top else { return }
       
       let originalTransform = self.bottomView.transform
       let hideTransform = originalTransform.translatedBy(x: 0.0, y: -( self.bottomView.frame.size.height + topPadding))
       UIView.animate(withDuration: 0.2, animations: { [weak self] in
           if let self = self {
               self.dimView.alpha = 0.0
               self.bottomView.transform = hideTransform
           }
       }, completion: { _ in
           self.view.removeFromSuperview()
           self.removeFromParent()
       })
   }
}
