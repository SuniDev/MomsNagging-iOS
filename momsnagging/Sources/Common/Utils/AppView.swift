//
//  AppView.swift
//  momsnagging
//
//  Created by suni on 9/29/24.
//

import UIKit
import SnapKit

class AppView {
    
    /**
     # scrollView
     - parameters:
        - viewContents : 컨텐츠 View
        - bounces : 스크롤뷰 바운스 여부
     - Authors: suni
     - Returns: UIScrollView
     - Note: 공통 스크롤 뷰 함수
     */
    static func scrollView(viewContents: UIView, bounces: Bool) -> UIScrollView {
        lazy var scrollView = UIScrollView().then({
            $0.bounces = bounces
            $0.contentInsetAdjustmentBehavior = .never
            $0.contentInset = .zero
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
    
    /**
     # hintTextFieldView
     - parameters:
        - tf : textField
        - lblHint : 텍스트 힌트 Label
     - Authors: suni
     - Returns: UITextField
     - Note: 텍스트 힌트가 있는 텍스트 필드 View
     */
    static func hintTextFieldView(tf: UITextField, lblHint: UILabel) -> UIView {
        
        lazy var viewHint = UIView().then({
            $0.backgroundColor = .clear
        })
       
        viewHint.addSubview(tf)
        viewHint.addSubview(lblHint)
        
        tf.snp.makeConstraints({
            $0.height.equalTo(48)
            $0.top.leading.trailing.equalToSuperview()
        })
        
        lblHint.snp.makeConstraints({
            $0.top.equalTo(tf.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(tf)
            $0.bottom.equalToSuperview()
        })
        
        return viewHint
    }
    
}
