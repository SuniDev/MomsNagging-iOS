//
//  IntroViewController.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class IntroViewController: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: IntroViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
    })
    
    lazy var imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.logoLight.image
    })
    
    // MARK: - init
    init(viewModel: IntroViewModel, navigator: Navigator) {
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
    }
    
    // MARK: - initUI
    override func initUI() {
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(imgvLogo)
        
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
        imgvLogo.snp.makeConstraints({
            $0.center.equalTo(viewBackground)
        })
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = IntroViewModel.Input(willAppearIntro: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.forceUpdateStatus
              .drive(onNext: { () in
              CommonView.showAlert(vc: self, type: .oneButton, title: STR_UPDATE, message: "", doneTitle: STR_DONE_UPDATE, doneHandler: {
                // TODO: 업데이트 -> 앱 스토어 이동 처리.
              })
              }).disposed(by: disposeBag)
        
        output.selectUpdateStatus
              .drive(onNext: { () in
                  CommonView.showAlert(vc: self, type: .twoButton, title: STR_UPDATE, message: "", cancelTitle: STR_CANCEL_UPDATE, doneTitle: STR_DONE_UPDATE, doneHandler: {
                    // TODO: 업데이트 -> 앱 스토어 이동 처리.
                  })
              }).disposed(by: disposeBag)
        
        output.firstEntryApp
            .drive(onNext: { () in
                self.navigator.show(seque: .onboarding(viewModel: OnboardingViewModel()), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
        
        output.failLogin
            .drive(onNext: { () in
                self.navigator.show(seque: .login(viewModel: LoginViewModel()), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
    }
}
