//
//  PrivacyPolicyView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//
import UIKit
import Then
import SnapKit
import RxSwift

class PrivacyPolicyView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Init
    init(viewModel: PrivacyPolicyViewModel, navigator: Navigator) {
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
    var viewModel: PrivacyPolicyViewModel!
    var disposedBag = DisposeBag()
    var listStatus: [Bool] = []
    // MARK: - UI Properties
    var backBtn = UIButton()
    var headFrame = UIView()
    var tableView = UITableView().then({
        $0.register(PrivacyPolicyCell.self, forCellReuseIdentifier: "PrivacyPolicyCell")
        $0.register(PrivacyPolicyOpenCell.self, forCellReuseIdentifier: "PrivacyPolicyOpenCell")
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.separatorStyle = .none
    })
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "개인정보처리방침")
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
        let input = PrivacyPolicyViewModel.Input()
        let output = viewModel.transform(input: input)
        
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
        output.privacyPolicyListData?.drive { list in
            list.bind(to: self.tableView.rx.items) { tableView, row, item -> UITableViewCell in
                if self.listStatus.count < 5 {
                    self.listStatus.append(false)
                }
                if self.listStatus[row] {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyPolicyOpenCell", for: IndexPath.init(row: row, section: 0)) as? PrivacyPolicyOpenCell
                    cell?.titleLbl.text = item.title ?? ""
                    cell?.contentLbl.text = item.contents ?? ""
                    cell?.layoutIfNeeded()
                    return cell!
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyPolicyCell", for: IndexPath.init(row: row, section: 0)) as? PrivacyPolicyCell
                    cell?.titleLbl.text = item.title ?? ""
                    return cell!
                }
            }.disposed(by: disposedBag)
        }
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            if self.listStatus[indexPath.row] {
                self.listStatus[indexPath.row] = false
            } else {
                self.listStatus[indexPath.row] = true
            }
            self.tableView.reloadData()
        }).disposed(by: disposedBag)
        backBtn.rx.tap.bind {
            self.navigator.pop(sender: self)
        }.disposed(by: disposedBag)
    // MARK: - Other
    }
}

extension PrivacyPolicyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.listStatus[indexPath.row] {
            return UITableView.automaticDimension
        } else {
            return 64
        }
    }
}
