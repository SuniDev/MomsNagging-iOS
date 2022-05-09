//
//  CommonButton.swift
//  momsnagging
//
//  Created by suni on 2022/05/01.
//

import UIKit

/**
 # (C) CommonButton
 - Authors: suni
 - Note: 공통 버튼 기본 기능 정의
 */
class CommonButton: UIButton {
    
    var highlightDuration: TimeInterval = 0.1
    var enableDuration: TimeInterval = 0.1
    var selectDuration: TimeInterval = 0.1
    
    @IBInspectable var normalBackgroundColor: UIColor = Asset.Color.priMain.color {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor?
    @IBInspectable var disabledBackgroundColor: UIColor?
    @IBInspectable var selectedBackgroundColor: UIColor?
    
    var normalFont: UIFont?
    var selectedFont: UIFont? {
        didSet {
            normalFont = self.titleLabel?.font
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if oldValue == false && isEnabled {
                enable()
            } else if oldValue == true && !isEnabled {
                disable()
            }
        }
    }
    
    func enable() {
        if disabledBackgroundColor != nil {
            animateBackground(to: normalBackgroundColor, duration: enableDuration)
        }
    }

    func disable() {
        if let disabledBackgroundColor = disabledBackgroundColor {
            animateBackground(to: disabledBackgroundColor, duration: enableDuration)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                highlight()
            } else if oldValue == true && !isHighlighted {
                unHighlight()
            }
        }
    }

    func highlight() {
        if let highlightedBackgroundColor = highlightedBackgroundColor {
            animateBackground(to: highlightedBackgroundColor, duration: highlightDuration)
        }
    }

    func unHighlight() {
        if highlightedBackgroundColor != nil {
            animateBackground(to: normalBackgroundColor, duration: highlightDuration)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if oldValue == false && isSelected {
                select()
            } else if oldValue == true && !isSelected {
                deSelect()
            }
        }
    }

    func select() {
        if let selectedBackgroundColor = selectedBackgroundColor {
            animateBackground(to: selectedBackgroundColor, duration: selectDuration)
        }
        if let selectedFont = selectedFont {
            self.titleLabel?.font = selectedFont
        }
    }

    func deSelect() {
        if selectedBackgroundColor != nil {
            animateBackground(to: normalBackgroundColor, duration: selectDuration)
        }
        if let normalFont = normalFont {
            self.titleLabel?.font = normalFont
        }
    }
    
    private func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: duration) {
            self.backgroundColor = color
        }
    }
    
}
