//
//  CommonTextRadioButton.swift
//  momsnagging
//
//  Created by suni on 2022/05/24.
//

import UIKit
import Then

class CommonTextRadioButton: UIButton {

    var lblTitle: UILabel?
    var btnRadio: UIButton?
    
    @IBInspectable var normalTextColor: UIColor = Asset.Color.monoDark030.color
    @IBInspectable var selectedTextColor: UIColor = Asset.Color.monoDark010.color
    
    override var isSelected: Bool {
        didSet {
            if oldValue == false && isSelected {
                select()
            } else if oldValue == true && !isSelected {
                deselect()
            }
        }
    }
    
    func select() {
        if let lblTitle = lblTitle {
            lblTitle.textColor = selectedTextColor
        }
        if let btnRadio = btnRadio {
            btnRadio.isSelected = true
        }
    }
    
    func deselect() {
        if let lblTitle = lblTitle {
            lblTitle.textColor = normalTextColor
        }
        if let btnRadio = btnRadio {
            btnRadio.isSelected = false
        }
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
        self.backgroundColor = .clear
    }
}
