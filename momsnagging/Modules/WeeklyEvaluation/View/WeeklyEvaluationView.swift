//
//  WeeklyEvaluationView.swift
//  momsnagging
//
//  Created by suni on 2022/06/03.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class WeeklyEvaluationView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: WeeklyEvaluationViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var backgroundView = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var evaluationFrame = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 8
    })
    lazy var btnClose = UIButton().then({
        $0.layer.cornerRadius = 21
        $0.setImage(Asset.Icon.x.image, for: .normal)
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var lblTitle = UILabel().then({
        $0.text = "주간평가"
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = Asset.Color.monoDark010.color
    })
    lazy var imgvGrade = UIImageView()
    lazy var viewMessage = UIView()
    lazy var imgvEmoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
        $0.addShadow(color: .black, alpha: 0.08, x: 0, y: 5.25, blur: 26.25, spread: 0)
    })
    lazy var lblMessage = UILabel().then({
        
        $0.text = ""
        $0.numberOfLines = 3
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = Asset.Color.monoDark010.color
    })
    
    // MARK: - init
    init(viewModel: WeeklyEvaluationViewModel, navigator: Navigator) {
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
        self.view.backgroundColor = Asset.Color.monoDark010.color.withAlphaComponent(0.34)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        backgroundView.addSubview(evaluationFrame)
        evaluationFrame.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.height.equalTo(330)
            $0.top.leading.trailing.equalToSuperview()
        })
        
        evaluationFrame.addSubview(lblTitle)
        evaluationFrame.addSubview(imgvGrade)
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        })
        imgvGrade.snp.makeConstraints({
            $0.top.equalTo(lblTitle.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        })
        
        evaluationFrame.addSubview(viewMessage)
        viewMessage.snp.makeConstraints({
            $0.height.equalTo(72)
            $0.top.equalTo(imgvGrade.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        })
        
        viewMessage.addSubview(imgvEmoji)
        viewMessage.addSubview(lblMessage)
        imgvEmoji.snp.makeConstraints({
            $0.width.height.equalTo(44)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        })
        lblMessage.snp.makeConstraints({
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(imgvEmoji.snp.trailing).offset(10)
        })
        
        backgroundView.addSubview(btnClose)
        btnClose.snp.makeConstraints({
            $0.width.height.equalTo(42)
            $0.top.equalTo(evaluationFrame.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
    }
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let input = WeeklyEvaluationViewModel.Input(willApearView: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
                                                    btnCloseTapped: self.btnClose.rx.tap.asDriverOnErrorJustComplete(),
                                                    viewTapped: self.view.rx.tapGesture().mapToVoid().asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.setGrade
            .drive(onNext: { grade in
                self.imgvEmoji.image = Common.getNaggingEmoji(naggingLevel: grade.naggingLevel)
                self.lblMessage.text = grade.message

                switch grade.level {
                case 1: self.imgvGrade.image = Asset.Assets.gradeLevel1.image
                case 2: self.imgvGrade.image = Asset.Assets.gradeLevel2.image
                case 3: self.imgvGrade.image = Asset.Assets.gradeLevel3.image
                case 4: self.imgvGrade.image = Asset.Assets.gradeLevel4.image
                case 5: self.imgvGrade.image = Asset.Assets.gradeLevel5.image
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        output.dismiss
            .drive(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}
