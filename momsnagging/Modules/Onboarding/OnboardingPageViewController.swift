//
//  OnboardingPageViewController.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingPageViewController: BaseViewController {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingPageViewModel?
    
    // MARK: - UI Properties
    let viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    let lblTitle = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    let imgvEmoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    let imgvBubble1 = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    let imgvBubble2 = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    let lblDescription = UILabel().then({
        $0.text = ""
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    
    // MARK: - init
    init(viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - initUI
    override func initUI() {
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
    }
}
