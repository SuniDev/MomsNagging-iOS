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
    
    var highlightDuration: TimeInterval = 0.15
    var enableDuration: TimeInterval = 0.15
    var selectDuration: TimeInterval = 0.15
    
    @IBInspectable var normalBackgroundColor: UIColor = Asset.Color.priMain.color {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor = Asset.Color.priDark020.color
    @IBInspectable var disabledBackgroundColor: UIColor = Asset.Color.priLight018Dis.color
    @IBInspectable var selectedBackgroundColor: UIColor = Asset.Color.priLight010.color
    
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
        animateBackground(to: normalBackgroundColor, duration: enableDuration)
    }

    func disable() {
        animateBackground(to: disabledBackgroundColor, duration: enableDuration)
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
        animateBackground(to: highlightedBackgroundColor, duration: highlightDuration)
    }

    func unHighlight() {
        animateBackground(to: normalBackgroundColor, duration: highlightDuration)
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
        animateBackground(to: selectedBackgroundColor, duration: selectDuration)
    }

    func deSelect() {
        animateBackground(to: normalBackgroundColor, duration: selectDuration)
    }
    
    private func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: duration) {
            self.backgroundColor = color
        }
    }
    
}
