//
//  IDSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/04/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

class IDSettingView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: IDSettingViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoLight010.color
    })
    
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
        $0.image = Asset.Assets.idsettingQuestion.image
    })
    
    lazy var imgvAnswer = UIImageView().then({
        $0.image = Asset.Assets.idsettingAnswer.image
    })
    
    lazy var viewHintTextField = UIView()
    lazy var tfID = CommonTextField().then({
        $0.normalBorderColor = Asset.Color.monoLight030.color
        $0.successBorderColor = Asset.Color.monoLight030.color
        $0.placeholder = "밑줄, 띄어쓰기 제외 영어/숫자 4-15 글자"
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    })
    lazy var lblHint = CommonHintLabel()
    
    lazy var viewConfirm = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var imgvConfirm = UIImageView().then({
        $0.image = Asset.Assets.idsettingConfirm.image
    })
    
    lazy var btnDone = CommonButton().then({
        $0.highlightedBackgroundColor = Asset.Color.priDark020.color
        $0.disabledBackgroundColor = Asset.Color.priLight018Dis.color
        $0.isEnabled = false
        $0.setTitle("네!", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    // MARK: - init
    init(viewModel: IDSettingViewModel, navigator: Navigator) {
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
        view.backgroundColor = Asset.Color.monoLight010.color
        
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfID, lblHint: lblHint)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        view.addSubview(viewBottom)
        viewBackground.addSubview(imgvBack)
        viewBackground.addSubview(btnBack)
        viewBackground.addSubview(imgvQuestion)
        viewBackground.addSubview(imgvAnswer)
        viewBackground.addSubview(viewHintTextField)
        
        viewBackground.addSubview(viewConfirm)
        viewConfirm.addSubview(imgvConfirm)
        viewConfirm.addSubview(btnDone)
        
        viewBackground.snp.makeConstraints({
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
        
        viewBottom.snp.makeConstraints({
            $0.top.equalTo(viewBackground.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        })
        
        imgvQuestion.snp.makeConstraints({
            $0.width.equalTo(319)
            $0.height.equalTo(72)
            $0.top.equalTo(imgvBack.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(15)
        })
        
        imgvAnswer.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.height.equalTo(120)
            $0.top.equalTo(imgvQuestion.snp.bottom).offset(42)
            $0.trailing.equalToSuperview().offset(-15)
        })
        
        viewHintTextField.snp.makeConstraints({
            $0.top.equalTo(imgvAnswer).offset(26)
            $0.leading.equalTo(imgvAnswer).offset(20)
            $0.trailing.equalTo(imgvAnswer).offset(-28)
        })
//        tfID.snp.makeConstraints({
//            $0.height.equalTo(48)
//            $0.top.equalTo(imgvAnswer).offset(26)
//            $0.leading.equalTo(imgvAnswer).offset(20)
//            $0.trailing.equalTo(imgvAnswer).offset(-28)
//        })
//
//        lblHint.snp.makeConstraints({
//            $0.top.equalTo(tfID.snp.bottom).offset(5)
//            $0.leading.trailing.equalTo(tfID)
//        })
                
        viewConfirm.snp.makeConstraints({
            $0.height.equalTo(288)
            $0.bottom.leading.trailing.equalToSuperview()
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
        guard let viewModel = viewModel else { return }
        
        let input = IDSettingViewModel
            .Input(
                btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
                textID: self.tfID.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidBeginID: self.tfID.rx.controlEvent(.editingDidBegin).mapToVoid().asDriverOnErrorJustComplete(),
                editingDidEndID: self.tfID.rx.controlEvent(.editingDidEnd).mapToVoid().asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
        
        output.isEditingID
            .drive(onNext: { isEditing in
                if isEditing {
                    self.tfID.edit()
                } else {
                    self.tfID.normal()
                }
            }).disposed(by: disposeBag)
        
        output.textHint
            .drive(onNext: { type in
                switch type {
                case .none:
                    self.lblHint.normal()
                case .invalid, .duplicate:
                    self.lblHint.error(type.rawValue)
                    self.tfID.error()
                case .succes:
                    self.lblHint.success(type.rawValue)
                    self.tfID.success()
                }
            }).disposed(by: disposeBag)
        
        output.isAvailableID
            .drive(onNext: { isAvailable in
                self.btnDone.isEnabled = isAvailable
                self.imgvConfirm.image = isAvailable ? Asset.Assets.idsettingConfirm.image : Asset.Assets.idsettingConfirmDis.image
            }).disposed(by: disposeBag)
        
        output.goToNicknameSetting
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .nicknameSetting(viewModel: viewModel), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
    }
}
