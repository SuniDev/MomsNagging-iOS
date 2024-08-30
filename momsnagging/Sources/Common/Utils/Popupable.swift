//
//  Popupable.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import UIKit
import SnapKit
import RxSwift

protocol Popupable where Self: UIViewController {
    func showPopup(
        type: BasePopupView.PopupType,
        title: String,
        message: String,
        cancelTitle: String?,
        doneTitle: String?,
        cancelHandler: (() -> Void)?,
        doneHandler: (() -> Void)?
    )
}

extension Popupable {
    
    func showPopup(
        type: BasePopupView.PopupType,
        title: String = "",
        message: String = "",
        cancelTitle: String? = nil,
        doneTitle: String? = nil,
        cancelHandler: (() -> Void)? = nil,
        doneHandler: (() -> Void)? = nil
    ) {
        let popup = BasePopupView()
        popup.setUI(
            popupType: type,
            title: title,
            message: message,
            cancelTitle: cancelTitle ?? "Cancel",
            doneTitle: doneTitle ?? "OK",
            cancelHandler: cancelHandler,
            doneHandler: doneHandler
        )
        
        popup.showAnim(vc: self, parentAddView: nil, completion: nil)
    }
    
    func hidePopup() {
        if let popup = children.compactMap({ $0 as? BasePopupView }).first {
            popup.hideAnim()
        }
    }
}

