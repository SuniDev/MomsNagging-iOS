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
    let viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
    })
    
    let imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.logo.image
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
            $0.top.leading.trailing.bottom.equalTo(view)
        })
        
        imgvLogo.snp.makeConstraints({
            $0.center.equalTo(viewBackground.snp.center)
        })
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = IntroViewModel.Input(didLoadIntro: rx.viewDidLoad.asDriver())
        let output = viewModel.transform(input: input)

        // TODO: - 앱 업데이트가 필요할 때 알럿 노출,
        // TODO: - 첫 진입일 때, 튜토리얼 이동
        // TODO: - 로그인 실패 -> 로그인 화면
        // TODO: - 자동 로그인 -> 로그인 성공 -> 메인 화면
//        Observable.just(Void())
//            .subscribe(onNext: {
//                self.viewModel.getLoginInfo()
//            }).disposed(by: disposeBag)
        
//        viewModel.isAutoLogin?.subscribe(onNext: { [weak self] isAutoLogin in
//            if isAutoLogin {
//            } else {
//                let viewModel = LoginViewModel()
//                self?.navigator.show(seque: .login(viewModel: viewModel), sender: self)
//            }
//        }).disposed(by: disposeBag)
    }
    
}
