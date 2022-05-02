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
    
    var nicknameAttributes: [NSAttributedString.Key: Any]?
    
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
    
    lazy var btnSon = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var imgvDaughter = UIImageView().then({
        $0.image = Asset.Assets.namesettingDaughterDis.image
    })
    
    lazy var btnDaughter = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var imgvEtc = UIImageView().then({
        $0.image = Asset.Assets.namesettingEtcDis.image
    })
    
    lazy var btnEtc = UIButton().then({
        $0.backgroundColor = .clear
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
    
    lazy var lblHint = UILabel().then({
        $0.text = ""
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.textColor = Asset.Color.success.color
    })
    
    lazy var viewConfirm = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvConfirm = UIImageView().then({
        $0.image = Asset.Assets.namesettingConfirmS.image
    })
    
    lazy var viewLblConfirm = UIView().then({
        $0.backgroundColor = .clear
    })
    
    lazy var lblConfirm = UILabel().then({
        $0.textAlignment = .center
        $0.text = "우리"
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
        $0.textColor = Asset.Color.monoDark010.color
    })
    
    lazy var lblNickname = UILabel().then({
        $0.textAlignment = .center
        $0.text = ""
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
        
        /// ScrollView TapGesture로 키보드 내리기.
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.skyblue.color
        
        nicknameAttributes = [
            .font: FontFamily.Pretendard.semiBold.font(size: 18),
            .foregroundColor: Asset.Color.priMain.color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
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
        viewAnswer.addSubview(btnSon)
        viewAnswer.addSubview(imgvDaughter)
        viewAnswer.addSubview(btnDaughter)
        viewAnswer.addSubview(imgvEtc)
        viewAnswer.addSubview(btnEtc)
        viewAnswer.addSubview(tfNickname)
        viewAnswer.addSubview(lblHint)
        
        viewContants.addSubview(viewConfirm)
        viewConfirm.addSubview(imgvConfirm)
        viewConfirm.addSubview(viewLblConfirm)
        viewLblConfirm.addSubview(lblConfirm)
        viewLblConfirm.addSubview(lblNickname)
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
        
        btnSon.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvSon)
        })
        
        imgvDaughter.snp.makeConstraints({
            $0.centerY.equalTo(imgvSon)
            $0.leading.equalTo(imgvSon.snp.trailing).offset(18)
        })
        
        btnDaughter.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvDaughter)
        })
        
        imgvEtc.snp.makeConstraints({
            $0.centerY.equalTo(imgvSon)
            $0.leading.equalTo(imgvDaughter.snp.trailing).offset(18)
        })
        
        btnEtc.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvEtc)
        })
        
        tfNickname.snp.makeConstraints({
            $0.height.equalTo(48)
            $0.top.equalTo(imgvSon.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-30)
        })
        
        lblHint.snp.makeConstraints({
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
            $0.height.equalTo(148)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        })
        
        viewLblConfirm.snp.makeConstraints({
            $0.height.equalTo(30)
            $0.top.equalTo(imgvConfirm.snp.top).offset(10)
            $0.centerX.equalTo(imgvConfirm)
        })
        
        lblConfirm.snp.makeConstraints({
            $0.top.bottom.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        })
        
        lblNickname.snp.makeConstraints({
            $0.leading.equalTo(lblConfirm.snp.trailing)
            $0.top.trailing.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
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
        guard let viewModel = viewModel else { return }
        
        let input = NicknameSettingViewModel
            .Input(
                btnSonTapped: self.btnSon.rx.tap.asDriverOnErrorJustComplete(),
                btnDaughterTapped: self.btnDaughter.rx.tap.asDriverOnErrorJustComplete(),
                btnEtcTapped: self.btnEtc.rx.tap.asDriverOnErrorJustComplete(),
                textName: self.tfNickname.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidBeginName: self.tfNickname.rx.controlEvent(.editingDidBegin).asDriverOnErrorJustComplete(),
                editingDidEndName: self.tfNickname.rx.controlEvent(.editingDidEnd).asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete()
            )
        
        let output = viewModel.transform(input: input)
        
        output.selectedNicknameType
            .drive(onNext: { type in
                self.imgvSon.image = Asset.Assets.namesettingSonDis.image
                self.imgvDaughter.image = Asset.Assets.namesettingDaughterDis.image
                self.imgvEtc.image = Asset.Assets.namesettingEtcDis.image
                        
                switch type {
                case .none:
                    break
                case .son:
                    self.imgvSon.image = Asset.Assets.namesettingSon.image
                case .daughter:
                    self.imgvDaughter.image = Asset.Assets.namesettingDaughter.image
                case .etc:
                    self.imgvEtc.image = Asset.Assets.namesettingEtc.image
                }
            }).disposed(by: disposeBag)
        
        output.isHiddenTfName
            .drive(onNext: { isHidden in
                self.imgvAnswer.image = isHidden ? Asset.Assets.namesettingAnswer.image : Asset.Assets.namesettingAnswerEtc.image
                
                self.tfNickname.isHidden = isHidden
                self.tfNickname.text = ""
                
                self.lblHint.text = ""
                self.lblHint.isHidden = true
            }).disposed(by: disposeBag)
        
        output.confirmName
            .debug()
            .drive(onNext: { text in
                let lblMargin = text.count > 0 ? 10 : 0
                self.lblNickname.snp.updateConstraints({
                    $0.leading.equalTo(self.lblConfirm.snp.trailing).offset(lblMargin)
                })
                
                if text.isEmpty {
                    self.imgvConfirm.image = Asset.Assets.namesettingConfirmS.image
                    self.lblNickname.text = ""
                    return
                } else if NicknameType.son.rawValue == text || NicknameType.daughter.rawValue == text {
                    self.imgvConfirm.image = Asset.Assets.namesettingConfirmM.image
                } else {
                    self.imgvConfirm.image = Asset.Assets.namesettingConfirmL.image
                }
                
                self.lblNickname.attributedText = NSMutableAttributedString(string: text, attributes: self.nicknameAttributes)
            }).disposed(by: disposeBag)
        
        output.editingName
            .debug()
            .drive(onNext: {
                self.tfNickname.addBorder(color: Asset.Color.priMain.color, width: 1)
                self.lblHint.isHidden = true
            }).disposed(by: disposeBag)
        
        output.defaultName
            .debug()
            .drive(onNext: {
                self.tfNickname.addBorder(color: Asset.Color.monoLight030.color, width: 1)
                self.lblHint.isHidden = true
                self.btnDone.isEnabled = false
            }).disposed(by: disposeBag)
        
        output.availableCustomName
            .debug()
            .drive(onNext: { _ in
                self.btnDone.isEnabled = true
                self.lblHint.isHidden = false
                self.lblHint.textColor = Asset.Color.success.color
                self.lblHint.text = STR_NICKNAME_AVAILABLE
                self.tfNickname.addBorder(color: Asset.Color.monoLight030.color, width: 1)
            }).disposed(by: disposeBag)
        
        output.availableName
            .debug()
            .drive(onNext: { _ in
                self.btnDone.isEnabled = true
            }).disposed(by: disposeBag)
        
        output.unavailableCustomName
            .debug()
            .drive(onNext: { _ in
                self.btnDone.isEnabled = false
                self.lblHint.isHidden = false
                self.lblHint.textColor = Asset.Color.error.color
                self.lblHint.text = STR_NICKNAME_UNAVAILABLE
                self.tfNickname.addBorder(color: Asset.Color.error.color, width: 1)
            }).disposed(by: disposeBag)
        
        output.successNameSetting
            .drive(onNext: { _ in
                CommonView.showAlert(vc: self, type: .oneBtn, title: "", message: STR_NICKNAME_SUCCESS, doneTitle: STR_DONE, doneHandler: {
                  // TODO: 메인 이동.
                })
            }).disposed(by: disposeBag)
    }
}
