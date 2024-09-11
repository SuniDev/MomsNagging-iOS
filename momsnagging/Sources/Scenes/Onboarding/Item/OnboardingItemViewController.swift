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
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
    })
    
    lazy var imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.introLogo.image
    })
        
    // MARK: - init UI & Layout
    override func initLayout() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(imgvLogo)
        
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
        imgvLogo.snp.makeConstraints({
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
        })
    }
}
