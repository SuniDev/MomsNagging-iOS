//
//  SettingView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//
import UIKit
import Then
import SnapKit
import RxSwift

class SettingView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
    }
    // MARK: - Init
    init(viewModel: SettingViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Temp
    // MARK: - Init
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: MyViewModel!
    // MARK: - UI Properties
    // MARK: - InitUI
    // MARK: - LayoutSetting
    // MARK: - Bind _ Output
    // MARK: - Action Bind _ Input
    // MARK: - Other
    
}
