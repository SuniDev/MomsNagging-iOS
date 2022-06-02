//
//  CommonTextField.swift
//  momsnagging
//
//  Created by suni on 2022/05/09.
//

import UIKit

/**
 # (C) CommonTextField
 - Authors: suni
 - Note: 공통 텍스트 필드 기본 기능 정의
 */
class CommonTextField: UITextField {
        
    override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                self.addPlaceHolder(placeholder)
            }
        }
    }
    
    @IBInspectable var normalBorderColor: UIColor = Asset.Color.monoLight010.color {
        didSet {
            normal()
        }
    }
    @IBInspectable var errorBorderColor: UIColor = Asset.Color.error.color
    @IBInspectable var successBorderColor: UIColor = Asset.Color.monoLight010.color
    @IBInspectable var editBorderColor: UIColor = Asset.Color.monoDark030.color

    func normal() {
        self.addBorder(color: normalBorderColor, width: 1)
    }
    
    func error() {
        self.addBorder(color: errorBorderColor, width: 1)
    }
    
    func success() {
        self.addBorder(color: successBorderColor, width: 1)
    }
    
    func edit() {
        self.addBorder(color: editBorderColor, width: 1)
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initview()
    }
    
    private func initview() {
        self.textColor = Asset.Color.monoDark010.color
        self.layer.cornerRadius = 4
        self.addLeftPadding(width: 8)
        self.font = FontFamily.Pretendard.regular.font(size: 14)
        self.normal()
    }
}
