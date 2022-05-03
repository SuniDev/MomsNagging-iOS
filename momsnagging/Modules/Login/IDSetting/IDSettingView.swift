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
        $0.backgroundColor = Asset.Color.skyblue.color
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
    
    lazy var tfID = UITextField().then({
        $0.addBorder(color: Asset.Color.monoLight030.color, width: 1)
        $0.layer.cornerRadius = 4
        $0.placeholder = "여기에 아이디를 입력해보렴"
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
    
    lazy var btnDone = CommonButton().then({
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
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

        // Do any additional setup after loading the view.
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.skyblue.color
               
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        view.addSubview(viewBottom)
        viewBackground.addSubview(imgvQuestion)
        viewBackground.addSubview(imgvAnswer)
        viewBackground.addSubview(tfID)
        viewBackground.addSubview(lblHintID)
        
        viewBackground.addSubview(viewConfirm)
        viewConfirm.addSubview(imgvConfirm)
        viewConfirm.addSubview(btnDone)
        
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        viewBottom.snp.makeConstraints({
            $0.top.equalTo(viewBackground.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        })
        
        imgvQuestion.snp.makeConstraints({
            $0.width.equalTo(319)
            $0.height.equalTo(72)
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(15)
        })
        
        imgvAnswer.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.height.equalTo(120)
            $0.top.equalTo(imgvQuestion.snp.bottom).offset(42)
            $0.trailing.equalToSuperview().offset(-15)
        })
        
        tfID.snp.makeConstraints({
            $0.height.equalTo(48)
            $0.top.equalTo(imgvAnswer).offset(26)
            $0.leading.equalTo(imgvAnswer).offset(20)
            $0.trailing.equalTo(imgvAnswer).offset(-28)
        })
        
        lblHintID.snp.makeConstraints({
            $0.top.equalTo(tfID.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(tfID)
        })
                
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
                textID: self.tfID.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidBeginID: self.tfID.rx.controlEvent(.editingDidBegin).mapToVoid().asDriverOnErrorJustComplete(),
                editingDidEndID: self.tfID.rx.controlEvent(.editingDidEnd).mapToVoid().asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.editingID
            .drive(onNext: {
                self.tfID.addBorder(color: Asset.Color.priMain.color, width: 1)
                self.lblHintID.isHidden = true
            }).disposed(by: disposeBag)
        
        output.defaultID
            .drive(onNext: {
                self.tfID.addBorder(color: Asset.Color.monoLight030.color, width: 1)
            }).disposed(by: disposeBag)

        output.invalidID
            .drive(onNext: { _ in
                self.setIDErrorMessage(STR_ID_INVALID)
            }).disposed(by: disposeBag)
        
        output.duplicateID
            .drive(onNext: { _ in
                self.setIDErrorMessage(STR_ID_DUPLICATE)
            }).disposed(by: disposeBag)
        
        output.availableID
            .drive(onNext: { _ in
                self.setEnabledConfirm(true)
                self.lblHintID.isHidden = false
                self.tfID.addBorder(color: Asset.Color.monoLight030.color, width: 1)
                self.lblHintID.textColor = Asset.Color.success.color
                self.lblHintID.text = STR_ID_AVAILABLE
            }).disposed(by: disposeBag)
        
        output.unavailableID
            .drive(onNext: {
                self.setEnabledConfirm(false)
            }).disposed(by: disposeBag)
        
        output.successIDSetting
            .drive(onNext: { loginInfo in
                self.navigator.show(seque: .nicknameSetting(viewModel: NicknameSettingViewModel(loginInfo: loginInfo)), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
    }
}
extension IDSettingView {
    private func setIDErrorMessage(_ message: String) {
        self.lblHintID.isHidden = false
        self.lblHintID.textColor = Asset.Color.error.color
        self.lblHintID.text = message
        self.tfID.addBorder(color: Asset.Color.error.color, width: 1)
    }
    
    private func setEnabledConfirm(_ isEnabled: Bool) {
        btnDone.isEnabled = isEnabled
        imgvConfirm.image = isEnabled ? Asset.Assets.idsettingConfirm.image : Asset.Assets.idsettingConfirmDis.image
    }
}
