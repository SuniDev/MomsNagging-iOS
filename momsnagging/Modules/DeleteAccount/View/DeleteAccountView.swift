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
//    var selectItemOb = PublishSubject<Bool>()
    
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
        $0.register(DeleteAccountReasonCell.self, forCellReuseIdentifier: "DeleteAccountReasonCell")
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(asset: Asset.Color.monoLight030)?.cgColor
        $0.isHidden = true
    })
    var deleteAccountBtn = CommonButton().then({
        $0.normalBackgroundColor = Asset.Color.priMain.color
        $0.highlightedBackgroundColor = Asset.Color.priDark010.color
        $0.disabledBackgroundColor = Asset.Color.priLight018Dis.color
        $0.layer.cornerRadius = 20
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
        $0.isEnabled = false
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
        
        let confirmDeleteAlertHandler = PublishRelay<Bool>()
        let successDeleteAlertHandler = PublishRelay<Void>()
        
        let input = DeleteAccountViewModel.Input(
            willAppearView: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
            btnBackTapped: self.backBtn.rx.tap.asDriverOnErrorJustComplete(),
            btnSelectTapped: self.selectBtn.rx.tap.asDriverOnErrorJustComplete(),
            reasonItemSelected: self.tableView.rx.itemSelected.asDriverOnErrorJustComplete(),
            btnDeleteAccountTapped: self.deleteAccountBtn.rx.tap.asDriverOnErrorJustComplete(),
            confirmDeleteAlertHandler: confirmDeleteAlertHandler.asDriverOnErrorJustComplete(),
            successDeleteAlertHandler: successDeleteAlertHandler.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.reasonItems
            .asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "DeleteAccountReasonCell", cellType: DeleteAccountReasonCell.self)) { _, item, cell in
                cell.contentLbl.text = item
            }.disposed(by: disposedBag)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposedBag)
        
        output.isShowReasonList
            .drive(onNext: { isShow in
                self.tableView.isHidden = !isShow
                self.dropIc.image = isShow ? Asset.Icon.chevronUp.image : Asset.Icon.chevronDown.image
            }).disposed(by: disposedBag)
        
        output.isShowPlaceHolder
            .drive(onNext: { isShow in
                self.placeHolderLbl.isHidden = !isShow
                self.selectLbl.isHidden = isShow
            }).disposed(by: disposedBag)
        
        output.setReasonText
            .drive(onNext: { text in
                self.selectLbl.text = text
            }).disposed(by: disposedBag)
        
        output.isEnabledBtnDeleteAccount
            .drive(onNext: { isEnabled in
                self.deleteAccountBtn.isEnabled = isEnabled
            }).disposed(by: disposedBag)
        
        output.showConfirmDeleteAlert
            .drive(onNext: { alert in
                CommonView.showAlert(vc: self, type: .twoBtn, title: alert.title, message: alert.message, cancelTitle: alert.cancelTitle, doneTitle: alert.doneTitle ?? STR_YES) {
                    confirmDeleteAlertHandler.accept(false)
                } doneHandler: {
                    confirmDeleteAlertHandler.accept(true)
                }
            }).disposed(by: disposedBag)
        
        output.showSuccessDeleteAlert
            .drive(onNext: { alert in
                CommonView.showAlert(vc: self, type: .oneBtn, title: alert.title, message: alert.message, doneTitle: alert.doneTitle ?? STR_CLOSE, doneHandler: {
                    successDeleteAlertHandler.accept(())
                })
            }).disposed(by: disposedBag)
        
        output.goToLogin
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .login(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposedBag)
        
        self.tableView.rx.setDelegate(self).disposed(by: disposedBag)
    }
}

extension DeleteAccountView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
