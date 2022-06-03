//
//  OnboardingPageView.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingItemView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingItemViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var lblTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    })
    
    lazy var viewMessage = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvEmoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    lazy var imgvImage = UIImageView().then({
        $0.image = Asset.Assets.defautImage.image
    })
    
    lazy var imgvPagecontrol = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    // MARK: - init
    init(viewModel: OnboardingItemViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
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
        view.backgroundColor = Asset.Color.monoWhite.color
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(lblTitle)
        viewBackground.addSubview(viewMessage)
        viewMessage.addSubview(imgvEmoji)
        viewBackground.addSubview(imgvImage)
        viewBackground.addSubview(imgvPagecontrol)
                
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalTo(viewBackground)
        })
        
        viewMessage.snp.makeConstraints({
            $0.height.equalTo(100)
            $0.top.equalTo(lblTitle.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        })
        
        imgvEmoji.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        })
        
        let isLowHeightDevice = Common.getSafeareaHeight() < 736
        
        imgvImage.snp.makeConstraints({
            $0.height.equalTo(imgvImage.snp.width).multipliedBy(1 / 0.94)
            $0.leading.equalToSuperview().offset(isLowHeightDevice ? 65 : 30)
            $0.trailing.equalToSuperview().offset(isLowHeightDevice ? -65 : -30)
            $0.top.equalTo(viewMessage.snp.bottom).offset(32)
        })
        
        imgvPagecontrol.snp.makeConstraints({
            $0.top.equalTo(imgvImage.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        })
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let input = OnboardingItemViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.setTile.drive(onNext: { pageTitle in
            self.lblTitle.text = pageTitle
        }).disposed(by: disposeBag)
        
        output.setEmoji.drive(onNext: { image in
            self.imgvEmoji.image = image
        }).disposed(by: disposeBag)
        
        output.setImage.drive(onNext: { image in
            self.imgvImage.image = image
        }).disposed(by: disposeBag)
        
        output.setPageControl.drive(onNext: { index in
            self.setPageControl(index)
        }).disposed(by: disposeBag)
        
    }
}
extension OnboardingItemView {
    private func setPageControl(_ index: Int) {
        switch index {
        case 0: self.imgvPagecontrol.image = Asset.Assets.pagecontrol1.image
        case 1: self.imgvPagecontrol.image = Asset.Assets.pagecontrol2.image
        case 2: self.imgvPagecontrol.image = Asset.Assets.pagecontrol3.image
        case 3: self.imgvPagecontrol.image = Asset.Assets.pagecontrol4.image
        case 4: self.imgvPagecontrol.image = Asset.Assets.pagecontrol5.image
        default: self.imgvPagecontrol.image = Asset.Assets.emojiDefault.image
        }
    }
}
