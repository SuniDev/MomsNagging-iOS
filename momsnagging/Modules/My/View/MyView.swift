//
//  MyView.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MyView: BaseViewController, Navigatable {
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: MyViewModel!
    
    // MARK: - UI Properties
    /// 헤더 & 컨텐츠뷰
    lazy var headFrame = UIView()
    lazy var btnNone = UIButton().then({
        $0.isUserInteractionEnabled = false
    })
    lazy var btnSetting = UIButton()
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    /// 프로필
    lazy var viewProfile = UIView()
    lazy var viewProfileImage = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 42
        $0.addShadow(color: .black, alpha: 0.08, x: 0, y: 5.25, blur: 26.25, spread: 0)
    })
    lazy var imgvProfile = UIImageView().then({
        $0.image = Asset.Assets.emojiDaughter.image
    })
    lazy var lblID = UILabel().then({
        $0.text = ""
        $0.font = FontFamily.Pretendard.bold.font(size: 24)
        $0.textColor = Asset.Color.monoDark010.color
    })
    lazy var viewStatusMsg = UIView()
    lazy var lblStatusMsg = UILabel().then({
        $0.text = STR_STATUSMSG_DEFAULT
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark020.color
    })
    lazy var btnModifyStatusMsg = UIButton().then({
        $0.setImage(Asset.Icon.editMessage.image, for: .normal)
    })
    lazy var lblEmail = UILabel().then({
        $0.text = ""
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.priLight030.color
    })
    lazy var dividerProfile = CommonView.divider()
    
    /// 호칭 설정
    lazy var viewNickname = UIView()
    lazy var btnNicknameSetting = UIButton()
    
    /// 잔소리 강도 설정
    lazy var viewNaggingIntensity = UIView()
    lazy var lblNaggingIntensity = UILabel().then({
        $0.text = "잔소리 강도 설정"
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    
    lazy var viewRadioGroupNagging = UIView()
    
    lazy var fondMomRadiobuttonFrame = UIView()
    lazy var rbFondMom = CommonTextRadioButton()
    
    lazy var coolMomRadiobuttonFrame = UIView()
    lazy var rbCoolMom = CommonTextRadioButton()
    
    lazy var angryMomRadiobuttonFrame = UIView()
    lazy var rbAngryMom = CommonTextRadioButton()
    lazy var dividerNaggingIntensity = CommonView.divider()
    
    lazy var viewNaggingTip = UIView()
    lazy var imgvTipArrowFondMom = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.myTipArrow.image
    })
    lazy var imgvTipFondMom = UIImageView().then({
        $0.isHidden = true
        $0.image = Common.getNaggingTip(naggingIntensity: .fondMom)
    })
    
    lazy var imgvTipArrowCoolMom = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.myTipArrow.image
    })
    lazy var imgvTipCoolMom = UIImageView().then({
        $0.isHidden = true
        $0.image = Common.getNaggingTip(naggingIntensity: .coolMom)
    })
    
    lazy var imgvTipArrowAngryMom = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.myTipArrow.image
    })
    lazy var imgvTipAngryMom = UIImageView().then({
        $0.isHidden = true
        $0.image = Common.getNaggingTip(naggingIntensity: .angryMom)
    })
    
    /// PUSH 알림 설정
    lazy var viewPush = UIView()
    lazy var btnPushSetting = UIButton()
    
    /// 로그아웃
    lazy var viewLogout = UIView()
    lazy var lblLogout = UILabel().then({
        $0.text = "로그아웃"
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = Asset.Color.monoDark030.color
    })
    lazy var btnLogout = UIButton().then({
        $0.backgroundColor = .clear
    })
    lazy var dividerLogout = CommonView.divider()
    
    // MARK: - Init
    init(viewModel: MyViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
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
        
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: btnNone, headTitle: "마이", rightIcBtn: btnSetting)
        btnNone.setImage(nil, for: .normal)
        btnSetting.setImage(Asset.Icon.settings.image, for: .normal)
        
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: false)
        
        viewNickname = CommonView.goToSubviewFrame(title: "호칭 설정")
        
        fondMomRadiobuttonFrame = CommonView.naggingRadioButtonFrame(naggingIntensity: NaggingLevel.fondMom, rbNagging: rbFondMom)
        coolMomRadiobuttonFrame = CommonView.naggingRadioButtonFrame(naggingIntensity: NaggingLevel.coolMom, rbNagging: rbCoolMom)
        angryMomRadiobuttonFrame = CommonView.naggingRadioButtonFrame(naggingIntensity: NaggingLevel.angryMom, rbNagging: rbAngryMom)
        
        viewPush = CommonView.goToSubviewFrame(title: "PUSH 알림 설정")
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(scrollView)
        
        headFrame.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        /// View Contents
        viewContents.addSubview(viewProfile)
        viewContents.addSubview(viewNickname)
        viewContents.addSubview(viewNaggingIntensity)
        viewContents.addSubview(viewPush)
        viewContents.addSubview(viewLogout)
        
        viewProfile.snp.makeConstraints({
            $0.height.equalTo(213)
            $0.top.leading.trailing.equalToSuperview()
        })
        
        viewNickname.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewProfile.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        })
        
        viewNaggingIntensity.snp.makeConstraints({
            $0.height.equalTo(281)
            $0.top.equalTo(viewNickname.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        })
        
        viewPush.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewNaggingIntensity.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        })
        
        viewLogout.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewPush.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        /// 프로필
        viewProfile.addSubview(viewProfileImage)
        viewProfileImage.addSubview(imgvProfile)
        
        viewProfileImage.snp.makeConstraints({
            $0.width.height.equalTo(84)
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
        })
        imgvProfile.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        viewProfile.addSubview(lblID)
        viewProfile.addSubview(viewStatusMsg)
        viewStatusMsg.addSubview(lblStatusMsg)
        viewStatusMsg.addSubview(btnModifyStatusMsg)
        
        lblStatusMsg.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        })
        btnModifyStatusMsg.snp.makeConstraints({
            $0.width.height.equalTo(18)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(lblStatusMsg.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        })
        
        viewProfile.addSubview(lblEmail)
        viewProfile.addSubview(dividerProfile)
        
        lblID.snp.makeConstraints({
            $0.top.equalTo(viewProfileImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        })
        viewStatusMsg.snp.makeConstraints({
            $0.height.equalTo(22)
            $0.top.equalTo(lblID.snp.bottom).offset(8)
            $0.leading.greaterThanOrEqualToSuperview().offset(18)
            $0.trailing.lessThanOrEqualToSuperview().offset(-18)
            $0.centerX.equalToSuperview()
        })
        
        lblEmail.snp.makeConstraints({
            $0.top.equalTo(viewStatusMsg.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        })
        dividerProfile.snp.makeConstraints({
            $0.top.equalTo(lblEmail.snp.bottom).offset(26)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        /// 호칭 설정
        viewNickname.addSubview(btnNicknameSetting)
        btnNicknameSetting.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-1)
        })
        
        /// 잔소리 강도 설정
        viewNaggingIntensity.addSubview(lblNaggingIntensity)
        viewNaggingIntensity.addSubview(viewRadioGroupNagging)
        
        viewRadioGroupNagging.addSubview(fondMomRadiobuttonFrame)
        viewRadioGroupNagging.addSubview(coolMomRadiobuttonFrame)
        viewRadioGroupNagging.addSubview(angryMomRadiobuttonFrame)
        
        lblNaggingIntensity.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(18)
        })
        viewRadioGroupNagging.snp.makeConstraints({
            $0.height.equalTo(192)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.top.equalTo(lblNaggingIntensity.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        })
        
        fondMomRadiobuttonFrame.snp.makeConstraints({
            $0.top.leading.equalToSuperview()
        })
        coolMomRadiobuttonFrame.snp.makeConstraints({
            $0.width.equalTo(fondMomRadiobuttonFrame)
            $0.leading.equalTo(fondMomRadiobuttonFrame.snp.trailing)
            $0.top.equalToSuperview()
        })
        angryMomRadiobuttonFrame.snp.makeConstraints({
            $0.width.equalTo(fondMomRadiobuttonFrame)
            $0.leading.equalTo(coolMomRadiobuttonFrame.snp.trailing)
            $0.top.trailing.equalToSuperview()
        })
        
        viewRadioGroupNagging.addSubview(imgvTipArrowFondMom)
        viewRadioGroupNagging.addSubview(imgvTipFondMom)
        viewRadioGroupNagging.addSubview(imgvTipArrowCoolMom)
        viewRadioGroupNagging.addSubview(imgvTipCoolMom)
        viewRadioGroupNagging.addSubview(imgvTipArrowAngryMom)
        viewRadioGroupNagging.addSubview(imgvTipAngryMom)
        
        imgvTipArrowFondMom.snp.makeConstraints({
            $0.width.equalTo(12)
            $0.height.equalTo(6)
            $0.centerX.equalTo(fondMomRadiobuttonFrame.snp.centerX)
        })
        imgvTipFondMom.snp.makeConstraints({
            $0.height.equalTo(62)
            $0.width.equalTo(276)
            $0.top.equalTo(imgvTipArrowFondMom.snp.bottom)
            $0.leading.bottom.equalToSuperview()
        })
        imgvTipArrowCoolMom.snp.makeConstraints({
            $0.width.equalTo(12)
            $0.height.equalTo(6)
            $0.centerX.equalTo(coolMomRadiobuttonFrame.snp.centerX)
        })
        imgvTipCoolMom.snp.makeConstraints({
            $0.height.equalTo(62)
            $0.width.equalTo(237)
            $0.top.equalTo(imgvTipArrowCoolMom.snp.bottom)
            $0.bottom.centerX.equalToSuperview()
        })
        imgvTipArrowAngryMom.snp.makeConstraints({
            $0.width.equalTo(12)
            $0.height.equalTo(6)
            $0.centerX.equalTo(angryMomRadiobuttonFrame.snp.centerX)
        })
        imgvTipAngryMom.snp.makeConstraints({
            $0.height.equalTo(62)
            $0.width.equalTo(266)
            $0.top.equalTo(imgvTipArrowAngryMom.snp.bottom)
            $0.trailing.bottom.equalToSuperview()
        })

        viewNaggingIntensity.addSubview(dividerNaggingIntensity)
        dividerNaggingIntensity.snp.makeConstraints({
            $0.top.equalTo(viewRadioGroupNagging.snp.bottom).offset(20)
            $0.trailing.leading.bottom.equalToSuperview()
        })

        /// PUSH 알림 설정
        viewPush.addSubview(btnPushSetting)
        btnPushSetting.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-1)
        })
        
        /// 로그아웃
        viewLogout.addSubview(lblLogout)
        viewLogout.addSubview(btnLogout)
        viewLogout.addSubview(dividerLogout)
        
        lblLogout.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(18)
        })
        btnLogout.snp.makeConstraints({
            $0.top.leading.equalTo(lblLogout).offset(-5)
            $0.bottom.trailing.equalTo(lblLogout).offset(5)
        })
        dividerLogout.snp.makeConstraints({
            $0.leading.bottom.trailing.equalToSuperview()
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let statusModifyAlertDoneHandler = PublishRelay<String?>()
        let nicknameSettingAlertDoneHandler = PublishRelay<String?>()
        let logoutAlertDoneHandler = PublishRelay<Void>()
                
        let input = MyViewModel.Input(
            btnSettingTapped: self.btnSetting.rx.tap.asDriverOnErrorJustComplete(),
            btnModifyStatusTapped: self.btnModifyStatusMsg.rx.tap.asDriverOnErrorJustComplete(),
            statusModifyAlertDoneHandler: statusModifyAlertDoneHandler.asDriverOnErrorJustComplete(),
            btnNicknameSetting: self.btnNicknameSetting.rx.tap.asDriverOnErrorJustComplete(),
            nicknameSettingAlertDoneHandler: nicknameSettingAlertDoneHandler.asDriverOnErrorJustComplete(),
            rbFondMomTapped: self.rbFondMom.rx.tap.asDriverOnErrorJustComplete(),
            rbCoolMomTapped: self.rbCoolMom.rx.tap.asDriverOnErrorJustComplete(),
            rbAngryMomTapped: self.rbAngryMom.rx.tap.asDriverOnErrorJustComplete(),
            btnPushSettingTapped: self.btnPushSetting.rx.tap.asDriverOnErrorJustComplete(),
            btnLogoutTapped: self.btnLogout.rx.tap.asDriverOnErrorJustComplete(),
            logoutAlertDoneHandler: logoutAlertDoneHandler.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        // 설정
        output.goToSetting
            .drive(onNext: {
                self.navigator.show(seque: .setting(viewModel: SettingViewModel()), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
        
        // 아이디
        output.id
            .drive(onNext: { id in
                self.lblID.text = id
            }).disposed(by: disposeBag)
        
        // 이메일
//        output.email
//            .drive(onNext: { email in
//                self.lblEmail.text = email
//            }).disposed(by: disposeBag)
        
        // 각오
        output.statusMsg
            .drive(onNext: { statusMsg in
                self.lblStatusMsg.text = statusMsg
            }).disposed(by: disposeBag)
        output.showStatusModifyAlert
            .drive(onNext: { model in
                let alert = CommonView.getAlert(vc: self, title: model.title, message: model.message, cancelTitle: model.cancelTitle ?? STR_CANCEL)
                
                alert.addTextField { textField in
                    textField.text = model.textFieldText
                    textField.placeholder = model.textFieldPlaceholder
                    textField.clearButtonMode = .whileEditing
                }
                
                let doneAction = UIAlertAction(title: model.doneTitle, style: .default) { _ in
                    statusModifyAlertDoneHandler.accept(alert.textFields?[0].text)
                }
                alert.addAction(doneAction)
                
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
        // 호칭 설정
        output.nickName
            .debug()
            .drive(onNext: { nickName in
                self.imgvProfile.image = CommonUser.getNicknameImage(nickName)
            }).disposed(by: disposeBag)
        output.showNicknameSettingAlert
            .drive(onNext: { model in
                let alert = CommonView.getAlert(vc: self, title: model.title, message: model.message, cancelTitle: model.cancelTitle ?? STR_CANCEL)
                
                alert.addTextField { textField in
                    textField.text = model.textFieldText
                    textField.placeholder = model.textFieldPlaceholder
                    textField.clearButtonMode = .whileEditing
                }
                
                let doneAction = UIAlertAction(title: model.doneTitle, style: .default) { _ in
                    nicknameSettingAlertDoneHandler.accept(alert.textFields?[0].text)
                }
                alert.addAction(doneAction)
                
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
        // 잔소리 강도 설정
        output.setNaggingIntensity
            .drive(onNext: { naggingIntensity in
                self.rbFondMom.isSelected = naggingIntensity == .fondMom
                self.imgvTipFondMom.isHidden = naggingIntensity != .fondMom
                self.imgvTipArrowFondMom.isHidden = naggingIntensity != .fondMom
            
                self.rbCoolMom.isSelected = naggingIntensity == .coolMom
                self.imgvTipCoolMom.isHidden = naggingIntensity != .coolMom
                self.imgvTipArrowCoolMom.isHidden = naggingIntensity != .coolMom
                
                self.rbAngryMom.isSelected = naggingIntensity == .angryMom
                self.imgvTipAngryMom.isHidden = naggingIntensity != .angryMom
                self.imgvTipArrowAngryMom.isHidden = naggingIntensity != .angryMom
                
            }).disposed(by: disposeBag)
        
        // PUSH 알림 설정
        output.goToPushSetting
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .pushSetting(viewModel: viewModel), sender: self, transition: .navigation)
            }).disposed(by: disposeBag)
        
        // 로그아웃
        output.showLogoutAlert
            .drive(onNext: { message in
                CommonView.showAlert(vc: self, type: .twoBtn, title: "", message: message, cancelTitle: STR_NO, doneTitle: STR_YES) {
                    
                } doneHandler: {
                    Log.debug("TODO: 로그아웃")
                    logoutAlertDoneHandler.accept(())
                }

            }).disposed(by: disposeBag)
        
        output.goToLogin
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .login(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
    }
}
