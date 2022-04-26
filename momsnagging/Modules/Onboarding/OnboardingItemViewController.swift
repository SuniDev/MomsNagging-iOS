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

class OnboardingItemViewController: BaseViewController {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: OnboardingItemViewModel?
    
    // MARK: - UI Properties
    let viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    let lblTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    })
    
    let viewMessage = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    let imgvEmoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
    })
    
    let imgvBubble = UIImageView().then({
        $0.image = Asset.Assets.bubble224x60.image
        $0.contentMode = .scaleAspectFill
    })
    
    let imgvImage = UIImageView().then({
        $0.image = Asset.Assets.defautImage.image
    })
    
    let lblMessage = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    })
    
    // TODO: PageController 문의 사항 진행중
//    let pageControl = UIPageControl().then({
//        $0.pageIndicatorTintColor = Asset.Color.monoLight030.color
//        $0.currentPageIndicatorTintColor = Asset.Color.priLight030.color
//        $0.numberOfPages = 5
//    })
    
    // MARK: - init
    init(viewModel: OnboardingItemViewModel) {
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
        view.backgroundColor = Asset.Color.monoWhite.color
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(lblTitle)
        viewBackground.addSubview(viewMessage)
        viewMessage.addSubview(imgvEmoji)
        viewMessage.addSubview(imgvBubble)
        viewMessage.addSubview(lblMessage)
        viewBackground.addSubview(imgvImage)
                
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.top.equalTo(viewBackground.snp.top).offset(15.0)
            $0.centerX.equalTo(viewBackground.snp.centerX)
            $0.leading.trailing.greaterThanOrEqualToSuperview()
        })
        
        viewMessage.snp.makeConstraints({
            $0.top.equalTo(lblTitle.snp.bottom).offset(40.0)
            $0.centerX.equalTo(viewBackground.snp.centerX)
        })
        
        imgvEmoji.snp.makeConstraints({
            $0.height.width.equalTo(72.0)
            $0.leading.equalTo(viewMessage.snp.leading)
            $0.centerY.equalTo(viewMessage.snp.centerY)
        })
        
        imgvBubble.snp.makeConstraints({
            $0.width.equalTo(245.0)
            $0.top.equalTo(viewMessage.snp.top).offset(8.0)
            $0.leading.equalTo(imgvEmoji.snp.trailing).offset(2.0)
            $0.trailing.equalTo(viewMessage.snp.trailing)
            $0.bottom.equalTo(viewMessage.snp.bottom)
            $0.centerY.equalTo(viewMessage.snp.centerY)
        })
        
        lblMessage.snp.makeConstraints({
            $0.leading.equalTo(imgvBubble.snp.leading).offset(35.0)
            $0.centerY.equalTo(viewMessage.snp.centerY)
            $0.trailing.equalTo(imgvBubble.snp.trailing).offset(-15.0)
        })
        
        imgvImage.snp.makeConstraints({
            $0.top.greaterThanOrEqualTo(viewMessage.snp.bottom).offset(45.0)
            $0.leading.equalToSuperview().offset(30.0)
            $0.trailing.equalToSuperview().offset(-30.0)
            $0.height.equalTo(imgvImage.snp.width).multipliedBy(330 / 312)
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
        
        output.setDescription.drive(onNext: { pageMsg in
            self.lblMessage.text = pageMsg
        }).disposed(by: disposeBag)
        
        output.setImage.drive(onNext: { image in
            self.imgvImage.image = image
        }).disposed(by: disposeBag)
        
        output.setBubble.drive(onNext: { image in
            self.imgvBubble.image = image
        }).disposed(by: disposeBag)
        
        // TODO: PageController 문의 사항 진행중
//        output.setIndex.drive(onNext: { index in
//            self.pageControl.currentPage = index
//        }).disposed(by: disposeBag)
//
//        output.setNumberOfPages.drive(onNext: { number in
//            self.pageControl.numberOfPages = number
//        }).disposed(by: disposeBag)
    }
     
}
