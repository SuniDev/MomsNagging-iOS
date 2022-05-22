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
    var viewModel: SettingViewModel!
    var disposedBag = DisposeBag()
    // MARK: - UI Properties
    var backBtn = UIButton()
    var headFrame = UIView()
    var tableView = UITableView().then({
        $0.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    })
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "설정")
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(tableView)
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        tableView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    // MARK: - Bind _ Output
    override func bind() {
        guard let viewModel = viewModel else { return }
        let input = SettingViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.settingListData?.drive { list in
            list.bind(to: self.tableView.rx.items(cellIdentifier: "SettingCell", cellType: SettingCell.self)) { index, item, cell in
                if index == 0 {
                    cell.titleLbl.text = item
                    cell.versionLbl.isHidden = true
                    cell.rightBtn.isHidden = false
                } else if index == 1 {
                    cell.titleLbl.text = item
                    cell.versionLbl.isHidden = true
                    cell.rightBtn.isHidden = false
                } else if index == 2 {
                    cell.titleLbl.text = item
                    cell.versionLbl.isHidden = true
                    cell.rightBtn.isHidden = false
                } else {
                    cell.titleLbl.text = item
                    cell.versionLbl.isHidden = false
                    cell.rightBtn.isHidden = true
                    cell.versionLbl.text = "v.\(TaviCommon.getVersion())"
                }
            }
        }.disposed(by: disposedBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            if indexPath.row == 0 {
                Log.debug("개인정보 처리방침", "클릭")
            } else if indexPath.row == 1 {
                Log.debug("문의하기", "클릭")
            } else if indexPath.row == 2 {
                Log.debug("회월탈퇴", "클릭")
            }
        }).disposed(by: disposedBag)
        
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
    }
    // MARK: - Other
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
