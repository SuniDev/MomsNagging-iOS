//
//   UIView+Extension.swift
//  momsnagging
//
//  Created by KBIZ on 2022/04/26.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur / 2.0
        
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
            
        }
    }
    
    func addBorder(color: UIColor = .black, width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func fadeIn(_ duration: TimeInterval = 0.15) {
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(_ duration: TimeInterval = 0.15) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        } completion: { _ in
            self.isHidden = true
        }
    }
}
