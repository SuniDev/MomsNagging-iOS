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
    var closeBtn = UIButton().then({
        $0.setImage(UIImage(asset:Asset.Icon.x), for: .normal)
    })
    var awardItemImage1 = UIImageView().then({
//        $0.image = UIImage
    })
    var awardItemLbl1 = UILabel().then({
        $0.text = "수x5"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    var awardItemImage2 = UIImageView()
    var awardItemLbl2 = UILabel().then({
        $0.text = "수x10"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    var awardItemImage3 = UIImageView()
    var awardItemLbl3 = UILabel().then({
        $0.text = "수x30"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    var awardItemImage4 = UIImageView()
    var awardItemLbl4 = UILabel().then({
        $0.text = "수x50"
        $0.textColor = UIColor(asset: Asset.Color.monoDark040)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    
    var awardDiscriptionLbl = UILabel()
    
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
    }
    // MARK: - Bind
    override func bind() {
    }
    
}
