//
//  NicknameSettingViewController.swift
//  momsnagging
//
//  Created by suni on 9/24/24.
//

import UIKit

import SnapKit
import Then
import RxViewController
import ReactorKit

class NicknameSettingViewController: BaseViewController {

    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    // MARK: - Init
    init(with reactor: NicknameSettingReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NicknameSettingViewController: View {
    func bind(reactor: NicknameSettingReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindView(_ reactor: NicknameSettingReactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.willAppearNicknameSetting }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: NicknameSettingReactor) { }
    
    private func bindState(_ reactor: NicknameSettingReactor) {
        reactor.state.map { $0.step }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] step in
                self?.steps.accept(step)
            })
            .disposed(by: disposeBag)
    }
}
