//
//  CommonButton.swift
//  momsnagging
//
//  Created by suni on 2022/05/01.
//

import UIKit

class CommonButton: UIButton {
    
    var highlightDuration: TimeInterval = 0.15
    var enableDuration: TimeInterval = 0.15
    
    @IBInspectable var normalBackgroundColor: UIColor = Asset.Color.priMain.color {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor = Asset.Color.priDark020.color
    @IBInspectable var disabledBackgroundColor: UIColor = Asset.Color.priLight018Dis.color
    
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
    
    private func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: highlightDuration) {
            self.backgroundColor = color
        }
    }
    
}
