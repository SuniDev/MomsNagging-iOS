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
    
    let defaultCustomNameHeight: CGFloat = 100
    let defaultAnswerHeight: CGFloat = 190
    let defaultAnswerToConfirmMargin: CGFloat = 16
    var answerToConfirmMargin: CGFloat = 16
    
    var defaultViewContentsHeight: CGFloat = 0
    var safeAreaHeight: CGFloat = 0
    
    // MARK: - UI Properties
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    lazy var btnBack = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var imgvBack = UIImageView().then({
        $0.image = Asset.Icon.straightLeft.image
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
    
    lazy var viewCustomName = UIView().then({
        $0.backgroundColor = .clear
    })
    
    lazy var imgvCustom = UIImageView().then({
        $0.image = Asset.Assets.namesettingEtcDis.image
    })
    
    lazy var btnCustom = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var viewHintTextField = UIView()
    lazy var tfNickname = CommonTextField().then({
        $0.placeholder = "띄어쓰기 포함 한/영/숫자 1-10글자"
        $0.isHidden = true
        $0.normalBorderColor = Asset.Color.monoLight030.color
        $0.successBorderColor = Asset.Color.monoLight030.color
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    })
    lazy var lblHint = CommonHintLabel()
    
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
    
    lazy var btnDone = CommonButton().then({
        $0.highlightedBackgroundColor = Asset.Color.priDark020.color
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
        
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: false)
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfNickname, lblHint: lblHint)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBottom)
        view.addSubview(scrollView)
        
        viewContents.addSubview(imgvBack)
        viewContents.addSubview(btnBack)
        viewContents.addSubview(imgvQuestion)
        viewContents.addSubview(viewAnswer)
        
        viewAnswer.addSubview(imgvAnswer)
        viewAnswer.addSubview(imgvSon)
        viewAnswer.addSubview(btnSon)
        viewAnswer.addSubview(imgvDaughter)
        viewAnswer.addSubview(btnDaughter)
        viewAnswer.addSubview(imgvCustom)
        viewAnswer.addSubview(btnCustom)
        
        viewAnswer.addSubview(viewCustomName)
        viewCustomName.addSubview(viewHintTextField)
//        viewCustomName.addSubview(tfNickname)
//        viewCustomName.addSubview(lblHint)
        
        viewContents.addSubview(viewConfirm)
        viewConfirm.addSubview(imgvConfirm)
        viewConfirm.addSubview(viewLblConfirm)
        viewLblConfirm.addSubview(lblConfirm)
        viewLblConfirm.addSubview(lblNickname)
        viewConfirm.addSubview(btnDone)
        
        viewBottom.snp.makeConstraints({
            $0.top.equalTo(scrollView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        })
        
        scrollView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        imgvBack.snp.makeConstraints({
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
        })
        
        btnBack.snp.makeConstraints({
            $0.top.leading.equalTo(imgvBack).offset(-5)
            $0.bottom.trailing.equalTo(imgvBack).offset(5)
        })

        imgvQuestion.snp.makeConstraints({
            $0.width.equalTo(270)
            $0.height.equalTo(72)
            $0.top.equalTo(imgvBack.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(15)
        })
        
        viewAnswer.snp.makeConstraints({
            $0.width.equalTo(300)
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
        
        imgvCustom.snp.makeConstraints({
            $0.centerY.equalTo(imgvSon)
            $0.leading.equalTo(imgvDaughter.snp.trailing).offset(18)
        })
        
        btnCustom.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(imgvCustom)
        })
        
        viewCustomName.snp.makeConstraints({
            $0.height.equalTo(0)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(imgvSon.snp.bottom).offset(15)
        })
        
        viewHintTextField.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-30)
        })
        
        viewConfirm.snp.makeConstraints({
            $0.height.equalTo(288)
            $0.top.equalTo(viewAnswer.snp.bottom).offset(defaultAnswerToConfirmMargin)
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
        
        view.layoutIfNeeded()
        
        safeAreaHeight = Common.getSafeareaHeight()
        defaultViewContentsHeight = viewContents.bounds.height
        
        if safeAreaHeight > defaultViewContentsHeight {
            answerToConfirmMargin = safeAreaHeight - defaultViewContentsHeight + defaultAnswerToConfirmMargin
            viewConfirm.snp.updateConstraints({
                $0.top.equalTo(viewAnswer.snp.bottom).offset(answerToConfirmMargin)
            })
        }
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = NicknameSettingViewModel
            .Input(
                btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
                btnSonTapped: self.btnSon.rx.tap.asDriverOnErrorJustComplete(),
                btnDaughterTapped: self.btnDaughter.rx.tap.asDriverOnErrorJustComplete(),
                btnCustomTapped: self.btnCustom.rx.tap.asDriverOnErrorJustComplete(),
                textName: self.tfNickname.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidBeginName: self.tfNickname.rx.controlEvent(.editingDidBegin).asDriverOnErrorJustComplete(),
                editingDidEndName: self.tfNickname.rx.controlEvent(.editingDidEnd).asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete()
            )
        
        let output = viewModel.transform(input: input)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)

        output.selectedNicknameType
            .drive(onNext: { type in
                self.imgvSon.image = Asset.Assets.namesettingSonDis.image
                self.imgvDaughter.image = Asset.Assets.namesettingDaughterDis.image
                self.imgvCustom.image = Asset.Assets.namesettingEtcDis.image
            
                switch type {
                case .none:
                    break
                case .son:
                    self.imgvSon.image = Asset.Assets.namesettingSon.image
                    self.setHiddenCustomNameField(true)
                case .daughter:
                    self.imgvDaughter.image = Asset.Assets.namesettingDaughter.image
                    self.setHiddenCustomNameField(true)
                case .custom:
                    self.imgvCustom.image = Asset.Assets.namesettingEtc.image
                    self.setHiddenCustomNameField(false)
                }
            }).disposed(by: disposeBag)
        
        output.confirmName
            .drive(onNext: { text in
                let lblMargin = text.count > 0 ? 10 : 0
                self.lblNickname.snp.updateConstraints({
                    $0.leading.equalTo(self.lblConfirm.snp.trailing).offset(lblMargin)
                })
                
                if text.isEmpty {
                    self.imgvConfirm.image = Asset.Assets.namesettingConfirmS.image
                    self.lblNickname.text = ""
                    return
                } else if NicknameSettingViewModel.NicknameType.son.rawValue == text || NicknameSettingViewModel.NicknameType.daughter.rawValue == text {
                    self.imgvConfirm.image = Asset.Assets.namesettingConfirmM.image
                } else {
                    self.imgvConfirm.image = Asset.Assets.namesettingConfirmL.image
                }
                
                self.lblNickname.attributedText = NSMutableAttributedString(string: text, attributes: self.nicknameAttributes)
            }).disposed(by: disposeBag)
        
        output.isEditingName
            .drive(onNext: { isEditing in
                if isEditing {
                    self.tfNickname.edit()
                } else {
                    self.tfNickname.normal()
                }
            }).disposed(by: disposeBag)
        
        output.textHint
            .drive(onNext: { type in
                switch type {
                case .none:
                    self.lblHint.normal()
                case .success:
                    self.lblHint.success(type.rawValue)
                    self.tfNickname.success()
                case .error:
                    self.lblHint.error(type.rawValue)
                    self.tfNickname.error()
                }
            }).disposed(by: disposeBag)
        
        output.isAvailableName
            .drive(onNext: { isAvailable in
                self.btnDone.isEnabled = isAvailable
            }).disposed(by: disposeBag)
        
        output.successNameSetting
            .drive(onNext: { _ in
                CommonView.showAlert(vc: self, type: .oneBtn, title: "", message: STR_NICKNAME_SUCCESS, doneTitle: STR_DONE, doneHandler: {
                    let viewModel = MainContainerViewModel()
                    self.navigator.show(seque: .mainContainer(viewModel: viewModel), sender: nil, transition: .root)
                })
            }).disposed(by: disposeBag)
    }
}

