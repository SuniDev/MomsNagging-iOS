//
//  NicknameSettingViewController.swift
//  momsnagging
//
//  Created by suni on 9/24/24.
//

import UIKit

import SnapKit
import Then
import RxViewController
import ReactorKit

class NicknameSettingViewController: BaseViewController {

    // MARK: - Constants
    struct Constants {
        let customNameHeight: CGFloat = 100
        let answerHeight: CGFloat = 190
        
        var answerToConfirmMargin: CGFloat = 16
        var viewContentsHeight: CGFloat = 0
    }
    
    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    var constants = Constants()
    
    // MARK: - UI Properties
    let viewContents = UIView()
    lazy var scrollView = AppView.scrollView(viewContents: viewContents, bounces: false)
    
    lazy var viewCancel = UIView()
    lazy var btnCancel = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var imgvCancel = UIImageView().then({
        $0.image = Asset.Icon.x.image
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
    
    let tfNickname = AppTextField().then({
        $0.placeholder = L10n.nicknamePlaceholder
        $0.isHidden = true
        $0.normalBorderColor = Asset.Color.monoLight030.color
        $0.successBorderColor = Asset.Color.monoLight030.color
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    })
    let lblHint = AppHintLabel()
    lazy var viewHintTextField = AppView.hintTextFieldView(tf: tfNickname, lblHint: lblHint)
    
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
        $0.text = L10n.nicknameConfirm
        $0.font = FontFamily.Pretendard.bold.font(size: 18)
        $0.textColor = Asset.Color.monoDark010.color
    })
    
    lazy var lblNickname = UILabel().then({
        $0.textAlignment = .center
        $0.text = ""
    })
    
    lazy var btnDone = AppButton().then({
        $0.highlightedBackgroundColor = Asset.Color.priDark020.color
        $0.disabledBackgroundColor = Asset.Color.priLight018Dis.color
        $0.isEnabled = false
        $0.setTitle(L10n.nicknameDoneTitle, for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.layer.cornerRadius = 20
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    // MARK: - Init
    init(with reactor: NicknameSettingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI & Layout
    override func initUI() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        scrollView.showsVerticalScrollIndicator = false
        
        view.backgroundColor = Asset.Color.monoLight010.color
    }
    
    override func initLayout() {
        view.addSubview(viewBottom)
        view.addSubview(scrollView)
        
        viewContents.addSubview(viewCancel)
        viewCancel.addSubview(imgvCancel)
        viewCancel.addSubview(btnCancel)
        
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
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        })
        
        viewCancel.snp.makeConstraints({
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(16)
        })
        
        imgvCancel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        btnCancel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        imgvQuestion.snp.makeConstraints({
            $0.width.equalTo(270)
            $0.height.equalTo(72)
            $0.top.equalTo(viewCancel.snp.bottom).offset(10)
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
            $0.top.equalTo(viewAnswer.snp.bottom).offset(constants.answerToConfirmMargin)
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
        
        let safeAreaHeight = Utils.safeareaHeight
        constants.viewContentsHeight = viewContents.bounds.height
        
        if safeAreaHeight > constants.viewContentsHeight {
            constants.answerToConfirmMargin = safeAreaHeight - constants.viewContentsHeight + constants.answerToConfirmMargin
            viewConfirm.snp.updateConstraints({
                $0.top.equalTo(viewAnswer.snp.bottom).offset(constants.answerToConfirmMargin)
            })
        }
    }
    
    // MARK: - ScrollView TapGesture로 키보드 내리기.
    @objc
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

extension NicknameSettingViewController: View {
    func bind(reactor: NicknameSettingReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindView(_ reactor: NicknameSettingReactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.willAppearNicknameSetting }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: NicknameSettingReactor) { }
    
    private func bindState(_ reactor: NicknameSettingReactor) {
        reactor.state.map { $0.step }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.steps.accept(step)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEditView }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEdit in
                self?.viewCancel.isHidden = !isEdit
            })
            .disposed(by: disposeBag)
    }
}
