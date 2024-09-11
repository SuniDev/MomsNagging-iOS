//
//  OnboardingViewController.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

import SnapKit
import Then
import RxViewController
import ReactorKit

class OnboardingViewController: BaseViewController {
    
    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    // MARK: - Init
    init(with reactor: OnboardingReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - init UI & Layout
    override func initLayout() {
        
    }
}

extension OnboardingViewController: View {
    func bind(reactor: OnboardingReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindView(_ reactor: OnboardingReactor) {
        
    }
    
    private func bindAction(_ reactor: OnboardingReactor) { }
    
    private func bindState(_ reactor: OnboardingReactor) {
        reactor.state.map { $0.step }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.steps.accept(step)
            })
            .disposed(by: disposeBag)
    }
    
}
