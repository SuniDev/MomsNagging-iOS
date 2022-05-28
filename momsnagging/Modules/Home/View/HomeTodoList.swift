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
    
//    func listBtnActionInputData(listBtnAction: Bool) {
//
//    }
    @objc func selectTodoCheck(_ sender: UIButton) {
        if sender.accessibilityLabel == "true" {
            self.viewModel.requestRoutineCancel(scheduleId: sender.tag)
        } else if sender.accessibilityLabel == "false" {
            self.viewModel.requestRoutineDone(scheduleId: sender.tag)
        }
    }
    @objc func selectRoutineCheck(_ sender: UIButton) {
        if sender.accessibilityLabel == "true" {
            self.viewModel.requestRoutineCancel(scheduleId: sender.tag)
        } else if sender.accessibilityLabel == "false" {
            self.viewModel.requestRoutineDone(scheduleId: sender.tag)
        }
    }
    @objc func selectCountRoutineCheck(_ sender: UIButton) {
        if sender.accessibilityLabel == "true" {
            self.viewModel.requestRoutineCancel(scheduleId: sender.tag)
        } else if sender.accessibilityLabel == "false" {
            self.viewModel.requestRoutineDone(scheduleId: sender.tag)
        }
    }
    
    func todoBind() {
        let dv = viewModel.todoListDataObserver.asDriverOnErrorJustComplete()
        dv.drive { list in
            list.bind(to: self.todoListTableView.rx.items) { tableView, row, item -> UITableViewCell in
                self.todoList.append(item)
                if item.goalCount == 0 {
                    if item.scheduleType == "TODO" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: IndexPath.init(row: row, section: 0)) as? TodoCell
    //                    cell?.todoIsSelected = item.done ?? false
                        cell?.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
                        cell?.titleLbl.text = item.scheduleName ?? ""
                        
                        if item.done == true {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                        } else if item.done == false {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoNonSelect), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoWhite)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.priMain)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        } else {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.delay), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.subLight010)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.subLight020)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.subLight020)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        }
                        if item.done != nil {
                            cell?.toggleIc.accessibilityLabel = "\(item.done ?? false)"
                        }
                        cell?.toggleIc.tag = item.id ?? 0
                        cell?.toggleIc.addTarget(self, action: #selector(self.selectTodoCheck), for: .touchUpInside)
                        
                        self.todoListType.append(0)
                        return cell!
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: IndexPath.init(row: row, section: 0)) as? RoutineCell
                        cell?.todoIsSelected = item.done ?? false
                        cell?.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
                        cell?.titleLbl.text = item.scheduleName ?? ""
                        
                        if item.done == true {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                            
                        } else if item.done == false {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoNonSelect), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoWhite)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.priMain)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        } else {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.delay), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.subLight010)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.subLight020)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.subLight020)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        }
                        
                        if item.done != nil {
                            cell?.toggleIc.accessibilityLabel = "\(item.done ?? false)"
                        }
                        cell?.toggleIc.tag = item.id ?? 0
                        cell?.toggleIc.addTarget(self, action: #selector(self.selectRoutineCheck), for: .touchUpInside)
                        self.todoListType.append(1)
                        return cell!
                    }
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCountCell", for: IndexPath.init(row: row, section: 0)) as? RoutineCountCell
                    cell?.todoIsSelected = item.done ?? false
                    cell?.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
                    cell?.titleLbl.text = item.scheduleName ?? ""
                    cell?.prefixLbl.text = "\(item.goalCount ?? 0)회"
                    
                    if item.done == true {
                        cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
                        cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                        cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
                        cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                        cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                        cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                        cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                    } else if item.done == false {
                        cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoNonSelect), for: .normal)
                        cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
                        cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
                        cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                        cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.subLight030)
                        cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                    } else {
                        cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.delay), for: .normal)
                        cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.subLight010)
                        cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
                        cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.subLight020)
                        cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                        cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.subLight020)
                        cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark010)
                    }
                    
                    if item.done != nil {
                        cell?.toggleIc.accessibilityLabel = "\(item.done ?? false)"
                    }
                    cell?.toggleIc.tag = item.id ?? 0
                    cell?.toggleIc.addTarget(self, action: #selector(self.selectCountRoutineCheck), for: .touchUpInside)
                    self.todoListType.append(2)
                    return cell!
                }
            }.disposed(by: disposedBag)
        }
        viewModel.isEndProgress.subscribe(onNext: { _ in
            Log.debug("endProgress", "!")
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
        
        viewModel.addHabitSuccessOb.subscribe(onNext: { _ in
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
        }).disposed(by: disposedBag)
        
        viewModel.toggleIcSuccessOb.subscribe(onNext: { _ in
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            self.showToast(message: "우리 ~~ 너무너무 잘했어~^^")
        }).disposed(by: disposedBag)
        viewModel.toggleCancelOb.subscribe(onNext: { _ in
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
        }).disposed(by: disposedBag)
        
        todoListTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let row = self.todoList[indexPath.row]
            if row.scheduleType == "TODO" {
                // 투두 페이지로 이동
                let viewModel = DetailTodoViewModel(isNew: false, homeVM: self.viewModel, dateParam: self.todoListLookUpParam, todoModel: row)
                self.navigator.show(seque: .detailTodo(viewModel: viewModel), sender: self, transition: .navigation)
            } else if row.scheduleType == "ROUTINE" {
                // 루틴 페이지로 이동
                let viewModel = DetailHabitViewModel(isNew: false, isRecommendHabit: false, dateParam: self.todoListLookUpParam, homeViewModel: self.viewModel, todoModel: row)
                self.navigator.show(seque: .detailHabit(viewModel: viewModel), sender: self, transition: .navigation)
            }
        }).disposed(by: disposedBag)
        
