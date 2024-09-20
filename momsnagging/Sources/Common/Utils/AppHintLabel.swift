//
//  AppHintLabel.swift
//  momsnagging
//
//  Created by suni on 9/29/24.
//

import UIKit

/**
 # (C) AppHintLabel
 - Authors: suni
 - Note: 공통 텍스트 힌트 Label 기본 기능 정의
 */
class AppHintLabel: UILabel {
        
    @IBInspectable var errorTextColor: UIColor = Asset.Color.error.color
    @IBInspectable var successTextColor: UIColor = Asset.Color.success.color
    
    func normal() {
        self.isHidden = true
        self.text = ""
    }
    
    func error(_ text: String) {
        showText(to: text, color: errorTextColor)
    }
    
    func success(_ text: String) {
        showText(to: text, color: successTextColor)
    }
    
    private func showText(to text: String, color: UIColor) {
        self.isHidden = false
        self.textColor = color
        self.text = text
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
        self.text = ""
        self.font = FontFamily.Pretendard.regular.font(size: 12)
    }
}
