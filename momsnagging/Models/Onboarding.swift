//
//  Onboarding.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import Foundation
import UIKit
import Alamofire

struct Onboarding {
    
    enum BubbleType: String {
        case twoLine
        case threeLine
    }
    
    var index: Int
    var title: String?
    var message: String?
    var image: UIImage?
    
    init(index: Int, title: String?, message: String?, image: UIImage?) {
        self.index = index
        self.title = title
        self.message = message
        self.image = image
    }
    
    func getTitle() -> String {
        return title ?? ""
    }
    
    func getMessage() -> String {
        return message ?? ""
    }
    
    func getImage() -> UIImage {
        if let image = image {
            return image
        }
        return Asset.Assets.emojiDefault.image
    }
    
    func getBubbleType() -> BubbleType {
        let lines =  getMessage().components(separatedBy: "\n")
        switch lines.count {
        case 2: return BubbleType.twoLine
        case 3: return BubbleType.threeLine
        default: return BubbleType.threeLine
        }
    }
    
    func getBubbleImage() -> UIImage {
        switch getBubbleType() {
        case .twoLine:
            return Asset.Assets.bubble224x60.image
        case .threeLine:
            return Asset.Assets.bubble224x88.image
        }
    }
}
