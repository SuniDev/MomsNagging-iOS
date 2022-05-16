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
 - Note: 바텀 시트 공통 ViewcController
 */
class CommonBottomSheet: BaseViewController {
    
    var originalTransform: CGAffineTransform?
    
    lazy var dimView = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
    })
    lazy var sheetView = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 8
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
        $0.image = Asset.Icon.deleteRed.image
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
        view.addSubview(sheetView)
        sheetView.addSubview(viewModify)
        viewModify.addSubview(icModify)
        viewModify.addSubview(lblModify)
        viewModify.addSubview(btnModify)
        sheetView.addSubview(viewDelete)
        viewDelete.addSubview(icDelete)
        viewDelete.addSubview(lblDelete)
        viewDelete.addSubview(btnDelete)
        
        dimView.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        sheetView.snp.makeConstraints({
            $0.height.equalTo(137)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(142)
        })
        self.originalTransform = self.sheetView.transform
        
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
        
        self.view.layoutIfNeeded()
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
        
        sheetView.snp.updateConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(5)
        })
    
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let self = self {
                self.view.layoutIfNeeded()
                self.dimView.alpha = 0.7
            }
        }, completion: { _ in
            completion?()
        })
   }
    
   func hideAnim() {
       sheetView.snp.updateConstraints({
           $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(142)
       })
   
       UIView.animate(withDuration: 0.3, animations: { [weak self] in
           if let self = self {
               self.view.layoutIfNeeded()
               self.dimView.alpha = 0.0
           }
       }, completion: { _ in
           self.view.removeFromSuperview()
           self.removeFromParent()
       })
   }
}
