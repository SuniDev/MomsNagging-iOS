//
//  AwardView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class AwardView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Init
    init(viewModel: AwardViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: AwardViewModel!
    // MARK: - UI Properties
    lazy var awardFrame = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
    })
    lazy var awardTitleLbl = UILabel().then({
        $0.text = "상장"
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
    })
    lazy var closeBtn = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.x), for: .normal)
    })
    
    lazy var imgvAwardLevel1 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable1)
    })
    lazy var lblAwardLevel1 = UILabel().then({
        $0.text = "수x5"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    
    lazy var imgvAwardLevel2 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable2)
    })
    lazy var lblAwardLevel2 = UILabel().then({
        $0.text = "수x10"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    
    lazy var imgvAwardLevel3 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable3)
    })
    lazy var lblAwardLevel3 = UILabel().then({
        $0.text = "수x30"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    
    lazy var imgvAwardLevel4 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable4)
    })
    lazy var lblAwardLevel4 = UILabel().then({
        $0.text = "수x50"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    
    lazy var awardDiscriptionLbl = UILabel().then({
        $0.text = "“매주 월요일마다 제공되는 주간평가 성적인 ‘수, 우, 미, 양, 가’ 중 ‘수’ 달성 횟수에 따라 상장 획득이 가능하단다. “"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
    })
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoDark010)?.withAlphaComponent(0.34)
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(awardFrame)
        awardFrame.addSubview(awardTitleLbl)
        awardFrame.addSubview(closeBtn)
        awardFrame.addSubview(imgvAwardLevel1)
        awardFrame.addSubview(lblAwardLevel1)
        awardFrame.addSubview(imgvAwardLevel2)
        awardFrame.addSubview(lblAwardLevel2)
        awardFrame.addSubview(imgvAwardLevel3)
        awardFrame.addSubview(lblAwardLevel3)
        awardFrame.addSubview(imgvAwardLevel4)
        awardFrame.addSubview(lblAwardLevel4)
        awardFrame.addSubview(awardDiscriptionLbl)
        
        awardFrame.snp.makeConstraints({
            $0.width.equalTo(320)
            $0.height.equalTo(428)
            $0.center.equalTo(view.snp.center)
        })
        awardTitleLbl.snp.makeConstraints({
            $0.centerX.equalTo(awardFrame.snp.centerX)
            $0.top.equalTo(awardFrame.snp.top).offset(20)
        })
        closeBtn.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(awardFrame.snp.trailing).offset(-16)
            $0.top.equalTo(awardFrame.snp.top).offset(16)
        })
        
        imgvAwardLevel1.snp.makeConstraints({
            $0.width.height.equalTo(120)
            $0.top.equalTo(awardTitleLbl.snp.bottom).offset(16)
            $0.trailing.equalTo(awardFrame.snp.centerX).offset(-16)
        })
        lblAwardLevel1.snp.makeConstraints({
            $0.top.equalTo(imgvAwardLevel1.snp.bottom).offset(8)
            $0.centerX.equalTo(imgvAwardLevel1.snp.centerX)
        })
        imgvAwardLevel2.snp.makeConstraints({
            $0.width.height.equalTo(120)
            $0.top.equalTo(awardTitleLbl.snp.bottom).offset(16)
            $0.leading.equalTo(awardFrame.snp.centerX).offset(16)
        })
        lblAwardLevel2.snp.makeConstraints({
            $0.top.equalTo(imgvAwardLevel2.snp.bottom).offset(8)
            $0.centerX.equalTo(imgvAwardLevel2.snp.centerX)
        })
        imgvAwardLevel3.snp.makeConstraints({
            $0.top.equalTo(imgvAwardLevel1.snp.bottom).offset(40)
            $0.width.height.equalTo(120)
            $0.trailing.equalTo(awardFrame.snp.centerX).offset(-16)
        })
        lblAwardLevel3.snp.makeConstraints({
            $0.top.equalTo(imgvAwardLevel3.snp.bottom).offset(8)
            $0.centerX.equalTo(imgvAwardLevel3.snp.centerX)
        })
        imgvAwardLevel4.snp.makeConstraints({
            $0.top.equalTo(lblAwardLevel2.snp.bottom).offset(40)
            $0.width.height.equalTo(120)
            $0.leading.equalTo(awardFrame.snp.centerX).offset(16)
        })
        lblAwardLevel4.snp.makeConstraints({
            $0.top.equalTo(imgvAwardLevel4.snp.bottom).offset(8)
            $0.centerX.equalTo(imgvAwardLevel4.snp.centerX)
        })
        awardDiscriptionLbl.snp.makeConstraints({
            $0.bottom.equalTo(awardFrame.snp.bottom).offset(-20)
            $0.leading.equalTo(awardFrame.snp.leading).offset(20)
            $0.trailing.equalTo(awardFrame.snp.trailing).offset(-20)
        })
        
    }
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = AwardViewModel.Input(willApearView: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
                                         btnCloseTapped: self.closeBtn.rx.tap.asDriverOnErrorJustComplete(),
                                         viewTapped: self.view.rx.tapGesture().mapToVoid().asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.setAwardLevel
            .drive(onNext: { level in
                
                self.imgvAwardLevel1.image = level > 0 ? Asset.Assets.awardEnable1.image : Asset.Assets.awardDisable1.image
                self.lblAwardLevel1.textColor = level > 0 ? Asset.Color.monoDark010.color : Asset.Color.monoDark040.color
                
                self.imgvAwardLevel2.image = level > 1 ? Asset.Assets.awardEnable2.image : Asset.Assets.awardDisable2.image
                self.lblAwardLevel2.textColor = level > 1 ? Asset.Color.monoDark010.color : Asset.Color.monoDark040.color
                
                self.imgvAwardLevel3.image = level > 2 ? Asset.Assets.awardEnable3.image : Asset.Assets.awardDisable3.image
                self.lblAwardLevel3.textColor = level > 2 ? Asset.Color.monoDark010.color : Asset.Color.monoDark040.color
                
                self.imgvAwardLevel4.image = level > 3 ? Asset.Assets.awardEnable4.image : Asset.Assets.awardDisable4.image
                self.lblAwardLevel4.textColor = level > 3 ? Asset.Color.monoDark010.color : Asset.Color.monoDark040.color
            }).disposed(by: disposedBag)
        
        output.dismiss
            .drive(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposedBag)
    }
    
}
