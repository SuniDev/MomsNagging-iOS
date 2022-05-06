//
//  WritingDiaryView.swift
//  momsnagging
//
//  Created by suni on 2022/05/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard

class WritingDiaryView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: WritingDiaryViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var btnBack = UIButton().then({
        $0.setImage(Asset.Icon.straightLeft.image, for: .normal)
    })
    
    lazy var lblDate = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var imgvDropDown = UIImageView().then({
        $0.image = Asset.Icon.chevronDown.image
    })
    
    lazy var btnCalendar = UIButton().then({
        $0.backgroundColor = .clear
    })
    
    lazy var btnDone = UIButton().then({
        $0.isEnabled = false
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Asset.Color.priMain.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark040.color, for: .disabled)
        $0.setTitleColor(Asset.Color.priDark020.color, for: .highlighted)
    })
    
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var tfTitle = UITextField().then({
        $0.attributedPlaceholder = NSAttributedString(string: "제목",
                                                      attributes: [NSAttributedString.Key.foregroundColor: Asset.Color.monoDark030.color])
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = Asset.Color.monoDark010.color
        $0.addRightAndLeftPadding(width: 8)
        $0.contentVerticalAlignment = .center
        $0.borderStyle = .none
        $0.returnKeyType = .next
    })
    
    lazy var tvContents = UITextView().then({
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark010.color
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    })
    
    // MARK: - init
    init(viewModel: WritingDiaryViewModel, navigator: Navigator) {
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
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        viewHeader.addSubview(btnBack)
        viewHeader.addSubview(lblDate)
        viewHeader.addSubview(imgvDropDown)
        viewHeader.addSubview(btnCalendar)
        viewHeader.addSubview(btnDone)
        
        view.addSubview(viewBackground)
        viewBackground.addSubview(tfTitle)
        viewBackground.addSubview(tvContents)
        
        viewHeader.snp.makeConstraints({
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        })
        
        btnBack.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        })
        
        lblDate.snp.makeConstraints({
            $0.center.equalToSuperview()
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
        
        btnDone.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        })
        
        viewBackground.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
        
        let input = WritingDiaryViewModel
            .Input(
                willApearWritingDiary: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
                btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
                textTitle: self.tfTitle.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                textContents: self.tvContents.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidEndOnExitTitle: self.tfTitle.rx.controlEvent(.editingDidEndOnExit).asDriverOnErrorJustComplete(),
                didBeginContents: self.tvContents.rx.didBeginEditing.asDriverOnErrorJustComplete(),
                didEndEditingContents: self.tvContents.rx.didEndEditing.asDriverOnErrorJustComplete(),
                btnDoneTapped: self.btnDone.rx.tap.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
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
            .debug()
            .drive(onNext: { isEnabled in
                self.btnDone.isEnabled = isEnabled
            }).disposed(by: disposeBag)
        
        output.successDoneDiary
            .drive(onNext: { title in
                CommonView.showAlert(vc: self, type: .oneBtn, title: title, message: "", doneTitle: STR_DONE, doneHandler: {
                    self.navigator.pop(sender: self)
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
