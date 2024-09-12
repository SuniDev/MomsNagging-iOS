//
//  Utils.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import UIKit

class Utils {
    
    /**
     # safeareaHeight
     - Authors: suni
     - Note:디바이스 Safe Area 영역 높이를 반환하는 공용 변수
    */
    static var safeareaHeight: CGFloat {
        let height = UIScreen.main.bounds.height
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        
        return height - topPadding - bottomPadding
    }
}
