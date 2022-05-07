//
//  DetailDiaryView.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa

class DetailDiaryView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: DetailDiaryViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    lazy var lblDate = UILabel()
    lazy var btnDone = UIButton()
    
    lazy var imgvDropDown = UIImageView().then({
        $0.image = Asset.Icon.chevronDown.image
    })
    lazy var btnCalendar = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var btnModify = UIButton().then({
        $0.isHidden = true
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(Asset.Color.priMain.color, for: .normal)
        $0.setTitleColor(Asset.Color.priDark020.color, for: .highlighted)
    })
    
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var tfTitle = UITextField()
    
    lazy var tvContents = UITextView().then({
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark010.color
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    })
    
    // MARK: - init
    init(viewModel: DetailDiaryViewModel, navigator: Navigator) {
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
        view.backgroundColor = Asset.Color.monoWhite.color
        
        tfTitle = CommonView.textField(placeHolder: "제목", FontFamily.Pretendard.regular.font(size: 16)).then({
            $0.contentVerticalAlignment = .center
            $0.borderStyle = .none
            $0.returnKeyType = .next
        })
        viewHeader = CommonView.detailHeadFrame(btnBack: btnBack, lblTitle: lblDate, btnDone: btnDone)
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        viewHeader.addSubview(imgvDropDown)
        viewHeader.addSubview(btnCalendar)
        viewHeader.addSubview(btnModify)
        
        view.addSubview(viewBackground)
        viewBackground.addSubview(tfTitle)
        viewBackground.addSubview(tvContents)
        
        viewHeader.snp.makeConstraints({
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        })
        
        imgvDropDown.snp.makeConstraints({
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lblDate.snp.trailing).offset(9)
        })
        
        btnCalendar.snp.makeConstraints({
            $0.top.leading.equalTo(lblDate).offset(-5)
            $0.trailing.equalTo(imgvDropDown).offset(5)
            $0.bottom.equalTo(lblDate).offset(5)
        })
        
        btnModify.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        })
        
        viewBackground.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        tfTitle.snp.makeConstraints({
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        tvContents.snp.makeConstraints({
            $0.top.equalTo(tfTitle.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-24)
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let doneAlertDoneHandler = PublishRelay<Void>()
        
        let input = DetailDiaryViewModel
            .Input(
                btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
                textTitle: self.tfTitle.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                textContents: self.tvContents.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidEndOnExitTitle: self.tfTitle.rx.controlEvent(.editingDidEndOnExit).asDriverOnErrorJustComplete(),
                didBeginContents: self.tvContents.rx.didBeginEditing.asDriverOnErrorJustComplete(),
                didEndEditingContents: self.tvContents.rx.didEndEditing.asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete(),
                btnModifyTapped: self.btnModify.rx.tap.asDriverOnErrorJustComplete(),
                doneAlertDoneHandler: doneAlertDoneHandler.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.isWriting
            .drive(onNext: { isWriting in
                self.tfTitle.isEnabled = isWriting
                self.tvContents.isEditable = isWriting
                self.btnDone.isHidden = !isWriting
                self.btnModify.isHidden = isWriting
            }).disposed(by: disposeBag)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
        
        output.endEditingTitle
            .drive(onNext: {
                self.tfTitle.resignFirstResponder()
                self.tvContents.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        output.setContentsPlaceholder
            .drive(onNext: { text in
                self.tvContents.text = text
                self.tvContents.textColor = text.isEmpty ? Asset.Color.monoDark010.color : Asset.Color.monoDark030.color
            }).disposed(by: disposeBag)
        
        output.canBeDone
            .drive(onNext: { isEnabled in
                self.btnDone.isEnabled = isEnabled
            }).disposed(by: disposeBag)
        
        output.successDoneDiary
            .drive(onNext: { title in
                self.view.endEditing(true)
                CommonView.showAlert(vc: self, type: .oneBtn, title: title, message: "", doneTitle: STR_DONE, doneHandler: {
                    doneAlertDoneHandler.accept(())
                })
            }).disposed(by: disposeBag)
                
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { height in
                let margin = height + 16
                self.tvContents.snp.updateConstraints({
                    $0.bottom.equalToSuperview().offset(-margin)
                })
                self.view.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
}
