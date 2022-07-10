//
//  IntroView.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class IntroView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: IntroViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
    })
    
    lazy var imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.introLogo.image
    })
    
    lazy var popup = CommonPopup()
    
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
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
        })
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let foreceUpdatePopupHandler = PublishRelay<Void>()
        let selectUpdatePopupHandler = PublishRelay<Bool>()
        
        let input = IntroViewModel.Input(willAppearIntro: rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
                                         foreceUpdatePopupHandler: foreceUpdatePopupHandler.asDriverOnErrorJustComplete(),
                                         selectUpdatePopupHandler: selectUpdatePopupHandler.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.forceUpdateStatus
              .drive(onNext: { () in
                  self.popup.setUI(popupType: .forceUpdate)
                  self.popup.showAnim(vc: self, parentAddView: self.view)
                  
                  self.popup.btnCenter.rx.tap.subscribe(onNext: {
                      foreceUpdatePopupHandler.accept(())
                  }).disposed(by: self.disposeBag)
              }).disposed(by: disposeBag)
        
        output.selectUpdateStatus
              .drive(onNext: { () in
                  self.popup.setUI(popupType: .selectUpdate)
                  self.popup.showAnim(vc: self, parentAddView: self.view)
                  
                  self.popup.btnLeft.rx.tap.subscribe(onNext: {
                      selectUpdatePopupHandler.accept(false)
                  }).disposed(by: self.disposeBag)
                  self.popup.btnRight.rx.tap.subscribe(onNext: {
                      selectUpdatePopupHandler.accept(true)
                  }).disposed(by: self.disposeBag)
              }).disposed(by: disposeBag)
        
        output.goToOnboarding
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .onboarding(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
        
        output.goToLogin
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .login(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
        
        output.goToMain
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .mainContainer(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
        
        output.goToForceUpdate
            .drive(onNext: {
                Common.moveAppStore(){
                    NotificationCenter.default.post(name: NSNotification.Name("UIApplicationWillTerminateNotification"), object: nil)
                    exit(0)
                }
            }).disposed(by: disposeBag)
        
        output.goToSelectUpdate
            .drive(onNext: {
                Common.moveAppStore()
            }).disposed(by: disposeBag)
        
    }
}
