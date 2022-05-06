//
//  DiaryView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/06.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit


class DiaryView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Init
    init(viewModel: DiaryViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: DiaryViewModel!
    var disposedBag = DisposeBag()
    // MARK: - UI Properties
    var backBtn = UIButton()
    var writeBtn = UIButton()
    var headFrame = UIView()
    // MARK: - initUI
    override func initUI() {
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "일기장", rightIcBtn: writeBtn)
    }
    // MARK: - Layout Setting
    override func layoutSetting() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        view.addSubview(headFrame)
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
    }
    // MARK: - Bind
    override func bind() {
    }

}
