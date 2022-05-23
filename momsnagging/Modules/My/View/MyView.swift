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
    lazy var viewPorfileImage = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 42
        $0.addShadow(color: .black, alpha: 0.08, x: 0, y: 5.25, blur: 26.25, spread: 0)
    })
    lazy var imgvProfile = UIImageView().then({
        $0.image = Asset.Assets.namesettingDaughter.image
    })
    lazy var lblID = UILabel().then({
        $0.font = FontFamily.Pretendard.bold.font(size: 24)
        $0.textColor = Asset.Color.monoDark010.color
    })
    lazy var viewMessage = UIView()
    lazy var lblMessage = UILabel().then({
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark020.color
    })
    lazy var btnModifyMessage = UIButton().then({
        $0.setImage(Asset.Icon.editMessage.image, for: .normal)
    })
    lazy var lblEmail = UILabel().then({
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
    
    lazy var viewRadioGroupMom = UIView()
    lazy var viewFondMom = UIView()
    lazy var btnFondMom = UIButton()
    lazy var imgvTipFondMom = UIImageView()
    
    lazy var viewCoolMom = UIView()
    lazy var btnRadioCoolMom = UIButton()
    lazy var imgvTipCoolMom = UIImageView()
    
    lazy var viewAngryMom = UIView()
    lazy var btnRadioAngryMom = UIButton()
    lazy var imgvTipAngryMom = UIImageView()
    lazy var dividerNagging = UIView()
    
    /// PUSH 알림 설정
    lazy var viewPush = UIView()
    lazy var btnPushSetting = UIButton()
    lazy var dividerPush = UIView()
    
    /// 로그아웃
    lazy var viewLogout = UIView()
    lazy var lblLogout = UILabel()
    
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
        btnSetting.setImage(Asset.Icon.medal.image, for: .normal)
        
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: false)
        
        viewNickname = CommonView.goToSubviewFrame(title: "호칭 설정")
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        
        
    }
}
