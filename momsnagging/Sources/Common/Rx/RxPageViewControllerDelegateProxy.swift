//
//  RxPageViewControllerDelegateProxy.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//
import RxSwift
import RxCocoa
import UIKit

// 1. UIPageViewController에 대한 DelegateProxy 정의
class RxPageViewControllerDelegateProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>, DelegateProxyType, UIPageViewControllerDelegate {

    // 필수 메서드 구현
    static func registerKnownImplementations() {
        self.register { pageViewController in
            RxPageViewControllerDelegateProxy(parentObject: pageViewController, delegateProxy: RxPageViewControllerDelegateProxy.self)
        }
    }

    // 기존 delegate에 대한 참조
    static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: UIPageViewControllerDelegate?, to object: UIPageViewController) {
        object.delegate = delegate
    }
}
