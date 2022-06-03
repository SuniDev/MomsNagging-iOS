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
    
    lazy var imgvImage = UIImageView().then({
        $0.image = Asset.Assets.defautImage.image
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
        viewBackground.addSubview(imgvImage)
                
        viewBackground.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        let isLowHeightDevice = Common.getSafeareaHeight() < 736
        
        imgvImage.snp.makeConstraints({
            $0.top.equalToSuperview().offset(218)
            $0.height.equalTo(imgvImage.snp.width).multipliedBy(1 / 0.94)
            $0.leading.equalToSuperview().offset(isLowHeightDevice ? 65 : 30)
            $0.trailing.equalToSuperview().offset(isLowHeightDevice ? -65 : -30)
        })
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let input = OnboardingItemViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.setImage.drive(onNext: { image in
            self.imgvImage.image = image
        }).disposed(by: disposeBag)
    }
}
extension OnboardingItemView {
}
