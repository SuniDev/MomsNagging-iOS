//
//  IntroViewController.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit

import SnapKit
import Then
import RxFlow
import RxCocoa
import ReactorKit

class IntroViewController: BaseViewController, Popupable {

    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
    })
    
    lazy var imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.introLogo.image
    })
    
    init(with reactor: IntroReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IntroViewController: View {
    func bind(reactor: IntroReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindView(_ reactor: IntroReactor) {
        
    }
    
    private func bindAction(_ reactor: IntroReactor) {}
    
    private func bindState(_ reactor: IntroReactor) {}
}
