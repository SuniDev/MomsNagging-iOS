//
//  DeleteAccountView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class DeleteAccountView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Init
    init(viewModel: DeleteAccountViewModel, navigator: Navigator) {
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
    var viewModel: DeleteAccountViewModel!
    var selectItemOb = PublishSubject<Bool>()
    // MARK: - UI Properties
    var backBtn = UIButton()
    var headFrame = UIView()
    
    var subjectLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 18)
        $0.numberOfLines = 0
        let text = "어떤 점이 불편하셨는지\n말씀해 주실 수 있으실까요?"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: FontFamily.Pretendard.bold.font(size: 18), range: (text as NSString).range(of: "어떤 점"))
        attributeString.addAttribute(.font, value: FontFamily.Pretendard.bold.font(size: 18), range: (text as NSString).range(of: "불편"))
        $0.attributedText = attributeString
    })
    var emptyView = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
    })
    var selectLbl = UILabel().then({
        $0.text = "이런 점이 불편했어요."
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    var placeHolderLbl = UILabel().then({
        $0.text = "선택해주세요"
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.isHidden = true
    })
    var dropIc = UIImageView().then({
        $0.image = UIImage(asset: Asset.Icon.chevronDown)
    })
    var selectBtn = UIButton().then({
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(asset: Asset.Color.monoLight030)?.cgColor
        $0.layer.borderWidth = 1
    })
    var tableView = UITableView().then({
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.register(InconvenienceListCell.self, forCellReuseIdentifier: "InconvenienceListCell")
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(asset: Asset.Color.monoLight030)?.cgColor
        $0.isHidden = true
    })
    var deleteAccountBtn = UIButton().then({
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(UIColor(asset: Asset.Color.monoWhite), for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 20)
        $0.backgroundColor = UIColor(asset: Asset.Color.priLight018Dis)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    })
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "회원탈퇴")
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(subjectLbl)
        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(selectLbl)
        view.addSubview(placeHolderLbl)
        view.addSubview(dropIc)
        view.addSubview(selectBtn)
        view.addSubview(deleteAccountBtn)
        
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        
        emptyView.snp.makeConstraints({
            $0.edges.equalTo(selectBtn.snp.edges)
        })
        subjectLbl.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(16)
        })
        selectBtn.snp.makeConstraints({
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.height.equalTo(50)
            $0.top.equalTo(subjectLbl.snp.bottom).offset(42)
        })
        selectLbl.snp.makeConstraints({
            $0.centerY.equalTo(selectBtn.snp.centerY)
            $0.leading.equalTo(selectBtn.snp.leading).offset(16)
        })
        placeHolderLbl.snp.makeConstraints({
            $0.centerY.equalTo(selectBtn.snp.centerY)
            $0.leading.equalTo(selectBtn.snp.leading).offset(16)
        })
        dropIc.snp.makeConstraints({
            $0.centerY.equalTo(selectBtn.snp.centerY)
            $0.trailing.equalTo(selectBtn.snp.trailing).offset(-16)
            $0.width.height.equalTo(20)
        })
        tableView.snp.makeConstraints({
            $0.top.equalTo(selectBtn.snp.bottom).offset(-6)
            $0.leading.equalTo(selectBtn.snp.leading)
            $0.trailing.equalTo(selectBtn.snp.trailing)
            $0.height.equalTo(225)
        })
        deleteAccountBtn.snp.makeConstraints({
            $0.height.equalTo(56)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        })
    }
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        let input = DeleteAccountViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.inconvenienceList?.drive { list in
            list.bind(to: self.tableView.rx.items(cellIdentifier: "InconvenienceListCell", cellType: InconvenienceListCell.self)) { _, item, cell in
                cell.contentLbl.text = item.contents ?? ""
            }
        }.disposed(by: disposedBag)
        
        selectBtn.rx.tap.bind {
            if self.tableView.isHidden {
                self.tableView.isHidden = false
                self.dropIc.image = UIImage(asset: Asset.Icon.chevronUp)
                if self.selectLbl.text != "이런 점이 불편했어요." {
                    self.placeHolderLbl.isHidden = true
                    self.selectLbl.isHidden = false
                } else {
                    self.placeHolderLbl.isHidden = false
                    self.selectLbl.isHidden = true
                }
            } else {
                self.tableView.isHidden = true
                self.dropIc.image = UIImage(asset: Asset.Icon.chevronDown)
                self.placeHolderLbl.isHidden = true
                self.selectLbl.isHidden = false
            }
        }.disposed(by: disposedBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let cell = self.tableView.cellForRow(at: indexPath) as? InconvenienceListCell
            self.selectLbl.text = cell?.contentLbl.text
            self.selectLbl.isHidden = false
            self.placeHolderLbl.isHidden = true
            self.tableView.isHidden = true
            self.selectItemOb.onNext(true)
        }).disposed(by: disposedBag)
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        selectItemOb.subscribe(onNext: { _ in
            self.deleteAccountBtn.backgroundColor = UIColor(asset: Asset.Color.priMain)
            self.deleteAccountBtn.isUserInteractionEnabled = true
        }).disposed(by: disposedBag)
        
        deleteAccountBtn.rx.tap.bind {
            Log.debug("탈퇴하기", "클릭")
        }.disposed(by: disposedBag)
        
        backBtn.rx.tap.bind {
            self.navigator.pop(sender: self)
        }.disposed(by: disposedBag)
        
    }
    
}

extension DeleteAccountView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
