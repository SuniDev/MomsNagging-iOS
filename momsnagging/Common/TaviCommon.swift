//
//  TaviCommon.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import UIKit
import Then
import SnapKit

/*
 동시작업시 Common의 충돌 방지를 위해서 여기서 작성 후 병합 후 하나씩 Common으로 옮기겠습니당 :) 참고부탁드릴께요
 */
class TaviCommon {
    // 현재 앱의 버전을 가져오는 함수
    static func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
                let version = dictionary["CFBundleShortVersionString"] as? String,
                let _ = dictionary["CFBundleVersion"] as? String else { return "nil" }
        let versionAndBuild: String = "\(version)"
        return versionAndBuild
    }
    
    static func alarmTimeDateToStringFormatHHMM(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func alarmTimeStringToDateToString(stringData: String) -> String {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        date = dateFormatter.date(from: stringData) ?? date
        print("date!!!! : \(date)")
        let toStringFormatter = DateFormatter()
        toStringFormatter.locale = Locale(identifier: "ko_KR")
        toStringFormatter.dateFormat = "hh:mm a"
        return toStringFormatter.string(from: date)
    }
    
    enum AlertType {
        case oneBtn
        case twoBtn
    }
    static func showAlert(vc: UIViewController, type: AlertType, title: String? = "", message: String? = "", cancelTitle: String? = STR_CANCEL, doneTitle: String = STR_DONE, cancelHandler:(() -> Void)? = nil, doneHandler:(() -> Void)? = nil) {
        let attributeString = NSMutableAttributedString(string: message!)
//        let font = FontFamily.Pretendard.regular.font(size: 10)
        let font = UIFont.systemFont(ofSize: 10, weight: .regular)
        attributeString.addAttribute(.font, value: font, range: (message! as NSString).range(of: "\(message)"))
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.setValue(attributeString, forKey: "attributedMessage")
    //        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler?()
            }
            let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
                doneHandler?()
            }
            switch type {
            case .oneBtn:
                alert.addAction(doneAction)
            case .twoBtn:
                alert.addAction(cancelAction)
                alert.addAction(doneAction)
            }
            Log.debug(alert.actions)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension UIViewController {
    func showToast(message: String, naggingLevel: Int) {
        let frameView = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.black)?.withAlphaComponent(0.6)
            $0.alpha = 0.8
            $0.layer.cornerRadius = 6
        })
        let imageView = UIImageView().then({
            if naggingLevel == 0 {
                $0.image = UIImage(asset: Asset.Assets.emojiDefault)
            } else if naggingLevel == 1{
                $0.image = UIImage(asset: Asset.Assets.emojiCool)
            } else {
                $0.image = UIImage(asset: Asset.Assets.emojiAngry)
            }
        })
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor(asset: Asset.Color.monoWhite)
        toastLabel.font = FontFamily.Pretendard.bold.font(size: 16)
        toastLabel.text = message
        
        view.addSubview(frameView)
        frameView.addSubview(toastLabel)
        frameView.addSubview(imageView)
        frameView.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.centerX.equalTo(view.snp.centerX)
            $0.leading.equalTo(view.snp.leading).offset(12)
            $0.trailing.equalTo(view.snp.trailing).offset(-12)
            $0.height.equalTo(52)
        })
        imageView.snp.makeConstraints({
            $0.width.equalTo(28)
            $0.height.equalTo(26)
            $0.leading.equalTo(frameView.snp.leading).offset(12)
            $0.centerY.equalTo(frameView.snp.centerY)
        })
        toastLabel.snp.makeConstraints({
            $0.centerY.equalTo(frameView.snp.centerY)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
        })
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseOut, animations: { frameView.alpha = 0.0 }, completion: { isCompleted in
            frameView.removeFromSuperview()
        })}
}

