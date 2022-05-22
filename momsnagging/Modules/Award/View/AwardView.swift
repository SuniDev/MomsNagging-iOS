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

class AwardView: BaseViewController, Navigatable{
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: AwardViewModel!
    // MARK: - UI Properties
    var awardFrame = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
    })
    var awardTitleLbl = UILabel().then({
        $0.text = "상장"
        $0.textColor = UIColor(asset:Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
    })
    var closeBtn = UIButton().then({
        $0.setImage(UIImage(asset:Asset.Icon.x), for: .normal)
    })
    var awardItemImage1 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable1)
    })
    var awardItemLbl1 = UILabel().then({
        $0.text = "수x5"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    var awardItemImage2 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable2)
    })
    var awardItemLbl2 = UILabel().then({
        $0.text = "수x10"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    var awardItemImage3 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable3)
    })
    var awardItemLbl3 = UILabel().then({
        $0.text = "수x30"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    var awardItemImage4 = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.awardDisable4)
    })
    var awardItemLbl4 = UILabel().then({
        $0.text = "수x50"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    
    var awardDiscriptionLbl = UILabel().then({
        $0.text = "“매주 월요일마다 제공되는 주간평가 성적인 ‘수, 우, 미, 양, 가’\n중 ‘수’ 달성 횟수에 따라 상장 획득이 가능하단다. “"
        $0.textAlignment = .center
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
    })
    
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
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoDark010)?.withAlphaComponent(0.34)
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(awardFrame)
        awardFrame.addSubview(awardTitleLbl)
        awardFrame.addSubview(closeBtn)
        awardFrame.addSubview(awardItemImage1)
        awardFrame.addSubview(awardItemLbl1)
        awardFrame.addSubview(awardItemImage2)
        awardFrame.addSubview(awardItemLbl2)
        awardFrame.addSubview(awardItemImage3)
        awardFrame.addSubview(awardItemLbl3)
        awardFrame.addSubview(awardItemImage4)
        awardFrame.addSubview(awardItemLbl4)
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
        awardItemImage1.snp.makeConstraints({
            $0.width.height.equalTo(120)
            $0.top.equalTo(awardTitleLbl.snp.bottom).offset(16)
            $0.trailing.equalTo(awardFrame.snp.centerX).offset(-16)
        })
        awardItemLbl1.snp.makeConstraints({
            $0.top.equalTo(awardItemImage1.snp.bottom).offset(8)
            $0.centerX.equalTo(awardItemImage1.snp.centerX)
        })
        awardItemImage2.snp.makeConstraints({
            $0.width.height.equalTo(120)
            $0.top.equalTo(awardTitleLbl.snp.bottom).offset(16)
            $0.leading.equalTo(awardFrame.snp.centerX).offset(16)
        })
        awardItemLbl2.snp.makeConstraints({
            $0.top.equalTo(awardItemImage2.snp.bottom).offset(8)
            $0.centerX.equalTo(awardItemImage2.snp.centerX)
        })
        awardItemImage3.snp.makeConstraints({
            $0.top.equalTo(awardItemImage1.snp.bottom).offset(40)
            $0.width.height.equalTo(120)
            $0.trailing.equalTo(awardFrame.snp.centerX).offset(-16)
        })
        awardItemLbl3.snp.makeConstraints({
            $0.top.equalTo(awardItemImage3.snp.bottom).offset(8)
            $0.centerX.equalTo(awardItemImage3.snp.centerX)
        })
        awardItemImage4.snp.makeConstraints({
            $0.top.equalTo(awardItemImage2.snp.bottom).offset(40)
            $0.width.height.equalTo(120)
            $0.leading.equalTo(awardFrame.snp.centerX).offset(16)
        })
        awardItemLbl4.snp.makeConstraints({
            $0.top.equalTo(awardItemImage4.snp.bottom).offset(8)
            $0.centerX.equalTo(awardItemImage4.snp.centerX)
        })
        awardDiscriptionLbl.snp.makeConstraints({
            $0.bottom.equalTo(awardFrame.snp.bottom).offset(-20)
            $0.leading.equalTo(awardFrame.snp.leading).offset(20)
            $0.trailing.equalTo(awardFrame.snp.trailing).offset(-20)
        })
        
    }
    // MARK: - Bind
    override func bind() {
    }
    
}
