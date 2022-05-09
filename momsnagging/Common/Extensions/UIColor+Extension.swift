//
//  UIColor+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/05/08.
//

import UIKit

extension UIColor {
    /**
     # init
     - parameters:
        - hexString : Color Hex값
     - Authors: suni
     - Note: Hex -> UIColor 로 변환하는 init함수
     */
    convenience init(hexString: String) {
        if let rgbValue = UInt(hexString, radix: 16) {
            let red = CGFloat((rgbValue >> 16) & 0xff) / 255
            let green = CGFloat((rgbValue >> 8) & 0xff) / 255
            let blue = CGFloat((rgbValue ) & 0xff) / 255
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}
