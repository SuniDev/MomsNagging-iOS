//
//  OnboardingItemViewController.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

import RxSwift
import RxViewController
import SnapKit
import Then

class OnboardingItemViewController: BaseViewController {
    
    // MARK: - Properties & Variable
    var onboarding: Onboarding?
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvImage = UIImageView().then({
        $0.image = Asset.Assets.defautImage.image
    })
    
    // MARK: - Init
    init(with onboarding: Onboarding) {
        super.init(nibName: nil, bundle: nil)
        
        self.onboarding = onboarding
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - init UI & Layout
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
        if let onboarding {
            imgvImage.image = onboarding.image
        }
    }
    
    override func initLayout() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(imgvImage)
                
        viewBackground.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        let isLowHeightDevice = Utils.safeareaHeight < 736
        
        imgvImage.snp.makeConstraints({
            $0.top.equalToSuperview().offset(218)
            $0.height.equalTo(imgvImage.snp.width).multipliedBy(1 / 0.94)
            $0.leading.equalToSuperview().offset(isLowHeightDevice ? 65 : 30)
            $0.trailing.equalToSuperview().offset(isLowHeightDevice ? -65 : -30)
        })
    }
}
