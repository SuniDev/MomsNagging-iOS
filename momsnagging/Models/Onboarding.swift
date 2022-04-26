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
    
    var currentPage: Int
    var emoji: UIImage?
    var title: String?
    var message: String?
    var image: UIImage?
    
    init(_ currentPage: Int,
         emoji: UIImage? = Asset.Assets.emojiDefault.image,
         title: String?,
         message: String?,
         image: UIImage?) {
        self.currentPage = currentPage
        self.emoji = emoji
        self.title = title
        self.message = message
        self.image = image
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
    
    func getEmoji() -> UIImage {
        if let emoji = emoji {
            return emoji
        }
        return Asset.Assets.emojiDefault.image
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
        return Asset.Assets.defautImage.image
    }
    
    func getBubbleType() -> BubbleType {
        let lines = getMessage().components(separatedBy: "\n")
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
