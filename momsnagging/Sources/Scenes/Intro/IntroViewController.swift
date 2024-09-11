//
//  IntroViewController.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import UIKit

import SnapKit
import Then
import RxViewController
import ReactorKit

class IntroViewController: BaseViewController {

    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
    })
    
    lazy var imgvLogo = UIImageView().then({
        $0.image = Asset.Assets.introLogo.image
    })
    
    // MARK: - Init
    init(with reactor: IntroReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - init UI & Layout
    override func initLayout() {
        view.addSubview(viewBackground)
        viewBackground.addSubview(imgvLogo)
        
        viewBackground.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalToSuperview()
        })
        
        imgvLogo.snp.makeConstraints({
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
        })
    }
}

extension IntroViewController: View {
    func bind(reactor: IntroReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindView(_ reactor: IntroReactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.willAppearIntro }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: IntroReactor) { }
    
    private func bindState(_ reactor: IntroReactor) {
        reactor.state.map { $0.step }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.steps.accept(step)
            })
            .disposed(by: disposeBag)
    }
}