//        collectionViewOutput?.todoListData?.drive { list in
//            list.bind(to: self.todoListTableView.rx.items(cellIdentifier: "HomeTodoListCell", cellType: HomeTodoListCell.self)) { _, item, cell in
//                self.todoList.append(item)
//                cell.contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
//                print("listTest : \(item)")
//                cell.todoIsSelected = item.done ?? false
//                cell.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
//                cell.titleLbl.text = item.scheduleName ?? ""
//                if item.scheduleType == "TODO" {
//
//                } else if item.scheduleType == "ROUTINE" {
//
//                }
////                cell.prefixLbl.text = item.prefix ?? ""
////                cell.cellType = item.type ?? .normal
//                self.collectionViewOutput?.listBtnStatus?.drive {
//                    cell.sortIc.isHidden = !$0
//                }.disposed(by: self.disposedBag)
//                /*
//                 select colorList
//                 0 : contentViewColor
//                 1 : timeBtnbackground
//                 2 : timeLbl
//                 3 : prefixBackground
//                 4 : prefixLbl
//                 */
////                if item.type == .todo {
//////                    print("itemType: \(item.type)")
//
////                    cell.toggleIc.rx.tap.bind { colorList in
////                        if cell.toggleIc.isSelected {
////                            cell.toggleIc.isSelected = false
////                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: false)
////                            lazy var output = viewModel.transform(input: input)
////                            output.toggleImage.drive { img in
////                                cell.toggleIc.setImage(img, for: .normal)
////                            }.disposed(by: self.disposedBag)
////                            output.cellColorList.drive { colorList in
////                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
////                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
////                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
////                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
////                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
////                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
////                            }.disposed(by: self.disposedBag)
////                        } else {
////                            cell.toggleIc.isSelected = true
////                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: true)
////                            lazy var output = viewModel.transform(input: input)
////                            output.toggleImage.drive { img in
////                                cell.toggleIc.setImage(img, for: .normal)
////                            }.disposed(by: self.disposedBag)
////                            output.cellColorList.drive { colorList in
////                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
////                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
////                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
////                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
////                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
////                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
////                            }.disposed(by: self.disposedBag)
////                        }
////                    }.disposed(by: self.disposedBag)
//
////                } else if item.type == .count {
////                    cell.toggleIc.rx.tap.bind { colorList in
////                        if cell.toggleIc.isSelected {
////                            cell.toggleIc.isSelected = false
////                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: false, cellType: .count)
////                            lazy var output = viewModel.transform(input: input)
////                            output.toggleImage.drive { img in
////                                cell.toggleIc.setImage(img, for: .normal)
////                            }.disposed(by: self.disposedBag)
////                            output.cellColorList.drive { colorList in
////                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
////                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
////                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
////                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
////                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
////                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
////                            }.disposed(by: self.disposedBag)
////                        } else {
////                            cell.toggleIc.isSelected = true
////                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: true, cellType: .count)
////                            lazy var output = viewModel.transform(input: input)
////                            output.toggleImage.drive { img in
////                                cell.toggleIc.setImage(img, for: .normal)
////                            }.disposed(by: self.disposedBag)
////                            output.cellColorList.drive { colorList in
////                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
////                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
////                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
////                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
////                                cell.prefixView.backgroundColor = UIColor(asset: colorList[3])
////                                cell.prefixLbl.textColor = UIColor(asset: colorList[4])
////                            }.disposed(by: self.disposedBag)
////                        }
////                    }.disposed(by: self.disposedBag)
////                } else {
////                    cell.toggleIc.rx.tap.bind { colorList in
////                        if cell.toggleIc.isSelected {
////                            cell.toggleIc.isSelected = false
////                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: false, cellType: .normal)
////                            lazy var output = viewModel.transform(input: input)
////                            output.toggleImage.drive { img in
////                                cell.toggleIc.setImage(img, for: .normal)
////                            }.disposed(by: self.disposedBag)
////                            output.cellColorList.drive { colorList in
////                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
////                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
////                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
////                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
////                            }.disposed(by: self.disposedBag)
////                        } else {
////                            cell.toggleIc.isSelected = true
////                            lazy var input = HomeViewModel.Input(floatingBtnStatus: nil, selectStatus: true, cellType: .normal)
////                            lazy var output = viewModel.transform(input: input)
////                            output.toggleImage.drive { img in
////                                cell.toggleIc.setImage(img, for: .normal)
////                            }.disposed(by: self.disposedBag)
////                            output.cellColorList.drive { colorList in
////                                cell.contentView.backgroundColor = UIColor(asset: colorList[0])
////                                cell.timeBtn.backgroundColor = UIColor(asset: colorList[1])
////                                cell.timeBtn.setTitleColor(UIColor(asset: colorList[2]), for: .normal)
////                                cell.titleLbl.textColor = UIColor(asset: colorList[2])
////                            }.disposed(by: self.disposedBag)
////                        }
////                    }.disposed(by: self.disposedBag)
////                }
//            }.disposed(by: disposedBag)
//        }
        todoListTableView.rx.setDelegate(self).disposed(by: disposedBag)
        todoListTableView.dragDelegate = self
        todoListTableView.dropDelegate = self
        todoListTableView.dragInteractionEnabled = false
    }
}

extension HomeView: UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate, UIDropInteractionDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = todoList[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        lazy var input = HomeViewModel.Input(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        lazy var output = viewModel.transform(input: input)
        output.todoListData?.drive { list in
            Log.debug("List!!", "\(list)")
        }.disposed(by: disposedBag)
        print("moveRowAt !")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
