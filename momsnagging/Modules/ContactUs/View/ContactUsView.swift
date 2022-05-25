//
//  ContactUsView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ContactUsView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Init
    init(viewModel: ContactUsViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: ContactUsViewModel!
    // MARK: - UI Properties
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        
    }
    // MARK: - Bind
    override func bind() {
    }
    
}