extension HomeView {
    enum CellItemMoreType {
        case todo
        case countRoutine
        case routine
    }
    func showMorePopup(type: CellItemMoreType, itemId: Int, index: Int, vc: UIViewController, senderBtn: UIButton) {
        let emptyBtn = UIButton()
        let backgroundView = UIView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.black)?.withAlphaComponent(0.34)
        })
        let stackView = UIStackView().then({
            $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
            $0.layer.cornerRadius = 6
            $0.layer.masksToBounds = true
            $0.axis = .vertical
            $0.distribution = .fillEqually
        })
        emptyBtn.rx.tap.bind {
            backgroundView.removeFromSuperview()
        }.disposed(by: disposedBag)
        
        let modifyView = UIView()
        let modifyLbl = UILabel().then({
            $0.text = "상세"
            $0.textColor = UIColor(asset: Asset.Color.monoDark010)
            $0.font = FontFamily.Pretendard.regular.font(size: 16)
        })
        let modifyImg = UIImageView().then({
            $0.image = UIImage(asset: Asset.Icon.edit)
        })
        let modifyBtn = UIButton()
        modifyView.addSubview(modifyLbl)
        modifyView.addSubview(modifyImg)
        modifyView.addSubview(modifyBtn)
        modifyLbl.snp.makeConstraints({
            $0.centerY.equalTo(modifyView.snp.centerY)
            $0.leading.equalTo(modifyView.snp.leading).offset(29)
        })
        modifyImg.snp.makeConstraints({
            $0.centerY.equalTo(modifyView.snp.centerY)
            $0.leading.equalTo(modifyLbl.snp.trailing).offset(18)
            $0.width.height.equalTo(16)
        })
        modifyBtn.snp.makeConstraints({
            $0.edges.equalTo(modifyView.snp.edges)
        })
        
        modifyBtn.rx.tap.subscribe(onNext: {
            if type == .todo {
                let viewModel = DetailTodoViewModel(isNew: false, homeVM: self.viewModel, dateParam: self.todoListLookUpParam, todoModel: self.todoList[index])
                let vc = self.navigator.get(seque: .detailTodo(viewModel: viewModel))
                self.navigator.show(seque: .detailTodo(viewModel: viewModel), sender: vc, transition: .navigation)
            } else {
                let viewModel = DetailHabitViewModel(isNew: false, isRecommendHabit: false, dateParam: self.todoListLookUpParam, homeViewModel: self.viewModel, todoModel: self.todoList[index])
                self.navigator.show(seque: .detailHabit(viewModel: viewModel), sender: self, transition: .navigation)
            }
            backgroundView.removeFromSuperview()
        }).disposed(by: disposedBag)
        
        let deleteView = UIView()
        let deleteLbl = UILabel().then({
            $0.text = "삭제"
            $0.textColor = UIColor(asset: Asset.Color.error)
            $0.font = FontFamily.Pretendard.regular.font(size: 16)
        })
        let deleteImg = UIImageView().then({
            $0.image = UIImage(asset: Asset.Icon.deleteRed)
        })
        let deleteBtn = UIButton()
        deleteView.addSubview(deleteLbl)
        deleteView.addSubview(deleteImg)
        deleteView.addSubview(deleteBtn)
        
        deleteLbl.snp.makeConstraints({
            $0.centerY.equalTo(deleteView.snp.centerY)
            $0.leading.equalTo(deleteView.snp.leading).offset(29)
        })
        deleteImg.snp.makeConstraints({
            $0.centerY.equalTo(deleteView.snp.centerY)
            $0.leading.equalTo(deleteLbl.snp.trailing).offset(18)
            $0.width.height.equalTo(16)
        })
        deleteBtn.snp.makeConstraints({
            $0.edges.equalTo(deleteView.snp.edges)
        })
        
        deleteBtn.rx.tap.subscribe(onNext: {
            backgroundView.removeFromSuperview()
            // 삭제 API 호출
            TaviCommon.showAlert(vc: vc, type: .twoBtn, title: nil, message: "정말로 삭제할꺼니?", cancelTitle: "아니요", doneTitle: "네", cancelHandler: {

            }, doneHandler: {
                self.viewModel.requestDelete(scheduleId: itemId)
            })
//            self.viewModel.requestDelete(scheduleId: itemId)

        }).disposed(by: disposedBag)
        
        let delayView = UIView()
        let delayLbl = UILabel().then({
            $0.text = "미룸"
            $0.textColor = UIColor(asset: Asset.Color.monoDark010)
            $0.font = FontFamily.Pretendard.regular.font(size: 16)
        })
        let delayImg = UIImageView().then({
            $0.image = UIImage(asset: Asset.Icon.curveRight)
        })
        let delayBtn = UIButton()
        delayView.addSubview(delayLbl)
        delayView.addSubview(delayImg)
        delayView.addSubview(delayBtn)
        delayLbl.snp.makeConstraints({
            $0.centerY.equalTo(delayView.snp.centerY)
            $0.leading.equalTo(delayView.snp.leading).offset(29)
        })
        delayImg.snp.makeConstraints({
            $0.centerY.equalTo(delayView.snp.centerY)
            $0.leading.equalTo(delayLbl.snp.trailing).offset(18)
            $0.width.height.equalTo(16)
        })
        delayBtn.snp.makeConstraints({
            $0.edges.equalTo(delayView.snp.edges)
        })
        delayBtn.rx.tap.subscribe(onNext: {
            // 미룸 API 호출
            TaviCommon.showAlert(vc: vc, type: .twoBtn, title: nil, message: "오늘 하루 많이 바빴구나ㅠㅠ\n내일 똑같은 시간에 다시 알려줄까??", cancelTitle: "아니요", doneTitle: "네", cancelHandler: {
            }, doneHandler: {
                self.viewModel.requestDeleay(scheduleId: itemId)
            })
            backgroundView.removeFromSuperview()
        }).disposed(by: disposedBag)
        
        let skipView = UIView()
        let skipLbl = UILabel().then({
            $0.text = "건너뜀"
            $0.textColor = UIColor(asset: Asset.Color.monoDark010)
            $0.font = FontFamily.Pretendard.regular.font(size: 16)
        })
        let skipImg = UIImageView().then({
            $0.image = UIImage(asset: Asset.Icon.curveRight)
        })
        let skipBtn = UIButton()
        skipView.addSubview(skipLbl)
        skipView.addSubview(skipImg)
        skipView.addSubview(skipBtn)
        skipLbl.snp.makeConstraints({
            $0.centerY.equalTo(skipView.snp.centerY)
            $0.leading.equalTo(skipView.snp.leading).offset(20)
        })
        skipImg.snp.makeConstraints({
            $0.centerY.equalTo(skipView.snp.centerY)
            $0.leading.equalTo(skipLbl.snp.trailing).offset(18)
            $0.width.height.equalTo(16)
        })
        skipBtn.snp.makeConstraints({
            $0.edges.equalTo(skipView.snp.edges)
        })
        skipBtn.rx.tap.subscribe(onNext: {
            //건너뜀 API 호출
            backgroundView.removeFromSuperview()
        }).disposed(by: disposedBag)
        
        switch type {
        case .todo:
            view.addSubview(backgroundView)
            backgroundView.addSubview(emptyBtn)
            backgroundView.addSubview(stackView)
            stackView.addArrangedSubview(delayView)
            stackView.addArrangedSubview(modifyView)
            stackView.addArrangedSubview(deleteView)
            backgroundView.snp.makeConstraints({
                $0.top.equalTo(view.snp.top)
                $0.leading.equalTo(view.snp.leading)
                $0.trailing.equalTo(view.snp.trailing)
                $0.bottom.equalTo(view.snp.bottom)
            })
            emptyBtn.snp.makeConstraints({
                $0.edges.equalTo(backgroundView.snp.edges)
            })
            if index > 4 {
                stackView.snp.makeConstraints({
                    $0.bottom.equalTo(senderBtn.snp.centerY)
                    $0.width.equalTo(110)
                    $0.height.equalTo(150)
                    $0.trailing.equalTo(backgroundView.snp.trailing).offset(-30)
                })
            } else {
                stackView.snp.makeConstraints({
                    $0.top.equalTo(senderBtn.snp.centerY)
                    $0.width.equalTo(110)
                    $0.height.equalTo(150)
                    $0.trailing.equalTo(backgroundView.snp.trailing).offset(-30)
                })
            }
        case .countRoutine:
            view.addSubview(backgroundView)
            backgroundView.addSubview(emptyBtn)
            backgroundView.addSubview(stackView)
            stackView.addArrangedSubview(skipView)
            stackView.addArrangedSubview(modifyView)
            stackView.addArrangedSubview(deleteView)
            backgroundView.snp.makeConstraints({
                $0.top.equalTo(view.snp.top)
                $0.leading.equalTo(view.snp.leading)
                $0.trailing.equalTo(view.snp.trailing)
                $0.bottom.equalTo(view.snp.bottom)
            })
            emptyBtn.snp.makeConstraints({
                $0.edges.equalTo(backgroundView.snp.edges)
            })
            if index > 4 {
                stackView.snp.makeConstraints({
                    $0.bottom.equalTo(senderBtn.snp.centerY)
                    $0.width.equalTo(110)
                    $0.height.equalTo(150)
                    $0.trailing.equalTo(backgroundView.snp.trailing).offset(-30)
                })
            } else {
                stackView.snp.makeConstraints({
                    $0.top.equalTo(senderBtn.snp.centerY)
                    $0.width.equalTo(110)
                    $0.height.equalTo(150)
                    $0.trailing.equalTo(backgroundView.snp.trailing).offset(-30)
                })
            }
        case .routine:
            view.addSubview(backgroundView)
            backgroundView.addSubview(emptyBtn)
            backgroundView.addSubview(stackView)
            stackView.addArrangedSubview(modifyView)
            stackView.addArrangedSubview(deleteView)
            backgroundView.snp.makeConstraints({
                $0.top.equalTo(view.snp.top)
                $0.leading.equalTo(view.snp.leading)
                $0.trailing.equalTo(view.snp.trailing)
                $0.bottom.equalTo(view.snp.bottom)
            })
            emptyBtn.snp.makeConstraints({
                $0.edges.equalTo(backgroundView.snp.edges)
            })
            if index > 4 {
                stackView.snp.makeConstraints({
                    $0.bottom.equalTo(senderBtn.snp.centerY)
                    $0.width.equalTo(110)
                    $0.height.equalTo(100)
                    $0.trailing.equalTo(backgroundView.snp.trailing).offset(-30)
                })
            } else {
                stackView.snp.makeConstraints({
                    $0.top.equalTo(senderBtn.snp.centerY)
                    $0.width.equalTo(110)
                    $0.height.equalTo(100)
                    $0.trailing.equalTo(backgroundView.snp.trailing).offset(-30)
                })
            }
        }
    }
}
