//
//  Onboarding.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import UIKit

struct Onboarding {
    var currentPage: Int
    
    var emoji: UIImage {
        switch currentPage {
        case 0: return Asset.Assets.onboardingEmoji1.image
        case 1: return Asset.Assets.onboardingEmoji2.image
        case 2: return Asset.Assets.onboardingEmoji3.image
        case 3: return Asset.Assets.onboardingEmoji4.image
        case 4: return Asset.Assets.onboardingEmoji5.image
        default: return Asset.Assets.onboardingEmoji1.image
        }
    }
    
    var title: String {
        switch currentPage {
        case 0: return "1. 습관/할일 추가"
        case 1: return "2. 추천 습관"
        case 2: return "3. 엄마가 잔소리 해주는 PUSH 알림"
        case 3: return "4. 3가지 타입의 잔소리 성격 설정"
        case 4: return "5. 기타 기능"
        default: return ""
        }
    }
    
    var image: UIImage {
        switch currentPage {
        case 0: return Asset.Assets.onboardingImage1.image
        case 1: return Asset.Assets.onboardingImage2.image
        case 2: return Asset.Assets.onboardingImage3.image
        case 3: return Asset.Assets.onboardingImage4.image
        case 4: return Asset.Assets.onboardingImage5.image
        default: return Asset.Assets.defautImage.image
        }
    }
    
    var pageControl: UIImage {
        switch currentPage {
        case 0: return Asset.Assets.pagecontrol1.image
        case 1: return Asset.Assets.pagecontrol2.image
        case 2: return Asset.Assets.pagecontrol3.image
        case 3: return Asset.Assets.pagecontrol4.image
        case 4: return Asset.Assets.pagecontrol5.image
        default: return Asset.Assets.pagecontrol1.image
        }
    }
}