extension NicknameSettingView {
    func setHiddenCustomNameField(_ isHidden: Bool) {
        self.view.layoutIfNeeded()
        
        let customNameHeight = isHidden ? 0 : defaultCustomNameHeight
        
        self.viewCustomName.snp.updateConstraints({
            $0.height.equalTo(customNameHeight)
        })
        
        let viewContentsHeight = self.defaultViewContentsHeight + customNameHeight
        
        if self.safeAreaHeight > viewContentsHeight {
            self.answerToConfirmMargin = self.safeAreaHeight - viewContentsHeight + self.defaultAnswerToConfirmMargin
            self.viewConfirm.snp.updateConstraints({
                $0.top.equalTo(self.viewAnswer.snp.bottom).offset(self.answerToConfirmMargin)
            })
        }
        self.imgvAnswer.image = isHidden ? Asset.Assets.namesettingAnswer.image : Asset.Assets.namesettingAnswerEtc.image
        
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
        }

        if isHidden {
            self.viewHintTextField.fadeOut()
            self.tfNickname.fadeOut(completion: {
                self.tfNickname.text = ""
            })
            self.lblHint.fadeOut(completion: {
                self.lblHint.text = ""
            })
        } else {
            self.viewHintTextField.fadeIn()
            self.tfNickname.fadeIn(completion: {
                self.tfNickname.text = ""
            })
            self.lblHint.fadeIn(completion: {
                self.lblHint.text = ""
            })
        }
    }
}
