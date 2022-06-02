//
//  Onboarding.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import Foundation
import UIKit

struct Onboarding {
    
    var currentPage: Int
    var emoji: UIImage?
    var title: String?
    var image: UIImage?
    
    init(_ currentPage: Int) {
        self.currentPage = currentPage
        self.emoji = self.getEmoji()
        self.title = self.getTitle()
        self.image = self.getImage()
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
    
    func getEmoji() -> UIImage {
        switch getCurrentPage() {
        case 0: return Asset.Assets.onboardingEmoji1.image
        case 1: return Asset.Assets.onboardingEmoji2.image
        case 2: return Asset.Assets.onboardingEmoji3.image
        case 3: return Asset.Assets.onboardingEmoji4.image
        case 4: return Asset.Assets.onboardingEmoji5.image
        default: return Asset.Assets.onboardingEmoji1.image
        }
    }
    
    func getTitle() -> String {
        switch getCurrentPage() {
        case 0: return "1. 습관/할일 추가"
        case 1: return "2. 추천 습관"
        case 2: return "3. 엄마가 잔소리 해주는 푸쉬 알림"
        case 3: return "4. 3단계 잔소리 강도 설정"
        case 4: return "5. 이 외 기능"
        default: return ""
        }
    }
    
    func getImage() -> UIImage {
        switch getCurrentPage() {
        case 0: return Asset.Assets.onboardingImage1.image
        case 1: return Asset.Assets.onboardingImage2.image
        case 2: return Asset.Assets.onboardingImage3.image
        case 3: return Asset.Assets.onboardingImage4.image
        case 4: return Asset.Assets.onboardingImage5.image
        default: return Asset.Assets.defautImage.image
        }
    }
    
}
