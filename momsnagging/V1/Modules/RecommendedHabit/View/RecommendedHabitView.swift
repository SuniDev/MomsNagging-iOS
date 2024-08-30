//
//  RecommendedHabitView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/10.
//

import UIKit
import Then
import SnapKit
import RxSwift

class RecommendedHabitView: BaseViewController, Navigatable {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        action()
        viewModel.requestRecommendedHabitItemList()
    }
    // MARK: - Init
    init(viewModel: RecommendedHabitViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
        
        let output = viewModel.transform(input: RecommendedHabitViewModel.Input())
        output.headTitle?.subscribe(onNext: { data in
            self.headTitle = data.title ?? "!"
            self.cellColor = data.normalColor ?? ""
            self.cellSelectedColor = data.highlightColor ?? ""
        }).disposed(by: disposedBag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties & Variable
    var navigator: Navigator!
    var viewModel: RecommendedHabitViewModel!
    var disposedBag = DisposeBag()
    var headTitle: String = ""
    var cellColor: String = ""
    var cellSelectedColor: String = ""
    var itemList: [RecommendedHabitModel] = []
    // MARK: - UI Properties
    var backBtn = UIButton()
    var headFrame = UIView()
    var habitTableView = UITableView().then({
        $0.register(RecommendedHabitCell.self, forCellReuseIdentifier: "RecommendedHabitCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.showsVerticalScrollIndicator = false
    })
    // MARK: - initUI
    override func initUI() {
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "\(headTitle)")
    }
    // MARK: - Layout Setting
    override func layoutSetting() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        view.addSubview(headFrame)
        view.addSubview(habitTableView)
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        habitTableView.snp.makeConstraints({
            $0.top.equalTo(headFrame.snp.bottom).offset(24)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        })
    }
    // MARK: - Bind
    override func bind() {
        viewModel.itemList.subscribe(onNext: { list in
            self.itemList = list
        }).disposed(by: disposedBag)
        viewModel.itemList
            .bind(to: self.habitTableView.rx.items(cellIdentifier: "RecommendedHabitCell", cellType: RecommendedHabitCell.self)) { _, item, cell in
                cell.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
                cell.itemFrame.backgroundColor = UIColor(hexString: self.cellColor)
                cell.title.text = item.scheduleName
            }.disposed(by: disposedBag)
        habitTableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        habitTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.viewModel.itemList.subscribe ({ list in
                for i in 0..<list.element!.count {
                    let cell = self.habitTableView.cellForRow(at: [0, i]) as? RecommendedHabitCell
                    if i == indexPath.row {
                        cell?.itemFrame.backgroundColor = UIColor(hexString: self.cellSelectedColor)
                        cell?.title.textColor = UIColor(asset: Asset.Color.monoWhite)
                    } else {
                        cell?.itemFrame.backgroundColor = UIColor(hexString: self.cellColor)
                        cell?.title.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                }
            })
//            let viewModel = DetailHabitViewModel(isNew: true, isRecommendHabit: true, dateParam: self.viewModel.dateParam ?? "", homeViewModel: self.viewModel.homeViewModel ?? HomeViewModel(), recommendHabitName: self.itemList[indexPath.row].scheduleName ?? "")
            let viewModel = DetailHabitViewModelNew(modify: false, homeViewModel: (self.viewModel?.homeViewModel!)!, recommendedTitle: self.itemList[indexPath.row].scheduleName ?? "",naggingId: self.itemList[indexPath.row].naggingId ?? 0)
//            Log.debug("잔소리 아이디", self.itemList[indexPath.row].naggingId ?? 0)
            
            let cell = self.habitTableView.cellForRow(at: [0, indexPath.row]) as? RecommendedHabitCell
            cell?.itemFrame.backgroundColor = UIColor(hexString: self.cellColor)
            cell?.title.textColor = UIColor(asset: Asset.Color.monoDark010)
//            self.navigator.show(seque: .detailHabit(viewModel: viewModel), sender: self)
            self.navigator.show(seque: .detailHabitNew(viewModel: viewModel), sender: self)
        }).disposed(by: disposedBag)
        
    }
    // MARK: - Action
    func action() {
        backBtn.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposedBag)
    }

}

extension RecommendedHabitView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
