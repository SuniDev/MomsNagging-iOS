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
import RxDataSources

/**
 # HomeTodoList, HomeViewExtension
 - Authors: tavi
 - Note: HomeView의 TodoList만 따로 빼서 처리하기 위해 빼놨습니다
 */
extension HomeView {
    
    func setTodoTableView() {
        let bottomEmptyImge = UIImageView().then({
            $0.image = UIImage(asset: Asset.Assets.todoBottomEmptyImage)
        })
        view.addSubview(tableViewTopDivider)
        view.addSubview(todoListTableView)
        view.addSubview(listEmptyFrame)
        todoListTableView.addSubview(bottomEmptyImge)
        todoListTableView.contentInset.bottom = 100
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
        listEmptyFrame.snp.makeConstraints({
            $0.edges.equalTo(todoListTableView.snp.edges)
        })
        bottomEmptyImge.snp.makeConstraints({
            $0.top.equalTo(todoListTableView.snp.bottom).offset(-100)
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
        if checkBtnInteractionEnable {
            if sender.accessibilityLabel == "1" {
                self.viewModel.requestRoutineCancel(scheduleId: sender.tag)
            } else if sender.accessibilityLabel == "0" {
                self.viewModel.requestRoutineDone(scheduleId: sender.tag)
            }
        }
    }
    @objc func selectRoutineCheck(_ sender: UIButton) {
        if checkBtnInteractionEnable {
            if sender.accessibilityLabel == "1" {
                self.viewModel.requestRoutineCancel(scheduleId: sender.tag)
            } else if sender.accessibilityLabel == "0" {
                self.viewModel.requestRoutineDone(scheduleId: sender.tag)
            }
        }
    }
    @objc func selectCountRoutineCheck(_ sender: UIButton) {
        if checkBtnInteractionEnable {
            if sender.accessibilityLabel == "1" {
                self.viewModel.requestRoutineCancel(scheduleId: sender.tag)
            } else if sender.accessibilityLabel == "0" {
                self.viewModel.requestRoutineDone(scheduleId: sender.tag)
            }
        }
//        showMorePopup(type: .todo, itemId: 0, index: 1)
    }
    
    @objc func selectTodoMoreAction(_ sender: UIButton) {
        Log.debug("todoListDebug", "\(todoList), \(todoList.count)")
        Log.debug("senderTag 투두", "\(sender.tag)")
        let itemId = todoList[sender.tag]
        showMorePopup(type: .todo, itemId: itemId.id ?? 0, index: sender.tag, vc: self, senderBtn: sender)
    }
    @objc func selectRoutineMoreAction(_ sender: UIButton) {
        Log.debug("todoListDebug", "\(todoList), \(todoList.count)")
        Log.debug("senderTag 습관요일", "\(sender.tag)")
        let itemId = todoList[sender.tag]
        showMorePopup(type: .routine, itemId: itemId.id ?? 0, index: sender.tag, vc: self, senderBtn: sender)
    }
    @objc func selectCountRoutineMoreAction(_ sender: UIButton) {
        Log.debug("todoListDebug", "\(todoList), \(todoList.count)")
        Log.debug("senderTag 습관횟수", "\(sender.tag)")
        let itemId = todoList[sender.tag]
        showMorePopup(type: .countRoutine, itemId: itemId.id ?? 0, index: sender.tag, vc: self, senderBtn: sender)
    }
    
    func todoBind() {
//        viewModel.todoListDataOB.subscribe(onNext: { list in
//            self.todoList = list
//        }).disposed(by: disposedBag)
//        viewModel.todoListDataObserver.subscribe(onNext: { list in
//            self.todoList = list
//        }).disposed(by: disposedBag)
        let dv = viewModel.todoListDataObserver.asDriverOnErrorJustComplete()
        dv.drive { list in
            self.todoList = list
        }.disposed(by: disposedBag)
        dv.drive { list in
            list.bind(to: self.todoListTableView.rx.items) { tableView, row, item -> UITableViewCell in
                Log.debug("itemLog", "\(item), \(row)")
//                if row == 0 {
//                    self.todoList.removeAll()
//                }
//                self.todoList.append(item)s
                self.moveList = self.todoList
                if item.goalCount == 0 {
                    if item.scheduleType == "TODO" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: IndexPath.init(row: row, section: 0)) as? TodoCell
    //                    cell?.todoIsSelected = item.done ?? false
                        cell?.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
                        cell?.titleLbl.text = item.scheduleName ?? ""
                        
                        if item.status == 1 {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                        } else if item.status == 0 {
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
                        cell?.toggleIc.accessibilityLabel = "\(item.status ?? 0)"
                        cell?.toggleIc.tag = item.id ?? 0
                        cell?.toggleIc.addTarget(self, action: #selector(self.selectTodoCheck), for: .touchUpInside)
                        cell?.moreIc.tag = row
                        cell?.moreIc.addTarget(self, action: #selector(self.selectTodoMoreAction), for: .touchUpInside)
                        if self.checkBtnInteractionEnable {
                            cell?.moreIc.isHidden = false
                            cell?.sortIc.isHidden = true
                        } else {
                            cell?.moreIc.isHidden = true
                            cell?.sortIc.isHidden = false
                        }
                        
                        self.todoListType.append(0)
                        return cell!
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: IndexPath.init(row: row, section: 0)) as? RoutineCell
                        cell?.todoIsSelected = item.done ?? false
                        cell?.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
                        cell?.titleLbl.text = item.scheduleName ?? ""
                        
                        if item.status == 1 {
                            cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
                            cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                            cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
                            cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                            cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                            cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                            
                        } else if item.status == 0 {
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
                        cell?.toggleIc.accessibilityLabel = "\(item.status ?? 0)"
                        cell?.toggleIc.tag = item.id ?? 0
                        cell?.toggleIc.addTarget(self, action: #selector(self.selectRoutineCheck), for: .touchUpInside)
                        cell?.moreIc.tag = row
                        cell?.moreIc.addTarget(self, action: #selector(self.selectRoutineMoreAction), for: .touchUpInside)
                        if self.checkBtnInteractionEnable {
                            cell?.moreIc.isHidden = false
                            cell?.sortIc.isHidden = true
                        } else {
                            cell?.moreIc.isHidden = true
                            cell?.sortIc.isHidden = false
                        }
                        self.todoListType.append(1)
                        return cell!
                    }
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCountCell", for: IndexPath.init(row: row, section: 0)) as? RoutineCountCell
                    cell?.todoIsSelected = item.done ?? false
                    cell?.timeBtn.setTitle(item.scheduleTime ?? "", for: .normal)
                    cell?.titleLbl.text = item.scheduleName ?? ""
                    cell?.prefixLbl.text = "\(item.goalCount ?? 0)회"
                    
                    if item.status == 1 {
                        cell?.toggleIc.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
                        cell?.contentView.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
                        cell?.timeBtn.setTitleColor(UIColor(asset: Asset.Color.monoDark020), for: .normal)
                        cell?.timeBtn.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                        cell?.prefixLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                        cell?.prefixView.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
                        cell?.titleLbl.textColor = UIColor(asset: Asset.Color.monoDark020)
                    } else if item.status == 0 {
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
                    
                    cell?.toggleIc.accessibilityLabel = "\(item.status ?? 0)"
                    cell?.toggleIc.tag = item.id ?? 0
                    cell?.toggleIc.addTarget(self, action: #selector(self.selectCountRoutineCheck), for: .touchUpInside)
                    cell?.moreIc.tag = row
                    cell?.moreIc.addTarget(self, action: #selector(self.selectCountRoutineMoreAction), for: .touchUpInside)
                    if self.checkBtnInteractionEnable {
                        cell?.moreIc.isHidden = false
                        cell?.sortIc.isHidden = true
                    } else {
                        cell?.moreIc.isHidden = true
                        cell?.sortIc.isHidden = false
                    }
                    self.todoListType.append(2)
                    return cell!
                }
            }.disposed(by: disposedBag)
        }
        viewModel.isEndProgress.subscribe(onNext: { _ in
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
        
        viewModel.addHabitSuccessOb.subscribe(onNext: { _ in
//            self.todoList.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
        
        viewModel.toggleIcSuccessOb.subscribe(onNext: { _ in
//            self.todoList.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            Log.debug("잔소리레벨!", "\(CommonUser.naggingLevel)")
            switch CommonUser.naggingLevel {
            case .fondMom:
                self.showToast(message: "우리 \(CommonUser.nickName ?? "") 너무너무 잘했어~^^", naggingLevel: 0)
            case .coolMom:
                self.showToast(message: "열심히 했네.", naggingLevel: 1)
            case .angryMom:
                self.showToast(message: "이렇게 잘할 줄 알았으면 진작부터 잘하지!", naggingLevel: 2)
            }
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
        viewModel.toggleCancelOb.subscribe(onNext: { _ in
//            self.todoList.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
        viewModel.delaySuccessOb.subscribe(onNext: { _ in
//            self.todoList.removeAll()
            self.viewModel.requestTodoListLookUp(date: self.todoListLookUpParam)
            self.todoListTableView.reloadData()
        }).disposed(by: disposedBag)
        
//        todoListTableView.rx.itemSelected.subscribe(onNext: { indexPath in
//            let row = self.todoList[indexPath.row]
//            if row.scheduleType == "TODO" {
//                // 투두 페이지로 이동
//                let viewModel = DetailTodoViewModel(isNew: false, homeVM: self.viewModel, dateParam: self.todoListLookUpParam, todoModel: row)
//                self.navigator.show(seque: .detailTodo(viewModel: viewModel), sender: self, transition: .navigation)
//            } else if row.scheduleType == "ROUTINE" {
//                // 루틴 페이지로 이동
//                let viewModel = DetailHabitViewModel(isNew: false, isRecommendHabit: false, dateParam: self.todoListLookUpParam, homeViewModel: self.viewModel, todoModel: row)
//                self.navigator.show(seque: .detailHabit(viewModel: viewModel), sender: self, transition: .navigation)
//            }
//        }).disposed(by: disposedBag)
        
        // 이동 처리
        todoListTableView.rx.itemMoved.bind { sIndexPath, dIndexPath in
            Log.debug("이동처리의 todo", "\(self.todoList)")
            
            let sRow = self.todoList[sIndexPath.row]
            let dRow = self.todoList[dIndexPath.row]
            let sIndex = sIndexPath.row
            let dIndex = dIndexPath.row
            
            if dIndex > sIndex { // 위에서 밑으로
                let count = -(sIndex - dIndex)
                for i in sIndex + 1...count {
                    var model = ScheduleArrayModel(oneOriginalId: self.todoList[sIndex].originalId ?? 0, theOtherOriginalId: self.todoList[i].originalId ?? 0)
                    self.moveListModel.append(model)
                }
            } else if dIndex < sIndex { // 밑에서 위로
                print("밑에서 위로 \(sIndex - dIndex)")
                let count = sIndex - dIndex
                for i in (0...count - 1).reversed() {
                    var model = ScheduleArrayModel(oneOriginalId: self.todoList[sIndex].originalId ?? 0, theOtherOriginalId: self.todoList[i].originalId ?? 0)
                    self.moveListModel.append(model)
                }
            }
//            var model = ScheduleArrayModel()
//            model.oneOriginalId = self.todoList[sIndexPath.row].originalId ?? 0
//            model.theOtherOriginalId = self.todoList[dIndexPath.row].originalId ?? 0
//            self.moveListModel.append(model)
//            self.moveList[sIndexPath.row] = dRow
//            self.moveList[dIndexPath.row] = sRow
//            print("moveRowAt ! \(sIndexPath),\(dIndexPath),\n \(self.todoList),\n\n \(self.moveList)")
        }.disposed(by: disposedBag)
        
        viewModel.emptyViewStatusOb.subscribe(onNext: { bool in
            if globalCoachMarkStatusCheck ?? false {
                self.listEmptyFrame.isHidden = bool
            } else {
                self.listEmptyFrame.isHidden = true
            }
        }).disposed(by: disposedBag)
        
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
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
