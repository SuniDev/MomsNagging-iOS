//
//  PerformTimeSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/05/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa

class PerformTimeSettingView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: PerformTimeSettingViewModel?
    var navigator: Navigator!
    
    private let guideCellSpacing: CGFloat = 8
    private var guideCellHeight: CGFloat = 36
    private let guideIdentifier = "GuideCell"
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var btnCancel = UIButton().then({
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark020.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var btnSave = UIButton().then({
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(Asset.Color.success.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark040.color, for: .disabled)
        $0.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.isEnabled = false
    })
    lazy var lblHeadTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.text = "수행 시간 설정"
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    lazy var lblTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.text = "수행 시간"
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    
    lazy var viewHintTextField = UIView()
    lazy var tfPerformTime = CommonTextField().then({
        $0.placeholder = "밥 먹고 난 후, 씻고 나서, 아침 7:00"
        $0.returnKeyType = .done
        $0.clearButtonMode = .whileEditing
    })
    lazy var lblHint = CommonHintLabel()
    lazy var lblTextCount = UILabel().then({
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark020.color
        $0.text = "0/11"
    })
    
    // MARK: - init
    init(viewModel: PerformTimeSettingViewModel, navigator: Navigator) {
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
        view.backgroundColor = Asset.Color.monoWhite.color
        
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: true)
        
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfPerformTime, lblHint: lblHint)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        viewHeader.addSubview(btnCancel)
        viewHeader.addSubview(lblHeadTitle)
        viewHeader.addSubview(btnSave)
        
        view.addSubview(scrollView)
        viewContents.addSubview(lblTitle)
        viewContents.addSubview(viewHintTextField)
        viewHintTextField.addSubview(lblTextCount)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        btnCancel.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        })
        lblHeadTitle.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        btnSave.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
        })
        viewHintTextField.snp.makeConstraints({
            $0.height.equalTo(76)
            $0.top.equalTo(lblTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            // TODO: 임시로 연결
            $0.bottom.equalToSuperview().offset(-24)
        })
        lblTextCount.snp.makeConstraints({
            $0.trailing.bottom.equalToSuperview()
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = PerformTimeSettingViewModel.Input(
            btnCacelTapped: self.btnCancel.rx.tap.asDriverOnErrorJustComplete(),
            btnSaveTapped: self.btnSave.rx.tap.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
    }
}
