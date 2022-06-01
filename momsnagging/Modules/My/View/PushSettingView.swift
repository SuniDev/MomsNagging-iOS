//
//  PushSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class PushSettingView: BaseViewController, Navigatable {
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: PushSettingViewModel!
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    
    lazy var viewGeneralNotice = UIView()
    lazy var lblGeneralNotice = UILabel().then({
        $0.text = "전체 알림"
    })
    lazy var swGeneralNotice = CommonSwitch()
    
    lazy var viewTodoNotice = UIView()
    lazy var lblTodoNotice = UILabel().then({
        $0.text = "할일 알림"
    })
    lazy var swTodoNotice = CommonSwitch()
    
    lazy var viewRoutineNotice = UIView()
    lazy var lblRoutineNotice = UILabel().then({
        $0.text = "습관 알림"
    })
    lazy var swRoutineNotice = CommonSwitch()
    
    lazy var viewWeeklyNotice = UIView()
    lazy var lblWeeklyNotice = UILabel().then({
        $0.text = "주간 평가 알림"
    })
    lazy var swWeeklyNotice = CommonSwitch()
    
    lazy var viewOtherNotice = UIView()
    lazy var lblOtherNotice = UILabel().then({
        $0.text = "기타 알림"
    })
    lazy var swOtherNotice = CommonSwitch()
    
    // MARK: - Init
    init(viewModel: PushSettingViewModel, navigator: Navigator) {
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
        
    }
    // MARK: - InitUI
    override func initUI() {
        self.view.backgroundColor = Asset.Color.monoWhite.color
        
        viewHeader = CommonView.defaultHeadFrame(leftIcBtn: btnBack, headTitle: "PUSH 알림 설정")
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: false)
        
        viewGeneralNotice = CommonView.defaultSwitchFrame(lblTitle: lblGeneralNotice, switchPush: swGeneralNotice)
        viewTodoNotice = CommonView.defaultSwitchFrame(lblTitle: lblTodoNotice, switchPush: swTodoNotice)
        viewRoutineNotice = CommonView.defaultSwitchFrame(lblTitle: lblRoutineNotice, switchPush: swRoutineNotice)
        viewWeeklyNotice = CommonView.defaultSwitchFrame(lblTitle: lblWeeklyNotice, switchPush: swWeeklyNotice)
        viewOtherNotice = CommonView.defaultSwitchFrame(lblTitle: lblOtherNotice, switchPush: swOtherNotice)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        view.addSubview(scrollView)
        
        viewContents.addSubview(viewGeneralNotice)
        viewContents.addSubview(viewTodoNotice)
        viewContents.addSubview(viewRoutineNotice)
        viewContents.addSubview(viewWeeklyNotice)
        viewContents.addSubview(viewOtherNotice)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        viewGeneralNotice.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.leading.trailing.equalToSuperview()
        })
        viewTodoNotice.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewGeneralNotice.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        })
        viewRoutineNotice.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewTodoNotice.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        })
        viewWeeklyNotice.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewRoutineNotice.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        })
        viewOtherNotice.snp.makeConstraints({
            $0.height.equalTo(65)
            $0.top.equalTo(viewWeeklyNotice.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = PushSettingViewModel.Input(
            btnBackTapped: self.btnBack.rx.tap.asDriverOnErrorJustComplete(),
            valueChangedGeneral: self.swGeneralNotice.rx.controlEvent(.valueChanged).withLatestFrom(self.swGeneralNotice.rx.value).asDriverOnErrorJustComplete(),
            valueChangedTodo: self.swTodoNotice.rx.controlEvent(.valueChanged).withLatestFrom(self.swTodoNotice.rx.value).asDriverOnErrorJustComplete(),
            valueChangedRoutine: self.swRoutineNotice.rx.controlEvent(.valueChanged).withLatestFrom(self.swRoutineNotice.rx.value).asDriverOnErrorJustComplete(),
            valueChangedWeekyly: self.swWeeklyNotice.rx.controlEvent(.valueChanged).withLatestFrom(self.swWeeklyNotice.rx.value).asDriverOnErrorJustComplete(),
            valueChangedOther: self.swOtherNotice.rx.controlEvent(.valueChanged).withLatestFrom(self.swOtherNotice.rx.value).asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.setGeneralNotice
            .drive(onNext: { isOn in
                self.swGeneralNotice.isOn = isOn
            }).disposed(by: disposeBag)
        
        output.setTodoNotice
            .drive(onNext: { isOn in
                self.swTodoNotice.isOn = isOn
            }).disposed(by: disposeBag)
        
        output.setRoutineNotice
            .drive(onNext: { isOn in
                self.swRoutineNotice.isOn = isOn
            }).disposed(by: disposeBag)
        
        output.setWeeklyNotice
            .drive(onNext: { isOn in
                self.swWeeklyNotice.isOn = isOn
            }).disposed(by: disposeBag)
        
        output.setOtherNotice
            .drive(onNext: { isOn in
                self.swOtherNotice.isOn = isOn
            }).disposed(by: disposeBag)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
    }
}
