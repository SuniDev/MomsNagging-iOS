//
//  CommonSwitch.swift
//  momsnagging
//
//  Created by suni on 2022/05/15.
//

import UIKit

class CommonSwitch: UISwitch {
    
    var enableDuration: TimeInterval = 0.1
    
    @IBInspectable var normalOnColor: UIColor = Asset.Color.priMain.color
    @IBInspectable var normalOffColor: UIColor = Asset.Color.monoDark030.color
    
    @IBInspectable var disableOnColor: UIColor = Asset.Color.priLight030.color
    @IBInspectable var disableOffColor: UIColor = Asset.Color.monoLight010.color
    
    var isEnable: Bool = true {
        didSet {
            self.isUserInteractionEnabled = isEnable
            if oldValue == false && isEnable {
                enable()
            } else if oldValue == true && !isEnable {
                disable()
            }
        }
    }
    
    func enable() {
        animateColor(onColor: normalOnColor, offColor: normalOffColor, duration: enableDuration)
    }

    func disable() {
        animateColor(onColor: disableOnColor, offColor: disableOffColor, duration: enableDuration)
    }
    
    private func animateColor(onColor: UIColor?, offColor: UIColor?, duration: TimeInterval) {
        guard let onColor = onColor else { return }
        guard let offColor = offColor else { return }
        UIView.animate(withDuration: duration) {
            self.onTintColor = onColor
            self.tintColor = offColor
        }
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initview()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)

        self.initview()
    }
    
    private func initview() {
        self.backgroundColor = Asset.Color.monoWhite.color
        self.thumbTintColor = Asset.Color.monoWhite.color
        self.onTintColor = self.normalOnColor
        self.tintColor = self.normalOffColor
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
}
