//
//  HomeTodoList.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/07.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

/**
 # HomeTodoList, HomeViewExtension
 - Authors: tavi
 - Note: HomeView의 TodoList만 따로 빼서 처리하기 위해 빼놨습니다
 */
extension HomeView {
    
    func setTodoTableView() {
        view.addSubview(tableViewTopDivider)
        view.addSubview(todoListTableView)
        tableViewTopDivider.snp.makeConstraints({
            $0.top.equalTo(weekCalendarCollectionView.snp.bottom)
            $0.height.equalTo(1)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
        })
        todoListTableView.snp.makeConstraints({
            $0.top.equalTo(tableViewTopDivider.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        todoBind()
    }
    
    static func cellTodoIconView(lbl: UILabel, count: Int?, isDone: Bool) -> UIView {
        let view = UIView().then({
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        })
        lbl.font = FontFamily.Pretendard.semiBold.font(size: 12)
        if count != nil {
            view.backgroundColor = UIColor(asset: Asset.Color.subLight030)
            lbl.textColor = UIColor(asset: Asset.Color.monoDark010)
            lbl.text = "\(count!)회"
        } else {
            view.backgroundColor = UIColor(asset: Asset.Color.priMain)
            lbl.textColor = UIColor(asset: Asset.Color.monoWhite)
            lbl.text = "할일"
        }
        if isDone {
            view.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
            lbl.textColor = UIColor(asset: Asset.Color.monoDark020)
        }
        return view
    }
    
    func todoBind() {
        guard let viewModel = viewModel else { return }
        lazy var input = HomeViewModel.Input()
        lazy var output = viewModel.transform(input: input)
        var toggleStatus: Bool = false
        output.todoListData?.drive(onNext: { list in
            Log.debug("todoListData : ", "\(list)")
        }).disposed(by: disposedBag)
        output.todoListData?.drive { list in
            list.bind(to: self.todoListTableView.rx.items(cellIdentifier: "HomeTodoListCell", cellType: HomeTodoListCell.self)) { index, item, cell in
                cell.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
                cell.todoIsSelected = item.isSelected ?? false
                cell.timeBtn.setTitle(item.time ?? "", for: .normal)
                cell.titleLbl.text = item.title ?? ""
                cell.prefixLbl.text = item.prefix ?? ""
                cell.cellType = item.type
                /*
                 select colorList
                 0 : contentViewColor
                 1 : timeBtnbackground
                 2 : timeLbl
                 3 : prefixBackground
                 4 : prefixLbl
                 */
                if item.type == .todo {
                    print("itemType: \(item.type)")
                    cell.toggleIc.rx.tap.bind { colorList in
                        if cell.toggleIc.isSelected {
                            cell.toggleIc.isSelected = false
                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: false, cellType: .todo)
                            lazy var output = viewModel.transform(input: input)
                            output.toggleImage.drive { img in
                                cell.toggleIc.setImage(img, for: .normal)
                            }.disposed(by: self.disposedBag)
                            output.cellColorList.drive { colorList in
                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
                            }.disposed(by: self.disposedBag)
                        } else {
                            cell.toggleIc.isSelected = true
                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: true, cellType: .todo)
                            lazy var output = viewModel.transform(input: input)
                            output.toggleImage.drive { img in
                                cell.toggleIc.setImage(img, for: .normal)
                            }.disposed(by: self.disposedBag)
                            output.cellColorList.drive { colorList in
                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
                            }.disposed(by: self.disposedBag)
                        }
                    }.disposed(by: self.disposedBag)
                } else if item.type == .count {
                    cell.toggleIc.rx.tap.bind { colorList in
                        if cell.toggleIc.isSelected {
                            cell.toggleIc.isSelected = false
                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: false, cellType: .count)
                            lazy var output = viewModel.transform(input: input)
                            output.toggleImage.drive { img in
                                cell.toggleIc.setImage(img, for: .normal)
                            }.disposed(by: self.disposedBag)
                            output.cellColorList.drive { colorList in
                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
                            }.disposed(by: self.disposedBag)
                        } else {
                            cell.toggleIc.isSelected = true
                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: true, cellType: .count)
                            lazy var output = viewModel.transform(input: input)
                            output.toggleImage.drive { img in
                                cell.toggleIc.setImage(img, for: .normal)
                            }.disposed(by: self.disposedBag)
                            output.cellColorList.drive { colorList in
                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
                            }.disposed(by: self.disposedBag)
                        }
                    }.disposed(by: self.disposedBag)
                } else {
                    cell.toggleIc.rx.tap.bind { colorList in
                        if cell.toggleIc.isSelected {
                            cell.toggleIc.isSelected = false
                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: false, cellType: .normal)
                            lazy var output = viewModel.transform(input: input)
                            output.toggleImage.drive { img in
                                cell.toggleIc.setImage(img, for: .normal)
                            }.disposed(by: self.disposedBag)
                            output.cellColorList.drive { colorList in
                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
                            }.disposed(by: self.disposedBag)
                        } else {
                            cell.toggleIc.isSelected = true
                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: true, cellType: .normal)
                            lazy var output = viewModel.transform(input: input)
                            output.toggleImage.drive { img in
                                cell.toggleIc.setImage(img, for: .normal)
                            }.disposed(by: self.disposedBag)
                            output.cellColorList.drive { colorList in
                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
                            }.disposed(by: self.disposedBag)
                        }
                    }.disposed(by: self.disposedBag)
                }
            
            }.disposed(by: disposedBag)
        }
        todoListTableView.rx.setDelegate(self).disposed(by: disposedBag)
    }
}

extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
