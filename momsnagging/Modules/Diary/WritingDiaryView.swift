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
    
    lazy var btnComplete = UIButton().then({
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark040.color, for: .normal)
    })
    
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var tfTitle = UITextField().then({
        $0.placeholder = "제목"
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
        $0.returnKeyType = .done
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
        viewHeader.addSubview(btnComplete)
        
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
        
        btnComplete.snp.makeConstraints({
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
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-24)
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = WritingDiaryViewModel
            .Input(
                btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
                textTitle: self.tfTitle.rx.text.distinctUntilChanged().asDriverOnErrorJustComplete(),
                editingDidEndOnExitTitle: self.tfTitle.rx.controlEvent(.editingDidEndOnExit).asDriverOnErrorJustComplete(),
                didBeginContents: self.tvContents.rx.didBeginEditing.asDriverOnErrorJustComplete(),
                didEndEditingContents: self.tvContents.rx.didEndEditing.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.endEditingTitle
            .drive(onNext: {
                self.tfTitle.resignFirstResponder()
                self.tvContents.becomeFirstResponder()
            }).disposed(by: disposeBag)
        
        output.setContentsPlaceholder
            .drive(onNext: { text in
                self.tvContents.text = text
                
            }).disposed(by: disposeBag)
    }
}
//extension WritingDiaryView: UITextViewDelegate {
//
//    func initTextView() {
//        tvContents.delegate = self
//        tvContents.text = getContentsPlaceholder(.fondMom)
//        tvContents.textColor = .lightGray
//    }
//
//    // TextView Place Holder
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .lightGray {
//            textView.text = nil
//            textView.font = FontFamily.Pretendard.regular.font(size: 14)
//            textView.textColor = Asset.Color.monoDark010.color
//        }
//
//    }
//    // TextView Place Holder
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = getContentsPlaceholder(.fondMom)
//            textView.font = FontFamily.Pretendard.regular.font(size: 14)
//            textView.textColor = .lightGray
//        }
//    }
//}
