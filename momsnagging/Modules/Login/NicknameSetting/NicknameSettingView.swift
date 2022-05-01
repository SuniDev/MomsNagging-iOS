//
//  NicknameSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import UIKit
import SnapKit
import Then
import RxSwift

class NicknameSettingView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: NicknameSettingViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var scrollView = UIScrollView().then({
        $0.bounces = false
    })
    
    lazy var viewContants = UIView().then({
        $0.backgroundColor = .clear
    })
    
    lazy var viewBottom = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvQuestion = UIImageView().then({
        $0.image = Asset.Assets.namesettingQuestion.image
    })
    
    lazy var viewAnswer = UIView().then({
        $0.backgroundColor = .clear
    })
    
    lazy var imgvAnswer = UIImageView().then({
        $0.image = Asset.Assets.namesettingAnswer.image
    })
    
    lazy var imgvSon = UIImageView().then({
        $0.image = Asset.Assets.namesettingSonDis.image
    })
    
    lazy var imgvDaughter = UIImageView().then({
        $0.image = Asset.Assets.namesettingDaughterDis.image
    })
    
    lazy var imgvEtc = UIImageView().then({
        $0.image = Asset.Assets.namesettingEtcDis.image
    })
    
    lazy var tfNickname = UITextField().then({
        $0.isHidden = true
        $0.addBorder(color: Asset.Color.monoLight030.color, width: 1)
        $0.layer.cornerRadius = 4
        $0.placeholder = "띄어쓰기 포함 한/영/숫자 1-10글자"
        $0.addLeftPadding(width: 8)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    })
    
    lazy var lblHintID = UILabel().then({
        $0.text = ""
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.textColor = Asset.Color.success.color
    })
    
    lazy var viewConfirm = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvConfirm = UIImageView().then({
        $0.image = Asset.Assets.idsettingConfirm.image
    })
    
    lazy var btnDone = CommontButton().then({
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.disabledBackgroundColor = Asset.Color.priLight018Dis.color
        $0.isEnabled = false
        $0.setTitle("네 엄마!", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })

    // MARK: - init
    init(viewModel: NicknameSettingViewModel, navigator: Navigator) {
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

        // Do any additional setup after loading the view.
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.skyblue.color
               
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBottom)
        view.addSubview(scrollView)
        
        scrollView.addSubview(viewContants)
        
        viewContants.addSubview(imgvQuestion)
        viewContants.addSubview(viewAnswer)
        
        viewAnswer.addSubview(imgvAnswer)
        viewAnswer.addSubview(imgvSon)
        viewAnswer.addSubview(imgvDaughter)
        viewAnswer.addSubview(imgvEtc)
        viewAnswer.addSubview(tfNickname)
        viewAnswer.addSubview(lblHintID)
        
        viewContants.addSubview(viewConfirm)
        viewConfirm.addSubview(imgvConfirm)
        viewConfirm.addSubview(btnDone)
        
        viewBottom.snp.makeConstraints({
            $0.top.equalTo(scrollView.snp.bottom).offset(0)
            $0.bottom.leading.trailing.equalToSuperview()
        })
        
        scrollView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        viewContants.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        })
        
        imgvQuestion.snp.makeConstraints({
            $0.width.equalTo(270)
            $0.height.equalTo(72)
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(15)
        })
        
        viewAnswer.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.height.equalTo(280)
            $0.top.equalTo(imgvQuestion.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().offset(-15)
        })
        
        imgvAnswer.snp.makeConstraints({
            $0.width.top.leading.trailing.equalToSuperview()
        })
        
        imgvSon.snp.makeConstraints({
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(20)
        })
        
        imgvDaughter.snp.makeConstraints({
            $0.centerY.equalTo(imgvSon)
            $0.leading.equalTo(imgvSon.snp.trailing).offset(18)
        })
        
        imgvEtc.snp.makeConstraints({
            $0.centerY.equalTo(imgvSon)
            $0.leading.equalTo(imgvDaughter.snp.trailing).offset(18)
        })
        
        tfNickname.snp.makeConstraints({
            $0.height.equalTo(48)
            $0.top.equalTo(imgvSon.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-30)
        })
        
        lblHintID.snp.makeConstraints({
            $0.top.equalTo(tfNickname.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(tfNickname)
        })
        
        let safeareaHeight = Common.getSafeareaHeight()
        let marginHeight = safeareaHeight <= 736 ? 16 : safeareaHeight - 720
        
        viewConfirm.snp.makeConstraints({
            $0.height.equalTo(288)
            $0.top.equalTo(viewAnswer.snp.bottom).offset(marginHeight)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        imgvConfirm.snp.makeConstraints({
            $0.width.equalTo(216)
            $0.height.equalTo(148)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        })
        
        btnDone.snp.makeConstraints({
            $0.height.equalTo(56)
            $0.top.equalTo(imgvConfirm.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-40)
        })
    }
    
    // MARK: - bind
    override func bind() {
        
    }

}
